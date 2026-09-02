import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:inline_hockey_coach/data/local/drift/app_database.dart';
import 'package:inline_hockey_coach/data/repositories/sync_queue_repository.dart';
import 'package:inline_hockey_coach/domain/entities/hockey_enums.dart';
import 'package:inline_hockey_coach/features/sync/application/sync_service.dart';

void main() {
  late AppDatabase db;
  late SyncQueueRepository queue;
  late FakeSyncApiClient api;
  late SyncService service;

  setUp(() {
    db = AppDatabase.inMemory();
    queue = SyncQueueRepository(db);
    api = FakeSyncApiClient();
    service = SyncService(api: api, queue: queue);
  });

  tearDown(() => db.close());

  test('sends batches capped at 200 and keeps the rest pending', () async {
    for (var index = 0; index < 201; index += 1) {
      final payload = _coach(index);
      await queue.enqueueUpsert(
        entityType: SyncEntityType.coach,
        entityId: payload['id']! as String,
        payload: payload,
      );
    }

    final summary = await service.syncPending();
    final request = api.requests.single;

    expect(_requestItems(request, 'coaches'), hasLength(200));
    expect(summary.pendingCount, 1);
    expect(summary.failedCount, 0);
  });

  test('treats duplicate result rows as synced', () async {
    final payload = _matchAction(1);
    await queue.enqueueUpsert(
      entityType: SyncEntityType.matchAction,
      entityId: payload['id']! as String,
      payload: payload,
    );
    api.nextStatuses = ['DUPLICATE'];

    final summary = await service.syncPending();

    expect(summary.hasWork, isFalse);
    expect(await queue.pendingCount(), 0);
  });

  test(
    'keeps transport failures failed with backoff then manual retry clears',
    () async {
      final payload = _matchAction(1);
      await queue.enqueueUpsert(
        entityType: SyncEntityType.matchAction,
        entityId: payload['id']! as String,
        payload: payload,
      );
      api.syncError = SyncApiException('network_down');

      final failed = await service.syncPending();
      final failedRow = (await db.select(db.syncQueue).get()).single;

      expect(failed.failedCount, 1);
      expect(failedRow.state, SyncState.failed.storageValue);
      expect(failedRow.nextAttemptAt, isNotNull);

      api.syncError = null;
      final retried = await service.syncPending(manualRetry: true);

      expect(retried.hasWork, isFalse);
      expect(await db.select(db.syncQueue).get(), isEmpty);
    },
  );

  test('recovers stale syncing rows after restart', () async {
    final payload = _coach(1);
    final queueId = await queue.enqueueUpsert(
      entityType: SyncEntityType.coach,
      entityId: payload['id']! as String,
      payload: payload,
    );
    await queue.markSyncing([queueId]);

    await service.recoverStaleSyncing();
    final summary = await queue.summary();

    expect(summary.pendingCount, 1);
    expect(summary.syncingCount, 0);
  });

  test('splits nested session players from session payload', () async {
    final payload = _session(1);
    await queue.enqueueUpsert(
      entityType: SyncEntityType.tournamentSession,
      entityId: payload['id']! as String,
      payload: payload,
    );

    await service.syncPending();
    final request = api.requests.single;

    expect(_requestItems(request, 'sessions'), hasLength(1));
    expect(_requestItems(request, 'session_players'), hasLength(2));
    expect(await db.select(db.syncQueue).get(), isEmpty);
  });

  test(
    'marks malformed team without coach id as failed without API call',
    () async {
      final payload = _team(1);
      await queue.enqueueUpsert(
        entityType: SyncEntityType.team,
        entityId: payload['id']! as String,
        payload: payload,
      );

      final summary = await service.syncPending();
      final failedRow = (await db.select(db.syncQueue).get()).single;

      expect(api.requests, isEmpty);
      expect(summary.failedCount, 1);
      expect(failedRow.state, SyncState.failed.storageValue);
      expect(failedRow.lastError, contains('missing_coach_id'));
    },
  );

  test('debounces reconnect events before syncing', () async {
    final connectivity = FakeConnectivityGateway(online: false);
    final controller = SyncController(
      connectivity: connectivity,
      service: service,
      debounce: const Duration(milliseconds: 20),
      pollInterval: null,
    );
    addTearDown(controller.dispose);
    addTearDown(connectivity.close);

    final payload = _matchAction(1);
    await queue.enqueueUpsert(
      entityType: SyncEntityType.matchAction,
      entityId: payload['id']! as String,
      payload: payload,
    );

    await controller.start();
    expect(api.requests, isEmpty);

    connectivity
      ..emit(online: true)
      ..emit(online: true);
    await Future<void>.delayed(const Duration(milliseconds: 80));

    expect(api.requests, hasLength(1));
    expect(await queue.pendingCount(), 0);
  });
}

class FakeSyncApiClient implements SyncApiClient {
  FakeSyncApiClient({this.healthy = true});

  bool healthy;
  Exception? syncError;
  List<String> nextStatuses = const <String>[];
  final requests = <Map<String, Object?>>[];

  @override
  Future<bool> checkHealth() async => healthy;

  @override
  Future<SyncResponse> sync(Map<String, Object?> request) async {
    requests.add(request);
    final error = syncError;
    if (error != null) {
      throw error;
    }
    return SyncResponse(
      batchId: request['batch_id'] as String? ?? '',
      results: _resultsForRequest(request, nextStatuses),
    );
  }
}

class FakeConnectivityGateway implements ConnectivityGateway {
  FakeConnectivityGateway({required this.online});

  bool online;
  final StreamController<bool> _controller = StreamController<bool>.broadcast();

  void emit({required bool online}) {
    this.online = online;
    _controller.add(online);
  }

  @override
  Future<bool> get isOnline async => online;

  @override
  Stream<bool> get onConnectivityChanged => _controller.stream;

  Future<void> close() => _controller.close();
}

List<SyncItemResult> _resultsForRequest(
  Map<String, Object?> request,
  List<String> statuses,
) {
  final results = <SyncItemResult>[];

  void addResults(String requestKey, String entityType) {
    for (final item in _requestItems(request, requestKey)) {
      final entityId = requestKey == 'session_players'
          ? '${item['session_id']}:${item['player_id']}'
          : item['id']! as String;
      results.add(
        SyncItemResult(
          entityId: entityId,
          entityType: entityType,
          status: statuses.length > results.length
              ? statuses[results.length]
              : 'ACCEPTED',
        ),
      );
    }
  }

  addResults('coaches', 'COACH');
  addResults('teams', 'TEAM');
  addResults('players', 'PLAYER');
  addResults('sessions', 'SESSION');
  addResults('session_players', 'SESSION_PLAYER');
  addResults('player_actions', 'MATCH_ACTION');
  addResults('goalkeeper_actions', 'GOALKEEPER_ACTION');

  return results;
}

Iterable<Map<String, Object?>> _requestItems(
  Map<String, Object?> request,
  String key,
) {
  final rawItems = request[key] as Iterable<Object?>? ?? const <Object?>[];
  return rawItems.map((item) => item! as Map<String, Object?>);
}

Map<String, Object?> _coach(int index) {
  return {
    'id': _uuid(index),
    'display_name': 'Coach $index',
    'created_at': _now(),
    'updated_at': _now(),
    'version': 1,
  };
}

Map<String, Object?> _team(int index, {String? coachId}) {
  return {
    'id': _uuid(1000 + index),
    'coach_id': coachId,
    'name': 'Team $index',
    'created_at': _now(),
    'updated_at': _now(),
    'version': 1,
  };
}

Map<String, Object?> _matchAction(int index) {
  return {
    'id': _uuid(2000 + index),
    'session_id': _uuid(3000),
    'player_id': _uuid(4000),
    'action_type': PlayerActionType.pass.storageValue,
    'clock_ms': 1200,
    'device_id': _uuid(5000),
    'client_event_id': _uuid(6000 + index),
    'created_at': _now(),
    'updated_at': _now(),
    'version': 1,
  };
}

Map<String, Object?> _session(int index) {
  return {
    'id': _uuid(7000 + index),
    'team_id': _uuid(8000),
    'coach_id': _uuid(9000),
    'tournament_name': 'Copa',
    'scheduled_date': '2026-01-01',
    'active_goalkeeper_id': _uuid(10000),
    'status': SessionStatus.draft.storageValue,
    'elapsed_ms': 0,
    'device_id': _uuid(11000),
    'created_at': _now(),
    'updated_at': _now(),
    'version': 1,
    'session_players': [
      {
        'session_id': _uuid(7000 + index),
        'player_id': _uuid(12000 + index),
        'role': PlayerRole.skater.storageValue,
        'version': 1,
      },
      {
        'session_id': _uuid(7000 + index),
        'player_id': _uuid(13000 + index),
        'role': PlayerRole.goalkeeper.storageValue,
        'version': 1,
      },
    ],
  };
}

String _uuid(int value) {
  return '10000000-0000-4000-8000-${value.toString().padLeft(12, '0')}';
}

String _now() => DateTime.utc(2026).toIso8601String();
