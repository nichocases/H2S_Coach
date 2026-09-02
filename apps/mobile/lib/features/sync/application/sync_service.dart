import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:inline_hockey_coach/data/local/drift/app_database.dart';
import 'package:inline_hockey_coach/data/repositories/sync_queue_repository.dart';
import 'package:inline_hockey_coach/domain/entities/hockey_enums.dart';
import 'package:uuid/uuid.dart';

abstract interface class ConnectivityGateway {
  Future<bool> get isOnline;

  Stream<bool> get onConnectivityChanged;
}

class ConnectivityPlusGateway implements ConnectivityGateway {
  ConnectivityPlusGateway({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  @override
  Future<bool> get isOnline async {
    try {
      return _hasNetwork(await _connectivity.checkConnectivity());
    } on Object {
      return false;
    }
  }

  @override
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged
        .map(_hasNetwork)
        .transform(
          StreamTransformer.fromHandlers(
            handleError: (_, _, sink) => sink.add(false),
          ),
        );
  }

  bool _hasNetwork(Object value) {
    if (value is ConnectivityResult) {
      return value != ConnectivityResult.none;
    }
    if (value is Iterable<ConnectivityResult>) {
      return value.any((result) => result != ConnectivityResult.none);
    }
    return false;
  }
}

abstract interface class SyncApiClient {
  Future<bool> checkHealth();

  Future<SyncResponse> sync(Map<String, Object?> request);
}

class SyncApiException implements Exception {
  SyncApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

class HttpSyncApiClient implements SyncApiClient {
  HttpSyncApiClient({
    required this.baseUri,
    http.Client? httpClient,
    this.timeout = const Duration(seconds: 10),
  }) : _httpClient = httpClient ?? http.Client();

  final Uri baseUri;
  final Duration timeout;
  final http.Client _httpClient;

  @override
  Future<bool> checkHealth() async {
    try {
      final response = await _httpClient
          .get(baseUri.resolve('/health'))
          .timeout(timeout);
      return response.statusCode == 200;
    } on Object {
      return false;
    }
  }

  @override
  Future<SyncResponse> sync(Map<String, Object?> requestBody) async {
    final response = await _httpClient
        .post(
          baseUri.resolve('/api/v1/sync'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(requestBody),
        )
        .timeout(timeout);

    final body = response.body;
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw SyncApiException('sync_http_${response.statusCode}: $body');
    }

    final decoded = jsonDecode(body);
    if (decoded is! Map<String, dynamic>) {
      throw SyncApiException('sync_invalid_response');
    }
    return SyncResponse.fromJson(decoded);
  }

  void close() => _httpClient.close();
}

enum SyncDisplayStatus { offline, pending, syncing, synced, error }

extension SyncDisplayStatusLabel on SyncDisplayStatus {
  String get label {
    return switch (this) {
      SyncDisplayStatus.offline => 'Sin conexión',
      SyncDisplayStatus.pending => 'Pendiente',
      SyncDisplayStatus.syncing => 'Sincronizando',
      SyncDisplayStatus.synced => 'Sincronizado',
      SyncDisplayStatus.error => 'Error de sync',
    };
  }
}

class SyncSummary {
  const SyncSummary({
    required this.failedCount,
    required this.pendingCount,
    required this.status,
    required this.syncingCount,
  });

  factory SyncSummary.fromQueue(
    SyncQueueSummary queue, {
    required bool online,
  }) {
    final status = switch ((
      online,
      queue.failedCount,
      queue.syncingCount,
      queue.pendingCount,
    )) {
      (false, _, _, _) => SyncDisplayStatus.offline,
      (true, > 0, _, _) => SyncDisplayStatus.error,
      (true, _, > 0, _) => SyncDisplayStatus.syncing,
      (true, _, _, > 0) => SyncDisplayStatus.pending,
      _ => SyncDisplayStatus.synced,
    };

    return SyncSummary(
      failedCount: queue.failedCount,
      pendingCount: queue.pendingCount,
      status: status,
      syncingCount: queue.syncingCount,
    );
  }

  final int failedCount;
  final int pendingCount;
  final SyncDisplayStatus status;
  final int syncingCount;

  bool get hasFailures => failedCount > 0;

  bool get hasWork => pendingCount > 0 || syncingCount > 0 || failedCount > 0;
}

class SyncResponse {
  const SyncResponse({required this.batchId, required this.results});

  factory SyncResponse.fromJson(Map<String, dynamic> json) {
    final rawResults = json['results'];
    if (rawResults is! List<dynamic>) {
      throw SyncApiException('sync_missing_results');
    }
    return SyncResponse(
      batchId: json['batch_id'] as String? ?? '',
      results: rawResults
          .map((value) {
            if (value is! Map<String, dynamic>) {
              throw SyncApiException('sync_invalid_result');
            }
            return SyncItemResult.fromJson(value);
          })
          .toList(growable: false),
    );
  }

  final String batchId;
  final List<SyncItemResult> results;
}

class SyncItemResult {
  const SyncItemResult({
    required this.entityId,
    required this.entityType,
    required this.status,
    this.errorCode,
    this.message,
  });

  factory SyncItemResult.fromJson(Map<String, dynamic> json) {
    return SyncItemResult(
      entityId: json['entity_id'] as String? ?? '',
      entityType: json['entity_type'] as String? ?? '',
      errorCode: json['error_code'] as String?,
      message: json['message'] as String?,
      status: json['status'] as String? ?? 'REJECTED',
    );
  }

  final String entityId;
  final String entityType;
  final String? errorCode;
  final String? message;
  final String status;

  bool get acceptedOrDuplicate => status == 'ACCEPTED' || status == 'DUPLICATE';
}

class SyncService {
  SyncService({
    required SyncApiClient api,
    required SyncQueueRepository queue,
    Uuid? uuid,
  }) : _api = api,
       _queue = queue,
       _uuid = uuid ?? const Uuid();

  final SyncApiClient _api;
  final SyncQueueRepository _queue;
  final Uuid _uuid;
  bool _running = false;

  Future<void> recoverStaleSyncing() {
    return _queue.recoverStaleSyncing();
  }

  Future<SyncSummary> summary({bool isOnline = true}) async {
    return SyncSummary.fromQueue(await _queue.summary(), online: isOnline);
  }

  Future<SyncSummary> syncPending({bool manualRetry = false}) async {
    if (_running) {
      return summary();
    }
    _running = true;

    try {
      if (manualRetry) {
        await _queue.releaseFailedForRetry();
      }

      final online = await _api.checkHealth();
      if (!online) {
        return summary(isOnline: false);
      }

      final rows = await _queue.readyBatch();
      if (rows.isEmpty) {
        return summary();
      }

      await _queue.markSyncing(rows.map((row) => row.id));
      final batch = _SyncBatch.fromRows(rows, batchId: _uuid.v4());
      for (final failure in batch.failures) {
        await _queue.markFailed(id: failure.queueId, error: failure.error);
      }

      if (batch.itemCount == 0) {
        return summary();
      }

      late final SyncResponse response;
      try {
        response = await _api.sync(batch.request);
      } on Object catch (error) {
        await _markTransportFailure(batch, error);
        return summary();
      }

      await _applyResults(batch, response.results);
      return summary();
    } finally {
      _running = false;
    }
  }

  Future<void> _markTransportFailure(_SyncBatch batch, Object error) async {
    final nextAttemptAt = DateTime.now().toUtc().add(
      _backoff(batch.highestAttempt),
    );
    for (final row in batch.rowsByQueueId.values) {
      await _queue.markFailed(
        id: row.id,
        error: error.toString(),
        nextAttemptAt: nextAttemptAt,
      );
    }
  }

  Future<void> _applyResults(
    _SyncBatch batch,
    List<SyncItemResult> results,
  ) async {
    final resultsByQueueId = <String, List<SyncItemResult>>{};
    for (final result in results) {
      final queueId =
          batch.queueIdByResultKey[_resultKey(
            result.entityType,
            result.entityId,
          )];
      if (queueId == null) {
        continue;
      }
      resultsByQueueId.putIfAbsent(queueId, () => []).add(result);
    }

    for (final queueId in batch.rowsByQueueId.keys) {
      final rowResults = resultsByQueueId[queueId];
      if (rowResults == null || rowResults.isEmpty) {
        await _queue.markFailed(id: queueId, error: 'sync_no_result');
        continue;
      }

      if (rowResults.every((result) => result.acceptedOrDuplicate)) {
        await _queue.markSynced([queueId]);
        continue;
      }

      final rejected = rowResults.firstWhere(
        (result) => !result.acceptedOrDuplicate,
      );
      await _queue.markFailed(
        id: queueId,
        error: rejected.errorCode ?? rejected.message ?? rejected.status,
      );
    }
  }
}

class SyncController {
  SyncController({
    required ConnectivityGateway connectivity,
    required SyncService service,
    this.debounce = const Duration(milliseconds: 800),
    this.pollInterval = const Duration(seconds: 30),
  }) : _connectivity = connectivity,
       _service = service;

  final ConnectivityGateway _connectivity;
  final SyncService _service;
  final Duration debounce;
  final Duration? pollInterval;
  StreamSubscription<bool>? _subscription;
  Timer? _debounceTimer;
  Timer? _pollTimer;
  Future<SyncSummary>? _activeSync;

  Future<void> start() async {
    await _service.recoverStaleSyncing();
    if (await _connectivity.isOnline) {
      unawaited(trigger());
    }
    _subscription ??= _connectivity.onConnectivityChanged.distinct().listen((
      online,
    ) {
      if (online) {
        schedule();
      }
    });
    final interval = pollInterval;
    if (interval != null) {
      _pollTimer ??= Timer.periodic(interval, (_) => unawaited(trigger()));
    }
  }

  Future<SyncSummary> currentSummary() async {
    final online = await _connectivity.isOnline;
    return _service.summary(isOnline: online);
  }

  void schedule() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(debounce, () => unawaited(trigger()));
  }

  Future<SyncSummary> trigger() {
    final current = _activeSync;
    if (current != null) {
      return current;
    }
    final next = _service.syncPending();
    _activeSync = next.whenComplete(() => _activeSync = null);
    return next;
  }

  Future<SyncSummary> manualRetry() {
    return _service.syncPending(manualRetry: true);
  }

  void dispose() {
    _debounceTimer?.cancel();
    _pollTimer?.cancel();
    unawaited(_subscription?.cancel());
  }
}

class _SyncBatch {
  const _SyncBatch({
    required this.failures,
    required this.highestAttempt,
    required this.itemCount,
    required this.queueIdByResultKey,
    required this.request,
    required this.rowsByQueueId,
  });

  factory _SyncBatch.fromRows(
    List<SyncQueueData> rows, {
    required String batchId,
  }) {
    final request = <String, Object?>{
      'device_id': _deviceId(rows) ?? 'mobile-local',
      'batch_id': batchId,
      'coaches': <Map<String, Object?>>[],
      'teams': <Map<String, Object?>>[],
      'players': <Map<String, Object?>>[],
      'sessions': <Map<String, Object?>>[],
      'session_players': <Map<String, Object?>>[],
      'player_actions': <Map<String, Object?>>[],
      'goalkeeper_actions': <Map<String, Object?>>[],
    };
    final failures = <_QueueFailure>[];
    final queueIdByResultKey = <String, String>{};
    final rowsByQueueId = {for (final row in rows) row.id: row};
    var itemCount = 0;
    final fallbackCoachId = _fallbackCoachId(rows);

    void addItem({
      required String entityId,
      required String entityType,
      required Map<String, Object?> item,
      required String queueId,
      required String requestKey,
    }) {
      (request[requestKey]! as List<Map<String, Object?>>).add(item);
      queueIdByResultKey[_resultKey(entityType, entityId)] = queueId;
      itemCount += 1;
    }

    for (final row in rows) {
      try {
        final payload = _decodePayload(row.payloadJson);
        switch (row.entityType) {
          case 'coach':
            final item = _coachPayload(payload);
            addItem(
              entityId: item['id']! as String,
              entityType: 'COACH',
              item: item,
              queueId: row.id,
              requestKey: 'coaches',
            );
          case 'team':
            final item = _teamPayload(payload, fallbackCoachId);
            addItem(
              entityId: item['id']! as String,
              entityType: 'TEAM',
              item: item,
              queueId: row.id,
              requestKey: 'teams',
            );
          case 'player':
            final item = _playerPayload(payload);
            addItem(
              entityId: item['id']! as String,
              entityType: 'PLAYER',
              item: item,
              queueId: row.id,
              requestKey: 'players',
            );
          case 'tournament_session':
            final item = _sessionPayload(payload);
            addItem(
              entityId: item['id']! as String,
              entityType: 'SESSION',
              item: item,
              queueId: row.id,
              requestKey: 'sessions',
            );
            for (final sessionPlayer in _nestedSessionPlayers(payload)) {
              final playerItem = _sessionPlayerPayload(sessionPlayer);
              final entityId = _sessionPlayerEntityId(playerItem);
              addItem(
                entityId: entityId,
                entityType: 'SESSION_PLAYER',
                item: playerItem,
                queueId: row.id,
                requestKey: 'session_players',
              );
            }
          case 'session_player':
            final item = _sessionPlayerPayload(payload);
            addItem(
              entityId: _sessionPlayerEntityId(item),
              entityType: 'SESSION_PLAYER',
              item: item,
              queueId: row.id,
              requestKey: 'session_players',
            );
          case 'match_action':
            final item = _matchActionPayload(payload);
            addItem(
              entityId: item['id']! as String,
              entityType: 'MATCH_ACTION',
              item: item,
              queueId: row.id,
              requestKey: 'player_actions',
            );
          case 'goalkeeper_action':
            final item = _goalkeeperActionPayload(payload);
            addItem(
              entityId: item['id']! as String,
              entityType: 'GOALKEEPER_ACTION',
              item: item,
              queueId: row.id,
              requestKey: 'goalkeeper_actions',
            );
          default:
            throw SyncApiException('unsupported_entity_${row.entityType}');
        }
      } on Object catch (error) {
        failures.add(_QueueFailure(queueId: row.id, error: error.toString()));
      }
    }

    return _SyncBatch(
      failures: failures,
      highestAttempt: rows.fold<int>(
        0,
        (max, row) => math.max(max, row.attempts),
      ),
      itemCount: itemCount,
      queueIdByResultKey: queueIdByResultKey,
      request: request,
      rowsByQueueId: rowsByQueueId,
    );
  }

  final List<_QueueFailure> failures;
  final int highestAttempt;
  final int itemCount;
  final Map<String, String> queueIdByResultKey;
  final Map<String, Object?> request;
  final Map<String, SyncQueueData> rowsByQueueId;
}

class _QueueFailure {
  const _QueueFailure({required this.error, required this.queueId});

  final String error;
  final String queueId;
}

Duration _backoff(int attempts) {
  final seconds = math.min(300, math.pow(2, math.max(0, attempts)).round());
  return Duration(seconds: seconds);
}

String _resultKey(String entityType, String entityId) {
  return '$entityType:$entityId';
}

Map<String, Object?> _decodePayload(String payloadJson) {
  final decoded = jsonDecode(payloadJson);
  if (decoded is! Map<String, dynamic>) {
    throw SyncApiException('sync_invalid_payload');
  }
  return _objectMap(decoded);
}

Map<String, Object?> _objectMap(Map<dynamic, dynamic> map) {
  return {
    for (final entry in map.entries)
      if (entry.key is String) entry.key as String: entry.value,
  };
}

String? _deviceId(List<SyncQueueData> rows) {
  for (final row in rows) {
    try {
      final payload = _decodePayload(row.payloadJson);
      final deviceId = payload['device_id'];
      if (deviceId is String && deviceId.isNotEmpty) {
        return deviceId;
      }
    } on Object {
      continue;
    }
  }
  return null;
}

String? _fallbackCoachId(List<SyncQueueData> rows) {
  for (final row in rows) {
    try {
      final payload = _decodePayload(row.payloadJson);
      final coachId = payload['coach_id'];
      if (coachId is String && coachId.isNotEmpty) {
        return coachId;
      }
      if (row.entityType == SyncEntityType.coach.storageValue) {
        final id = payload['id'];
        if (id is String && id.isNotEmpty) {
          return id;
        }
      }
    } on Object {
      continue;
    }
  }
  return null;
}

Map<String, Object?> _coachPayload(Map<String, Object?> payload) {
  return {
    'id': _requiredString(payload, 'id'),
    'full_name':
        payload['full_name'] ?? _requiredString(payload, 'display_name'),
    'email': payload['email'],
    'created_at': payload['created_at'],
    'updated_at': payload['updated_at'],
    'version': payload['version'] ?? 1,
  };
}

Map<String, Object?> _teamPayload(
  Map<String, Object?> payload,
  String? fallbackCoachId,
) {
  final coachId = payload['coach_id'] ?? fallbackCoachId;
  if (coachId is! String || coachId.isEmpty) {
    throw SyncApiException('missing_coach_id');
  }
  return {
    'id': _requiredString(payload, 'id'),
    'coach_id': coachId,
    'name': payload['name'],
    'category': payload['category'],
    'created_at': payload['created_at'],
    'updated_at': payload['updated_at'],
    'version': payload['version'] ?? 1,
  };
}

Map<String, Object?> _playerPayload(Map<String, Object?> payload) {
  return {
    'id': _requiredString(payload, 'id'),
    'team_id': payload['team_id'],
    'display_name': payload['display_name'],
    'jersey_number': payload['jersey_number'],
    'default_role': _playerRole(payload['default_role']),
    'active': payload['active'] ?? true,
    'version': payload['version'] ?? 1,
  };
}

Map<String, Object?> _sessionPayload(Map<String, Object?> payload) {
  return {
    'id': _requiredString(payload, 'id'),
    'team_id': payload['team_id'],
    'coach_id': payload['coach_id'],
    'tournament_name': payload['tournament_name'],
    'scheduled_date': payload['scheduled_date'],
    'start_time': payload['start_time'],
    'active_goalkeeper_id': payload['active_goalkeeper_id'],
    'status': _sessionStatus(payload['status']),
    'elapsed_ms': payload['elapsed_ms'] ?? 0,
    'device_id': payload['device_id'],
    'created_at': payload['created_at'],
    'updated_at': payload['updated_at'],
    'version': payload['version'] ?? 1,
  };
}

Iterable<Map<String, Object?>> _nestedSessionPlayers(
  Map<String, Object?> payload,
) sync* {
  final rawPlayers = payload['session_players'];
  if (rawPlayers is! Iterable<Object?>) {
    return;
  }
  for (final rawPlayer in rawPlayers) {
    if (rawPlayer is! Map<dynamic, dynamic>) {
      throw SyncApiException('invalid_session_player');
    }
    yield _objectMap(rawPlayer);
  }
}

Map<String, Object?> _sessionPlayerPayload(Map<String, Object?> payload) {
  return {
    'session_id': payload['session_id'],
    'player_id': payload['player_id'],
    'role': _sessionPlayerRole(payload['role']),
    'version': payload['version'] ?? 1,
  };
}

Map<String, Object?> _matchActionPayload(Map<String, Object?> payload) {
  final item = <String, Object?>{
    'id': _requiredString(payload, 'id'),
    'session_id': payload['session_id'],
    'player_id': payload['player_id'],
    'action_type': payload['action_type'],
    'chronometer_ms': payload['chronometer_ms'] ?? payload['clock_ms'],
    'device_id': payload['device_id'],
    'client_event_id': payload['client_event_id'],
    'created_at': payload['created_at'],
    'version': payload['version'] ?? 1,
    'voided_at': payload['voided_at'],
    'void_reason': _trimmedVoidReason(payload['void_reason']),
    'shoot_details': _shootDetails(payload),
  };
  if (item['shoot_details'] == null) {
    item.remove('shoot_details');
  }
  if (item['voided_at'] == null) {
    item.remove('voided_at');
  }
  if (item['void_reason'] == null) {
    item.remove('void_reason');
  }
  return item;
}

Map<String, Object?> _goalkeeperActionPayload(Map<String, Object?> payload) {
  return {
    'id': _requiredString(payload, 'id'),
    'session_id': payload['session_id'],
    'goalkeeper_id': payload['goalkeeper_id'],
    'shot_origin_zone': payload['shot_origin_zone'],
    'result': payload['result'],
    'chronometer_ms': payload['chronometer_ms'] ?? payload['clock_ms'],
    'device_id': payload['device_id'],
    'client_event_id': payload['client_event_id'],
    'created_at': payload['created_at'],
    'version': payload['version'] ?? 1,
  };
}

Map<String, Object?>? _shootDetails(Map<String, Object?> payload) {
  final actionType = payload['action_type'];
  if (actionType != PlayerActionType.shoot.storageValue) {
    return null;
  }

  Map<String, Object?>? details;
  final rawDetails = payload['shoot_details'];
  if (rawDetails is Map<dynamic, dynamic>) {
    details = _objectMap(rawDetails);
  }

  final result = details?['result'] ?? payload['outcome'];
  final targetZone = details?['target_zone'] ?? payload['target_zone'];
  if (result is! String || targetZone is! String) {
    throw SyncApiException('missing_shoot_details');
  }

  return {
    'result': result,
    'target_zone': targetZone,
    'keeper_side': details?['keeper_side'] ?? KeeperSide.unknown.storageValue,
  };
}

String _requiredString(Map<String, Object?> payload, String key) {
  final value = payload[key];
  if (value is String && value.isNotEmpty) {
    return value;
  }
  throw SyncApiException('missing_$key');
}

String _playerRole(Object? role) {
  return role == PlayerRole.goalkeeper.storageValue ? 'GOALKEEPER' : 'FIELD';
}

String _sessionPlayerRole(Object? role) {
  return role == PlayerRole.goalkeeper.storageValue ? 'GOALKEEPER' : 'STARTER';
}

String _sessionStatus(Object? status) {
  return status == SessionStatus.draft.storageValue ? 'PLANNED' : '$status';
}

String _sessionPlayerEntityId(Map<String, Object?> item) {
  return '${item['session_id']}:${item['player_id']}';
}

String? _trimmedVoidReason(Object? reason) {
  if (reason is! String) {
    return null;
  }
  return reason.length <= 160 ? reason : reason.substring(0, 160);
}
