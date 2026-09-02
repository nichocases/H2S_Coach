import 'package:drift/drift.dart';
import 'package:inline_hockey_coach/data/local/drift/app_database.dart';
import 'package:inline_hockey_coach/data/repositories/sync_queue_repository.dart';
import 'package:inline_hockey_coach/domain/entities/hockey_enums.dart';
import 'package:inline_hockey_coach/domain/entities/local_models.dart';
import 'package:uuid/uuid.dart';

class TeamRepository {
  TeamRepository(this._db, {SyncQueueRepository? syncQueue})
    : _syncQueue = syncQueue ?? SyncQueueRepository(_db);

  final AppDatabase _db;
  final SyncQueueRepository _syncQueue;
  final Uuid _uuid = const Uuid();

  Future<Team> create(TeamDraft draft) {
    return _syncQueue.runAtomically(() async {
      final now = DateTime.now().toUtc();
      final team = Team(
        id: _uuid.v4(),
        name: draft.name,
        category: draft.category,
        createdAt: now,
        updatedAt: now,
        version: 1,
      );
      await _db.into(_db.teams).insert(team);
      await _syncQueue.enqueueUpsert(
        entityType: SyncEntityType.team,
        entityId: team.id,
        payload: _teamPayload(team),
      );
      return team;
    });
  }

  Future<Team?> find(String id) {
    return (_db.select(
      _db.teams,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
  }

  Future<List<Team>> list() {
    return (_db.select(
      _db.teams,
    )..orderBy([(row) => OrderingTerm.asc(row.name)])).get();
  }

  Future<void> rename({required String id, required String name}) {
    return updateTeam(id: id, name: name); // Delegated to new method
  }

  Future<void> updateTeam({required String id, required String name, String? category}) {
    return _syncQueue.runAtomically(() async {
      final current = await find(id);
      if (current == null) {
        throw StateError('Team not found: $id');
      }
      final updated = current.copyWith(
        name: name,
        category: Value(category),
        updatedAt: DateTime.now().toUtc(),
        version: current.version + 1,
      );
      await _db.update(_db.teams).replace(updated);
      await _syncQueue.enqueueUpsert(
        entityType: SyncEntityType.team,
        entityId: updated.id,
        payload: _teamPayload(updated),
      );
    });
  }

  Future<int> deleteLocalDraft(String id) {
    return (_db.delete(_db.teams)..where((row) => row.id.equals(id))).go();
  }
}

Map<String, Object?> _teamPayload(Team team) {
  return {
    'id': team.id,
    'name': team.name,
    'category': team.category,
    'created_at': team.createdAt.toUtc().toIso8601String(),
    'updated_at': team.updatedAt.toUtc().toIso8601String(),
    'version': team.version,
  };
}
