import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:inline_hockey_coach/data/local/drift/app_database.dart';
import 'package:inline_hockey_coach/domain/entities/hockey_enums.dart';
import 'package:uuid/uuid.dart';

class SyncQueueSummary {
  const SyncQueueSummary({
    required this.failedCount,
    required this.pendingCount,
    required this.syncingCount,
  });

  final int failedCount;
  final int pendingCount;
  final int syncingCount;
}

class SyncQueueRepository {
  SyncQueueRepository(this._db);

  final AppDatabase _db;
  final Uuid _uuid = const Uuid();

  Future<T> runAtomically<T>(Future<T> Function() action) {
    return _db.transaction(action);
  }

  Future<String> enqueueUpsert({
    required SyncEntityType entityType,
    required String entityId,
    required Map<String, Object?> payload,
  }) async {
    final now = DateTime.now().toUtc();
    final id = _uuid.v4();
    await _db
        .into(_db.syncQueue)
        .insert(
          SyncQueueCompanion.insert(
            id: id,
            entityType: entityType.storageValue,
            entityId: entityId,
            operation: Value(SyncOperation.upsert.storageValue),
            payloadJson: jsonEncode(payload),
            state: Value(SyncState.pending.storageValue),
            createdAt: now,
            updatedAt: now,
          ),
        );
    return id;
  }

  Future<List<SyncQueueData>> pending() {
    return (_db.select(
      _db.syncQueue,
    )..where((row) => row.state.equals(SyncState.pending.storageValue))).get();
  }

  Future<List<SyncQueueData>> readyBatch({
    DateTime? now,
    int limit = 200,
  }) async {
    final cutoff = (now ?? DateTime.now()).toUtc();
    final rows =
        await (_db.select(_db.syncQueue)
              ..where(
                (row) => row.state.isIn([
                  SyncState.pending.storageValue,
                  SyncState.failed.storageValue,
                ]),
              )
              ..orderBy([(row) => OrderingTerm.asc(row.createdAt)]))
            .get();

    return rows
        .where((row) {
          if (row.state == SyncState.pending.storageValue) {
            return true;
          }
          final nextAttemptAt = row.nextAttemptAt;
          return nextAttemptAt != null &&
              !nextAttemptAt.toUtc().isAfter(cutoff);
        })
        .take(limit)
        .toList(growable: false);
  }

  Future<void> recoverStaleSyncing() async {
    final now = DateTime.now().toUtc();
    await (_db.update(
      _db.syncQueue,
    )..where((row) => row.state.equals(SyncState.syncing.storageValue))).write(
      SyncQueueCompanion(
        state: Value(SyncState.pending.storageValue),
        updatedAt: Value(now),
      ),
    );
  }

  Future<void> markSyncing(Iterable<String> ids) async {
    final queueIds = ids.toSet();
    if (queueIds.isEmpty) {
      return;
    }
    await (_db.update(
      _db.syncQueue,
    )..where((row) => row.id.isIn(queueIds))).write(
      SyncQueueCompanion(
        state: Value(SyncState.syncing.storageValue),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  Future<void> markSynced(Iterable<String> ids) async {
    final queueIds = ids.toSet();
    if (queueIds.isEmpty) {
      return;
    }
    await (_db.delete(
      _db.syncQueue,
    )..where((row) => row.id.isIn(queueIds))).go();
  }

  Future<void> markFailed({
    required String id,
    required String error,
    DateTime? nextAttemptAt,
  }) async {
    final row = await (_db.select(
      _db.syncQueue,
    )..where((syncRow) => syncRow.id.equals(id))).getSingleOrNull();
    if (row == null) {
      return;
    }
    await (_db.update(
      _db.syncQueue,
    )..where((syncRow) => syncRow.id.equals(id))).write(
      SyncQueueCompanion(
        attempts: Value(row.attempts + 1),
        lastError: Value(error),
        nextAttemptAt: Value(nextAttemptAt),
        state: Value(SyncState.failed.storageValue),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  Future<void> releaseFailedForRetry() async {
    await (_db.update(
      _db.syncQueue,
    )..where((row) => row.state.equals(SyncState.failed.storageValue))).write(
      SyncQueueCompanion(
        lastError: const Value(null),
        nextAttemptAt: const Value(null),
        state: Value(SyncState.pending.storageValue),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  Future<SyncQueueSummary> summary() async {
    final rows = await _db.select(_db.syncQueue).get();
    return SyncQueueSummary(
      failedCount: rows
          .where((row) => row.state == SyncState.failed.storageValue)
          .length,
      pendingCount: rows
          .where((row) => row.state == SyncState.pending.storageValue)
          .length,
      syncingCount: rows
          .where((row) => row.state == SyncState.syncing.storageValue)
          .length,
    );
  }

  Future<int> pendingCount() async {
    final rows = await pending();
    return rows.length;
  }
}
