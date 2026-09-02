import 'package:drift/drift.dart';
import 'package:inline_hockey_coach/data/local/drift/app_database.dart';
import 'package:inline_hockey_coach/data/repositories/sync_queue_repository.dart';
import 'package:inline_hockey_coach/domain/entities/hockey_enums.dart';
import 'package:inline_hockey_coach/domain/entities/local_models.dart';
import 'package:uuid/uuid.dart';

class SessionValidationException implements Exception {
  const SessionValidationException(this.message);

  final String message;

  @override
  String toString() => 'SessionValidationException: $message';
}

class TournamentSessionRepository {
  TournamentSessionRepository(this._db, {SyncQueueRepository? syncQueue})
    : _syncQueue = syncQueue ?? SyncQueueRepository(_db);

  final AppDatabase _db;
  final SyncQueueRepository _syncQueue;
  final Uuid _uuid = const Uuid();

  Future<TournamentSession> createDraft(TournamentSessionDraft draft) {
    return _syncQueue.runAtomically(() async {
      await _validateDraft(draft);

      final now = DateTime.now().toUtc();
      final session = TournamentSession(
        id: _uuid.v4(),
        tournamentName: draft.tournamentName.trim(),
        scheduledDate: _dateOnly(draft.scheduledDate),
        startTime: draft.startTime,
        teamId: draft.teamId,
        coachId: draft.coachId,
        activeGoalkeeperId: draft.activeGoalkeeperId,
        status: SessionStatus.draft.storageValue,
        elapsedMs: 0,
        deviceId: draft.deviceId,
        createdAt: now,
        updatedAt: now,
        version: 1,
      );

      await _db.into(_db.tournamentSessions).insert(session);

      for (final selectedPlayer in draft.players) {
        await _db
            .into(_db.sessionPlayers)
            .insert(
              SessionPlayersCompanion.insert(
                sessionId: session.id,
                playerId: selectedPlayer.playerId,
                role: selectedPlayer.role.storageValue,
                createdAt: now,
                updatedAt: now,
              ),
            );
      }

      await _syncQueue.enqueueUpsert(
        entityType: SyncEntityType.tournamentSession,
        entityId: session.id,
        payload: _sessionPayload(session, draft.players),
      );

      return session;
    });
  }

  Future<TournamentSession?> find(String id) {
    return (_db.select(_db.tournamentSessions)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<TournamentSession>> allSessions() {
    return (_db.select(_db.tournamentSessions)
          ..orderBy([
            (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
          ]))
        .get();
  }

  Future<List<SessionPlayer>> playersForSession(String sessionId) {
    return (_db.select(
      _db.sessionPlayers,
    )..where((row) => row.sessionId.equals(sessionId))).get();
  }

  Future<TournamentSession> updateClockState({
    required String sessionId,
    required SessionStatus status,
    required int elapsedMs,
  }) {
    return _syncQueue.runAtomically(() async {
      final current = await find(sessionId);
      if (current == null) {
        throw StateError('Session not found: $sessionId');
      }
      if (elapsedMs < 0) {
        throw const SessionValidationException(
          'Elapsed milliseconds cannot be negative.',
        );
      }

      final now = DateTime.now().toUtc();
      final startedAt = current.startedAt ?? _startedAtFor(status, now);
      final updated = current.copyWith(
        status: status.storageValue,
        elapsedMs: elapsedMs,
        startedAt: Value(startedAt),
        updatedAt: now,
        version: current.version + 1,
      );
      await _db.update(_db.tournamentSessions).replace(updated);

      final selectedPlayers = await playersForSession(sessionId);
      await _syncQueue.enqueueUpsert(
        entityType: SyncEntityType.tournamentSession,
        entityId: updated.id,
        payload: _sessionPayload(
          updated,
          [
            for (final player in selectedPlayers)
              SessionPlayerDraft(
                playerId: player.playerId,
                role: PlayerRole.fromStorage(player.role),
              ),
          ],
        ),
      );
      return updated;
    });
  }

  Future<TournamentSession> finishSession(String sessionId) {
    return _syncQueue.runAtomically(() async {
      final current = await find(sessionId);
      if (current == null) {
        throw StateError('Session not found: $sessionId');
      }
      if (current.status == SessionStatus.finished.storageValue) {
        return current;
      }

      final now = DateTime.now().toUtc();
      final updated = current.copyWith(
        status: SessionStatus.finished.storageValue,
        finishedAt: Value(now),
        updatedAt: now,
        version: current.version + 1,
      );
      await _db.update(_db.tournamentSessions).replace(updated);

      final selectedPlayers = await playersForSession(sessionId);
      await _syncQueue.enqueueUpsert(
        entityType: SyncEntityType.tournamentSession,
        entityId: updated.id,
        payload: _sessionPayload(
          updated,
          [
            for (final player in selectedPlayers)
              SessionPlayerDraft(
                playerId: player.playerId,
                role: PlayerRole.fromStorage(player.role),
              ),
          ],
        ),
      );
      return updated;
    });
  }

  Future<void> _validateDraft(TournamentSessionDraft draft) async {
    if (draft.tournamentName.trim().isEmpty) {
      throw const SessionValidationException('Tournament name is required.');
    }
    if (draft.players.isEmpty) {
      throw const SessionValidationException(
        'At least one player is required.',
      );
    }

    final goalkeeperSelections = draft.players
        .where((player) => player.role == PlayerRole.goalkeeper)
        .toList(growable: false);
    if (goalkeeperSelections.length != 1) {
      throw const SessionValidationException(
        'Exactly one active goalkeeper is required.',
      );
    }
    if (goalkeeperSelections.single.playerId != draft.activeGoalkeeperId) {
      throw const SessionValidationException(
        'Active goalkeeper must match the goalkeeper selection.',
      );
    }

    final skaterIds = draft.players
        .where((player) => player.role == PlayerRole.skater)
        .map((player) => player.playerId)
        .toSet();
    if (skaterIds.isEmpty) {
      throw const SessionValidationException(
        'At least one skater is required.',
      );
    }
    if (skaterIds.contains(draft.activeGoalkeeperId)) {
      throw const SessionValidationException(
        'A player cannot be skater and active goalkeeper in one session.',
      );
    }

    final selectedIds = draft.players.map((player) => player.playerId).toSet();
    if (selectedIds.length != draft.players.length) {
      throw const SessionValidationException(
        'A player can be selected once per session.',
      );
    }

    final coach = await (_db.select(
      _db.coaches,
    )..where((row) => row.id.equals(draft.coachId))).getSingleOrNull();
    if (coach == null) {
      throw SessionValidationException('Coach not found: ${draft.coachId}');
    }

    final team = await (_db.select(
      _db.teams,
    )..where((row) => row.id.equals(draft.teamId))).getSingleOrNull();
    if (team == null) {
      throw SessionValidationException('Team not found: ${draft.teamId}');
    }

    final rows = await (_db.select(
      _db.players,
    )..where((row) => row.id.isIn(selectedIds))).get();
    if (rows.length != selectedIds.length) {
      throw const SessionValidationException(
        'All selected players must exist.',
      );
    }

    for (final player in rows) {
      if (!player.active) {
        throw SessionValidationException(
          'Inactive player selected: ${player.id}',
        );
      }
      if (player.teamId != draft.teamId) {
        throw SessionValidationException(
          'Selected player belongs to another team: ${player.id}',
        );
      }
    }
  }
}

DateTime? _startedAtFor(SessionStatus status, DateTime now) {
  if (status == SessionStatus.inProgress) {
    return now;
  }
  return null;
}

String _dateOnly(DateTime value) {
  final utc = value.toUtc();
  final month = utc.month.toString().padLeft(2, '0');
  final day = utc.day.toString().padLeft(2, '0');
  return '${utc.year}-$month-$day';
}

Map<String, Object?> _sessionPayload(
  TournamentSession session,
  List<SessionPlayerDraft> players,
) {
  return {
    'id': session.id,
    'tournament_name': session.tournamentName,
    'scheduled_date': session.scheduledDate,
    'start_time': session.startTime,
    'team_id': session.teamId,
    'coach_id': session.coachId,
    'active_goalkeeper_id': session.activeGoalkeeperId,
    'status': session.status,
    'elapsed_ms': session.elapsedMs,
    'started_at': session.startedAt?.toUtc().toIso8601String(),
    'finished_at': session.finishedAt?.toUtc().toIso8601String(),
    'device_id': session.deviceId,
    'created_at': session.createdAt.toUtc().toIso8601String(),
    'updated_at': session.updatedAt.toUtc().toIso8601String(),
    'version': session.version,
    'session_players': [
      for (final player in players)
        {
          'session_id': session.id,
          'player_id': player.playerId,
          'role': player.role.storageValue,
          'created_at': session.createdAt.toUtc().toIso8601String(),
          'updated_at': session.updatedAt.toUtc().toIso8601String(),
          'version': 1,
        },
    ],
  };
}
