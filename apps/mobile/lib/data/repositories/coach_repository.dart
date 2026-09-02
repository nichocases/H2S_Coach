import 'package:drift/drift.dart';
import 'package:inline_hockey_coach/data/local/drift/app_database.dart';
import 'package:inline_hockey_coach/data/repositories/sync_queue_repository.dart';
import 'package:inline_hockey_coach/domain/entities/hockey_enums.dart';
import 'package:inline_hockey_coach/domain/entities/local_models.dart';
import 'package:uuid/uuid.dart';

class CoachRepository {
  CoachRepository(this._db, {SyncQueueRepository? syncQueue})
    : _syncQueue = syncQueue ?? SyncQueueRepository(_db);

  final AppDatabase _db;
  final SyncQueueRepository _syncQueue;
  final Uuid _uuid = const Uuid();

  Future<Coach> create(CoachDraft draft) {
    return _syncQueue.runAtomically(() async {
      final now = DateTime.now().toUtc();
      final coach = Coach(
        id: _uuid.v4(),
        displayName: draft.displayName,
        createdAt: now,
        updatedAt: now,
        version: 1,
      );
      await _db.into(_db.coaches).insert(coach);
      await _syncQueue.enqueueUpsert(
        entityType: SyncEntityType.coach,
        entityId: coach.id,
        payload: _coachPayload(coach),
      );
      return coach;
    });
  }

  Future<Coach?> find(String id) {
    return (_db.select(
      _db.coaches,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
  }

  Future<List<Coach>> list() {
    return (_db.select(
      _db.coaches,
    )..orderBy([(row) => OrderingTerm.asc(row.displayName)])).get();
  }

  Future<void> rename({required String id, required String displayName}) {
    return _syncQueue.runAtomically(() async {
      final current = await find(id);
      if (current == null) {
        throw StateError('Coach not found: $id');
      }
      final updated = current.copyWith(
        displayName: displayName,
        updatedAt: DateTime.now().toUtc(),
        version: current.version + 1,
      );
      await _db.update(_db.coaches).replace(updated);
      await _syncQueue.enqueueUpsert(
        entityType: SyncEntityType.coach,
        entityId: updated.id,
        payload: _coachPayload(updated),
      );
    });
  }

  Future<int> deleteLocalDraft(String id) {
    return (_db.delete(_db.coaches)..where((row) => row.id.equals(id))).go();
  }
}

Map<String, Object?> _coachPayload(Coach coach) {
  return {
    'id': coach.id,
    'display_name': coach.displayName,
    'created_at': coach.createdAt.toUtc().toIso8601String(),
    'updated_at': coach.updatedAt.toUtc().toIso8601String(),
    'version': coach.version,
  };
}
