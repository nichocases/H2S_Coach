import 'package:drift/drift.dart';
import 'package:inline_hockey_coach/data/local/drift/app_database.dart';
import 'package:inline_hockey_coach/data/repositories/sync_queue_repository.dart';
import 'package:inline_hockey_coach/domain/entities/hockey_enums.dart';
import 'package:inline_hockey_coach/domain/entities/local_models.dart';
import 'package:uuid/uuid.dart';

class MatchActionValidationException implements Exception {
  const MatchActionValidationException(this.message);

  final String message;

  @override
  String toString() => 'MatchActionValidationException: $message';
}

class MatchActionRepository {
  MatchActionRepository(this._db, {SyncQueueRepository? syncQueue})
    : _syncQueue = syncQueue ?? SyncQueueRepository(_db);

  final AppDatabase _db;
  final SyncQueueRepository _syncQueue;
  final Uuid _uuid = const Uuid();

  Future<MatchAction> recordPlayerAction(MatchActionDraft draft) {
    return _syncQueue.runAtomically(() async {
      await _validatePlayerDraft(draft);

      final now = DateTime.now().toUtc();
      final id = _uuid.v4();
      final action = MatchAction(
        id: id,
        sessionId: draft.sessionId,
        playerId: draft.playerId,
        actionType: draft.actionType.storageValue,
        outcome: draft.shotResult?.storageValue,
        clockMs: draft.chronometerMs,
        rinkZone: draft.targetZone?.storageValue,
        clientEventId: id,
        deviceId: draft.deviceId,
        createdAt: now,
        updatedAt: now,
        version: 1,
      );

      await _db.into(_db.matchActions).insert(action);
      ShootDetail? shootDetail;
      if (draft.actionType == PlayerActionType.shoot) {
        shootDetail = ShootDetail(
          actionId: action.id,
          targetZone: draft.targetZone!.storageValue,
          isGoal: draft.shotResult == ShotResult.goal,
          goalieTouched: draft.shotResult == ShotResult.hitKeeper,
        );
        await _db.into(_db.shootDetails).insert(shootDetail);
      }

      await _syncQueue.enqueueUpsert(
        entityType: SyncEntityType.matchAction,
        entityId: action.id,
        payload: _matchActionPayload(action, shootDetail, draft.keeperSide),
      );
      return action;
    });
  }

  Future<GoalkeeperAction> recordGoalkeeperAction(
    GoalkeeperActionDraft draft,
  ) {
    return _syncQueue.runAtomically(() async {
      await _validateGoalkeeperDraft(draft);

      final now = DateTime.now().toUtc();
      final id = _uuid.v4();
      final action = GoalkeeperAction(
        id: id,
        sessionId: draft.sessionId,
        goalkeeperId: draft.goalkeeperId,
        actionType: draft.result.storageValue,
        clockMs: draft.chronometerMs,
        rinkZone: draft.shotOriginZone.storageValue,
        clientEventId: id,
        deviceId: draft.deviceId,
        createdAt: now,
        updatedAt: now,
        version: 1,
      );

      await _db.into(_db.goalkeeperActions).insert(action);
      await _syncQueue.enqueueUpsert(
        entityType: SyncEntityType.goalkeeperAction,
        entityId: action.id,
        payload: _goalkeeperActionPayload(action),
      );
      return action;
    });
  }

  Future<List<RecentMatchEvent>> recentEvents(
    String sessionId, {
    int limit = 10,
  }) async {
    final playerRows =
        await (_db.select(_db.matchActions)
              ..where((row) => row.sessionId.equals(sessionId))
              ..orderBy([(row) => OrderingTerm.desc(row.createdAt)])
              ..limit(limit))
            .get();
    final goalkeeperRows =
        await (_db.select(_db.goalkeeperActions)
              ..where((row) => row.sessionId.equals(sessionId))
              ..orderBy([(row) => OrderingTerm.desc(row.createdAt)])
              ..limit(limit))
            .get();
    final events = <RecentMatchEvent>[
      for (final row in playerRows)
        RecentMatchEvent(
          id: row.id,
          kind: RecentEventKind.playerAction,
          primaryLabel: _playerActionLabel(row.actionType),
          detailLabel: _playerActionDetail(row),
          chronometerMs: row.clockMs,
          createdAt: row.createdAt,
          voidedAt: row.voidedAt,
          voidReason: row.voidReason,
        ),
      for (final row in goalkeeperRows)
        RecentMatchEvent(
          id: row.id,
          kind: RecentEventKind.goalkeeperAction,
          primaryLabel: _goalkeeperActionLabel(row.actionType),
          detailLabel: row.rinkZone ?? '',
          chronometerMs: row.clockMs,
          createdAt: row.createdAt,
          voidedAt: row.voidedAt,
          voidReason: row.voidReason,
        ),
    ]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return events.take(limit).toList(growable: false);
  }

  Future<RecentMatchEvent?> voidLatestEvent({
    required String sessionId,
    required String reason,
  }) {
    return _syncQueue.runAtomically(() async {
      final latestPlayer =
          await (_db.select(_db.matchActions)
                ..where(
                  (row) =>
                      row.sessionId.equals(sessionId) & row.voidedAt.isNull(),
                )
                ..orderBy([(row) => OrderingTerm.desc(row.createdAt)])
                ..limit(1))
              .getSingleOrNull();
      final latestGoalkeeper =
          await (_db.select(_db.goalkeeperActions)
                ..where(
                  (row) =>
                      row.sessionId.equals(sessionId) & row.voidedAt.isNull(),
                )
                ..orderBy([(row) => OrderingTerm.desc(row.createdAt)])
                ..limit(1))
              .getSingleOrNull();

      if (latestPlayer == null && latestGoalkeeper == null) {
        return null;
      }

      if (_isGoalkeeperLatest(latestPlayer, latestGoalkeeper)) {
        return _voidGoalkeeperAction(latestGoalkeeper!, reason);
      }
      return _voidPlayerAction(latestPlayer!, reason);
    });
  }

  Future<ShotMetrics> shotMetrics(String sessionId) async {
    final rows =
        await (_db.select(_db.matchActions)..where(
              (row) =>
                  row.sessionId.equals(sessionId) &
                  row.actionType.equals(PlayerActionType.shoot.storageValue) &
                  row.voidedAt.isNull(),
            ))
            .get();
    final shotsOnTarget = rows
        .where(
          (row) =>
              row.outcome == ShotResult.goal.storageValue ||
              row.outcome == ShotResult.hitKeeper.storageValue,
        )
        .length;
    final goals = rows
        .where((row) => row.outcome == ShotResult.goal.storageValue)
        .length;
    return ShotMetrics(
      attempts: rows.length,
      shotsOnTarget: shotsOnTarget,
      goals: goals,
    );
  }

  Future<GoalkeeperMetrics> goalkeeperMetrics(String sessionId) async {
    final rows =
        await (_db.select(_db.goalkeeperActions)..where(
              (row) => row.sessionId.equals(sessionId) & row.voidedAt.isNull(),
            ))
            .get();
    final saves = rows
        .where(
          (row) => row.actionType == GoalkeeperActionResult.save.storageValue,
        )
        .length;
    final goalsAllowed = rows
        .where(
          (row) =>
              row.actionType == GoalkeeperActionResult.goalAllowed.storageValue,
        )
        .length;
    return GoalkeeperMetrics(
      shotsFaced: rows.length,
      saves: saves,
      goalsAllowed: goalsAllowed,
    );
  }

  Future<void> _validatePlayerDraft(MatchActionDraft draft) async {
    if (draft.chronometerMs < 0) {
      throw const MatchActionValidationException(
        'Chronometer milliseconds cannot be negative.',
      );
    }
    if (draft.actionType == PlayerActionType.shoot) {
      if (draft.shotResult == null || draft.targetZone == null) {
        throw const MatchActionValidationException(
          'Shot result and target zone are required.',
        );
      }
    } else if (draft.shotResult != null || draft.targetZone != null) {
      throw const MatchActionValidationException(
        'Only shoot actions can include shot details.',
      );
    }

    final session = await (_db.select(
      _db.tournamentSessions,
    )..where((row) => row.id.equals(draft.sessionId))).getSingleOrNull();
    if (session == null) {
      throw MatchActionValidationException(
        'Session not found: ${draft.sessionId}',
      );
    }


    final selection =
        await (_db.select(_db.sessionPlayers)..where(
              (row) =>
                  row.sessionId.equals(draft.sessionId) &
                  row.playerId.equals(draft.playerId),
            ))
            .getSingleOrNull();
    if (selection == null || selection.role != PlayerRole.skater.storageValue) {
      throw const MatchActionValidationException(
        'Player action requires a selected skater.',
      );
    }
  }

  Future<void> _validateGoalkeeperDraft(GoalkeeperActionDraft draft) async {
    if (draft.chronometerMs < 0) {
      throw const MatchActionValidationException(
        'Chronometer milliseconds cannot be negative.',
      );
    }
    final session = await (_db.select(
      _db.tournamentSessions,
    )..where((row) => row.id.equals(draft.sessionId))).getSingleOrNull();
    if (session == null) {
      throw MatchActionValidationException(
        'Session not found: ${draft.sessionId}',
      );
    }

    if (session.activeGoalkeeperId != draft.goalkeeperId) {
      throw const MatchActionValidationException(
        'Goalkeeper action must use the active goalkeeper.',
      );
    }

    final selection =
        await (_db.select(_db.sessionPlayers)..where(
              (row) =>
                  row.sessionId.equals(draft.sessionId) &
                  row.playerId.equals(draft.goalkeeperId),
            ))
            .getSingleOrNull();
    if (selection == null ||
        selection.role != PlayerRole.goalkeeper.storageValue) {
      throw const MatchActionValidationException(
        'Goalkeeper action requires the selected goalkeeper.',
      );
    }
  }

  Future<RecentMatchEvent> _voidPlayerAction(
    MatchAction current,
    String reason,
  ) async {
    final now = DateTime.now().toUtc();
    final updated = current.copyWith(
      updatedAt: now,
      version: current.version + 1,
      voidedAt: Value(now),
      voidReason: Value(reason),
    );
    await _db.update(_db.matchActions).replace(updated);
    final shootDetail =
        await (_db.select(_db.shootDetails)..where(
              (row) => row.actionId.equals(updated.id),
            ))
            .getSingleOrNull();
    await _syncQueue.enqueueUpsert(
      entityType: SyncEntityType.matchAction,
      entityId: updated.id,
      payload: _matchActionPayload(updated, shootDetail, KeeperSide.unknown),
    );
    return RecentMatchEvent(
      id: updated.id,
      kind: RecentEventKind.playerAction,
      primaryLabel: _playerActionLabel(updated.actionType),
      detailLabel: _playerActionDetail(updated),
      chronometerMs: updated.clockMs,
      createdAt: updated.createdAt,
      voidedAt: updated.voidedAt,
      voidReason: updated.voidReason,
    );
  }

  Future<RecentMatchEvent> _voidGoalkeeperAction(
    GoalkeeperAction current,
    String reason,
  ) async {
    final now = DateTime.now().toUtc();
    final updated = current.copyWith(
      updatedAt: now,
      version: current.version + 1,
      voidedAt: Value(now),
      voidReason: Value(reason),
    );
    await _db.update(_db.goalkeeperActions).replace(updated);
    await _syncQueue.enqueueUpsert(
      entityType: SyncEntityType.goalkeeperAction,
      entityId: updated.id,
      payload: _goalkeeperActionPayload(updated),
    );
    return RecentMatchEvent(
      id: updated.id,
      kind: RecentEventKind.goalkeeperAction,
      primaryLabel: _goalkeeperActionLabel(updated.actionType),
      detailLabel: updated.rinkZone ?? '',
      chronometerMs: updated.clockMs,
      createdAt: updated.createdAt,
      voidedAt: updated.voidedAt,
      voidReason: updated.voidReason,
    );
  }
}

bool _isGoalkeeperLatest(
  MatchAction? playerAction,
  GoalkeeperAction? goalkeeperAction,
) {
  if (goalkeeperAction == null) {
    return false;
  }
  if (playerAction == null) {
    return true;
  }
  return goalkeeperAction.createdAt.isAfter(playerAction.createdAt);
}

Map<String, Object?> _matchActionPayload(
  MatchAction action,
  ShootDetail? shootDetail,
  KeeperSide keeperSide,
) {
  return {
    'id': action.id,
    'session_id': action.sessionId,
    'player_id': action.playerId,
    'action_type': action.actionType,
    'chronometer_ms': action.clockMs,
    'device_id': action.deviceId,
    'client_event_id': action.clientEventId,
    'created_at': action.createdAt.toUtc().toIso8601String(),
    'updated_at': action.updatedAt.toUtc().toIso8601String(),
    'voided_at': action.voidedAt?.toUtc().toIso8601String(),
    'void_reason': action.voidReason,
    'version': action.version,
    'shoot_details': shootDetail == null
        ? null
        : {
            'action_id': shootDetail.actionId,
            'result': action.outcome,
            'target_zone': shootDetail.targetZone,
            'keeper_side': keeperSide.storageValue,
          },
  };
}

Map<String, Object?> _goalkeeperActionPayload(GoalkeeperAction action) {
  return {
    'id': action.id,
    'session_id': action.sessionId,
    'goalkeeper_id': action.goalkeeperId,
    'shot_origin_zone': action.rinkZone,
    'result': action.actionType,
    'chronometer_ms': action.clockMs,
    'device_id': action.deviceId,
    'client_event_id': action.clientEventId,
    'created_at': action.createdAt.toUtc().toIso8601String(),
    'updated_at': action.updatedAt.toUtc().toIso8601String(),
    'voided_at': action.voidedAt?.toUtc().toIso8601String(),
    'void_reason': action.voidReason,
    'version': action.version,
  };
}

String _playerActionLabel(String storageValue) {
  final action = PlayerActionType.fromStorage(storageValue);
  return switch (action) {
    PlayerActionType.pass => 'Pase correcto',
    PlayerActionType.failPass => 'Pase fallido',
    PlayerActionType.assist => 'Asistencia',
    PlayerActionType.shoot => 'Tiro',
  };
}

String _playerActionDetail(MatchAction action) {
  if (action.actionType != PlayerActionType.shoot.storageValue) {
    return '';
  }
  final result = action.outcome == null
      ? ''
      : _shotResultLabel(action.outcome!);
  final zone = action.rinkZone ?? '';
  return [result, zone].where((value) => value.isNotEmpty).join(' · ');
}

String _shotResultLabel(String storageValue) {
  final result = ShotResult.fromStorage(storageValue);
  return switch (result) {
    ShotResult.goal => 'Gol',
    ShotResult.missed => 'Desviado',
    ShotResult.hitKeeper => 'Al arquero',
    ShotResult.blocked => 'Bloqueado',
  };
}

String _goalkeeperActionLabel(String storageValue) {
  final result = GoalkeeperActionResult.fromStorage(storageValue);
  return switch (result) {
    GoalkeeperActionResult.save => 'Atajada',
    GoalkeeperActionResult.goalAllowed => 'Gol recibido',
  };
}
