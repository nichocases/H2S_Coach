// Drift check constraints intentionally reference the column getter that each
// constraint defines.
// ignore_for_file: recursive_getters

import 'package:drift/drift.dart';
import 'package:inline_hockey_coach/domain/entities/hockey_enums.dart';
import 'connection/connection.dart';

part 'app_database.g.dart';

const _uuidLength = 36;

List<String> _storageValues<T extends Enum>(
  List<T> values,
  String Function(T value) toStorage,
) {
  return values.map(toStorage).toList(growable: false);
}

@DataClassName('Coach')
class Coaches extends Table {
  TextColumn get id => text().withLength(min: _uuidLength, max: _uuidLength)();
  TextColumn get displayName => text().withLength(min: 1, max: 120)();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  IntColumn get version => integer()
      .withDefault(const Constant(1))
      .check(version.isBiggerOrEqualValue(1))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Teams extends Table {
  TextColumn get id => text().withLength(min: _uuidLength, max: _uuidLength)();
  TextColumn get name => text().withLength(min: 1, max: 120)();
  TextColumn get category => text().withLength(max: 80).nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  IntColumn get version => integer()
      .withDefault(const Constant(1))
      .check(version.isBiggerOrEqualValue(1))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Players extends Table {
  TextColumn get id => text().withLength(min: _uuidLength, max: _uuidLength)();
  TextColumn get teamId => text().references(Teams, #id)();
  TextColumn get displayName => text().withLength(min: 1, max: 120)();
  IntColumn get jerseyNumber =>
      integer().check(jerseyNumber.isBetweenValues(0, 99))();
  TextColumn get defaultRole => text().check(
    defaultRole.isIn(
      _storageValues(PlayerRole.values, (role) => role.storageValue),
    ),
  )();

  BoolColumn get active => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  IntColumn get version => integer()
      .withDefault(const Constant(1))
      .check(version.isBiggerOrEqualValue(1))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class TournamentSessions extends Table {
  TextColumn get id => text().withLength(min: _uuidLength, max: _uuidLength)();
  TextColumn get tournamentName => text().withLength(min: 1, max: 120)();
  TextColumn get scheduledDate => text().withLength(min: 10, max: 10)();
  TextColumn get startTime => text().withLength(min: 5, max: 5).nullable()();
  TextColumn get teamId => text().references(Teams, #id)();
  TextColumn get coachId => text().references(Coaches, #id)();
  TextColumn get activeGoalkeeperId => text().references(Players, #id)();
  TextColumn get status => text().check(
    status.isIn(
      _storageValues(SessionStatus.values, (status) => status.storageValue),
    ),
  )();
  IntColumn get elapsedMs => integer()
      .withDefault(const Constant(0))
      .check(elapsedMs.isBiggerOrEqualValue(0))();
  DateTimeColumn get startedAt => dateTime().nullable()();
  DateTimeColumn get finishedAt => dateTime().nullable()();
  TextColumn get deviceId =>
      text().withLength(min: _uuidLength, max: _uuidLength)();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  IntColumn get version => integer()
      .withDefault(const Constant(1))
      .check(version.isBiggerOrEqualValue(1))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class SessionPlayers extends Table {
  TextColumn get sessionId =>
      text().references(TournamentSessions, #id, onDelete: KeyAction.cascade)();
  TextColumn get playerId => text().references(Players, #id)();
  TextColumn get role => text().check(
    role.isIn(_storageValues(PlayerRole.values, (role) => role.storageValue)),
  )();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  IntColumn get version => integer()
      .withDefault(const Constant(1))
      .check(version.isBiggerOrEqualValue(1))();

  @override
  Set<Column<Object>> get primaryKey => {sessionId, playerId};
}

class MatchActions extends Table {
  TextColumn get id => text().withLength(min: _uuidLength, max: _uuidLength)();
  TextColumn get sessionId => text().references(TournamentSessions, #id)();
  TextColumn get playerId => text().references(Players, #id)();
  TextColumn get actionType => text()();
  TextColumn get outcome => text().nullable()();
  IntColumn get clockMs => integer().check(clockMs.isBiggerOrEqualValue(0))();
  TextColumn get rinkZone => text().nullable()();
  TextColumn get note => text().nullable()();
  TextColumn get clientEventId =>
      text().withLength(min: _uuidLength, max: _uuidLength)();
  TextColumn get deviceId =>
      text().withLength(min: _uuidLength, max: _uuidLength)();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  IntColumn get version => integer()
      .withDefault(const Constant(1))
      .check(version.isBiggerOrEqualValue(1))();
  DateTimeColumn get voidedAt => dateTime().nullable()();
  TextColumn get voidReason => text().withLength(max: 200).nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {deviceId, clientEventId},
  ];
}

class ShootDetails extends Table {
  TextColumn get actionId =>
      text().references(MatchActions, #id, onDelete: KeyAction.cascade)();
  TextColumn get targetZone => text()();
  BoolColumn get isGoal => boolean()();
  BoolColumn get goalieTouched => boolean().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {actionId};
}

class GoalkeeperActions extends Table {
  TextColumn get id => text().withLength(min: _uuidLength, max: _uuidLength)();
  TextColumn get sessionId => text().references(TournamentSessions, #id)();
  TextColumn get goalkeeperId => text().references(Players, #id)();
  TextColumn get actionType => text()();
  IntColumn get clockMs => integer().check(clockMs.isBiggerOrEqualValue(0))();
  TextColumn get rinkZone => text().nullable()();
  TextColumn get targetZone => text().nullable()();
  TextColumn get note => text().nullable()();
  TextColumn get clientEventId =>
      text().withLength(min: _uuidLength, max: _uuidLength)();
  TextColumn get deviceId =>
      text().withLength(min: _uuidLength, max: _uuidLength)();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  IntColumn get version => integer()
      .withDefault(const Constant(1))
      .check(version.isBiggerOrEqualValue(1))();
  DateTimeColumn get voidedAt => dateTime().nullable()();
  TextColumn get voidReason => text().withLength(max: 200).nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {deviceId, clientEventId},
  ];
}

class SyncQueue extends Table {
  TextColumn get id => text().withLength(min: _uuidLength, max: _uuidLength)();
  TextColumn get entityType => text().check(
    entityType.isIn(
      _storageValues(SyncEntityType.values, (type) => type.storageValue),
    ),
  )();
  TextColumn get entityId =>
      text().withLength(min: _uuidLength, max: _uuidLength)();
  TextColumn get operation => text().withDefault(
    Constant(SyncOperation.upsert.storageValue),
  )();
  TextColumn get payloadJson => text()();
  TextColumn get state =>
      text().withDefault(Constant(SyncState.pending.storageValue))();
  IntColumn get attempts => integer()
      .withDefault(const Constant(0))
      .check(attempts.isBiggerOrEqualValue(0))();
  DateTimeColumn get nextAttemptAt => dateTime().nullable()();
  TextColumn get lastError => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    Coaches,
    Teams,
    Players,
    TournamentSessions,
    SessionPlayers,
    MatchActions,
    ShootDetails,
    GoalkeeperActions,
    SyncQueue,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  factory AppDatabase.openDefault() {
    return AppDatabase(openConnection());
  }

  factory AppDatabase.inMemory() {
    return AppDatabase(openMemoryConnection());
  }

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async {
      await migrator.createAll();
      await _createPartialIndexes();
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  Future<void> _createPartialIndexes() async {
    await customStatement(
      'CREATE UNIQUE INDEX IF NOT EXISTS uq_players_active_team_jersey '
      'ON players(team_id, jersey_number) WHERE active = 1',
    );
  }
}
