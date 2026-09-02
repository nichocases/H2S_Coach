import 'package:drift/drift.dart';
import 'package:inline_hockey_coach/data/local/drift/app_database.dart';
import 'package:inline_hockey_coach/data/repositories/sync_queue_repository.dart';
import 'package:inline_hockey_coach/domain/entities/hockey_enums.dart';
import 'package:inline_hockey_coach/domain/entities/local_models.dart';
import 'package:uuid/uuid.dart';

class PlayerRepository {
  PlayerRepository(this._db, {SyncQueueRepository? syncQueue})
    : _syncQueue = syncQueue ?? SyncQueueRepository(_db);

  final AppDatabase _db;
  final SyncQueueRepository _syncQueue;
  final Uuid _uuid = const Uuid();

  Future<Player> create(PlayerDraft draft) {
    return _syncQueue.runAtomically(() async {
      final now = DateTime.now().toUtc();
      final player = Player(
        id: _uuid.v4(),
        teamId: draft.teamId,
        displayName: draft.displayName,
        jerseyNumber: draft.jerseyNumber,
        defaultRole: draft.defaultRole.storageValue,
        active: draft.active,
        createdAt: now,
        updatedAt: now,
        version: 1,
      );
      await _db.into(_db.players).insert(player);
      await _syncQueue.enqueueUpsert(
        entityType: SyncEntityType.player,
        entityId: player.id,
        payload: _playerPayload(player),
      );
      return player;
    });
  }

  Future<Player?> find(String id) {
    return (_db.select(
      _db.players,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
  }

  Future<List<Player>> listForTeam(String teamId) {
    return (_db.select(_db.players)
          ..where((row) => row.teamId.equals(teamId))
          ..orderBy([(row) => OrderingTerm.asc(row.jerseyNumber)]))
        .get();
  }

  Future<void> rename({required String id, required String displayName}) {
    return _syncQueue.runAtomically(() async {
      final current = await find(id);
      if (current == null) {
        throw StateError('Player not found: $id');
      }
      final updated = current.copyWith(
        displayName: displayName,
        updatedAt: DateTime.now().toUtc(),
        version: current.version + 1,
      );
      await _db.update(_db.players).replace(updated);
      await _syncQueue.enqueueUpsert(
        entityType: SyncEntityType.player,
        entityId: updated.id,
        payload: _playerPayload(updated),
      );
    });
  }

  Future<void> updatePlayer({
    required String id,
    required String displayName,
    required int jerseyNumber,
    required PlayerRole role,
  }) {
    return _syncQueue.runAtomically(() async {
      final current = await find(id);
      if (current == null) {
        throw StateError('Player not found: $id');
      }
      final updated = current.copyWith(
        displayName: displayName,
        jerseyNumber: jerseyNumber,
        defaultRole: role.storageValue,
        updatedAt: DateTime.now().toUtc(),
        version: current.version + 1,
      );
      await _db.update(_db.players).replace(updated);
      await _syncQueue.enqueueUpsert(
        entityType: SyncEntityType.player,
        entityId: updated.id,
        payload: _playerPayload(updated),
      );
    });
  }

  Future<void> deactivate(String id) {
    return _syncQueue.runAtomically(() async {
      final current = await find(id);
      if (current == null) {
        throw StateError('Player not found: $id');
      }
      final updated = current.copyWith(
        active: false,
        updatedAt: DateTime.now().toUtc(),
        version: current.version + 1,
      );
      await _db.update(_db.players).replace(updated);
      await _syncQueue.enqueueUpsert(
        entityType: SyncEntityType.player,
        entityId: updated.id,
        payload: _playerPayload(updated),
      );
    });
  }
}

Map<String, Object?> _playerPayload(Player player) {
  return {
    'id': player.id,
    'team_id': player.teamId,
    'display_name': player.displayName,
    'jersey_number': player.jerseyNumber,
    'default_role': player.defaultRole,
    'active': player.active,
    'created_at': player.createdAt.toUtc().toIso8601String(),
    'updated_at': player.updatedAt.toUtc().toIso8601String(),
    'version': player.version,
  };
}
