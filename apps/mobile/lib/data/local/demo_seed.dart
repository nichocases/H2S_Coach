import 'package:drift/drift.dart';
import 'package:inline_hockey_coach/data/local/drift/app_database.dart';
import 'package:inline_hockey_coach/domain/entities/hockey_enums.dart';
import 'package:inline_hockey_coach/domain/entities/local_models.dart';

const demoCoachId = '10000000-0000-4000-8000-000000000001';
const demoTeamId = '10000000-0000-4000-8000-000000000010';

const _demoPlayers = [
  _DemoPlayer(
    id: '10000000-0000-4000-8000-000000000101',
    name: 'Sofia Ruiz',
    jersey: 7,
    role: PlayerRole.skater,
  ),
  _DemoPlayer(
    id: '10000000-0000-4000-8000-000000000102',
    name: 'Mateo Arias',
    jersey: 12,
    role: PlayerRole.skater,
  ),
  _DemoPlayer(
    id: '10000000-0000-4000-8000-000000000103',
    name: 'Lucia Gomez',
    jersey: 19,
    role: PlayerRole.skater,
  ),
  _DemoPlayer(
    id: '10000000-0000-4000-8000-000000000104',
    name: 'Nicolas Perez',
    jersey: 23,
    role: PlayerRole.skater,
  ),
  _DemoPlayer(
    id: '10000000-0000-4000-8000-000000000105',
    name: 'Valentina Mora',
    jersey: 44,
    role: PlayerRole.skater,
  ),
  _DemoPlayer(
    id: '10000000-0000-4000-8000-000000000106',
    name: 'Daniel Cano',
    jersey: 1,
    role: PlayerRole.goalkeeper,
  ),
];

Future<void> ensureDemoSeed(AppDatabase db) {
  return db.transaction(() async {
    final existingTeam = await (db.select(
      db.teams,
    )..where((row) => row.id.equals(demoTeamId))).getSingleOrNull();
    if (existingTeam != null) {
      return;
    }

    final now = DateTime.now().toUtc();
    await db
        .into(db.coaches)
        .insertOnConflictUpdate(
          Coach(
            id: demoCoachId,
            displayName: 'Coach Demo',
            createdAt: now,
            updatedAt: now,
            version: 1,
          ),
        );
    await db
        .into(db.teams)
        .insertOnConflictUpdate(
          Team(
            id: demoTeamId,
            name: 'Patines Capital Sub-12',
            category: 'Sub-12',
            createdAt: now,
            updatedAt: now,
            version: 1,
          ),
        );

    for (final player in _demoPlayers) {
      await db
          .into(db.players)
          .insertOnConflictUpdate(
            Player(
              id: player.id,
              teamId: demoTeamId,
              displayName: player.name,
              jerseyNumber: player.jersey,
              defaultRole: player.role.storageValue,
              active: true,
              createdAt: now,
              updatedAt: now,
              version: 1,
            ),
          );
    }
  });
}

Future<DemoRosterSummary> loadDemoRosterSummary(AppDatabase db) async {
  final team = await (db.select(
    db.teams,
  )..where((row) => row.id.equals(demoTeamId))).getSingle();
  final players =
      await (db.select(db.players)..where(
            (row) => row.teamId.equals(demoTeamId) & row.active.equals(true),
          ))
          .get();
  final skaterCount = players
      .where((player) => player.defaultRole == PlayerRole.skater.storageValue)
      .length;
  final goalkeeperCount = players
      .where(
        (player) => player.defaultRole == PlayerRole.goalkeeper.storageValue,
      )
      .length;

  return DemoRosterSummary(
    teamName: team.name,
    skaterCount: skaterCount,
    goalkeeperCount: goalkeeperCount,
  );
}

class _DemoPlayer {
  const _DemoPlayer({
    required this.id,
    required this.name,
    required this.jersey,
    required this.role,
  });

  final String id;
  final String name;
  final int jersey;
  final PlayerRole role;
}
