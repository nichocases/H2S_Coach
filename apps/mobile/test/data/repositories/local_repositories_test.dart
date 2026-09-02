import 'package:flutter_test/flutter_test.dart';
import 'package:inline_hockey_coach/data/local/drift/app_database.dart';
import 'package:inline_hockey_coach/data/repositories/coach_repository.dart';
import 'package:inline_hockey_coach/data/repositories/player_repository.dart';
import 'package:inline_hockey_coach/data/repositories/team_repository.dart';
import 'package:inline_hockey_coach/domain/entities/hockey_enums.dart';
import 'package:inline_hockey_coach/domain/entities/local_models.dart';

void main() {
  late AppDatabase db;
  late CoachRepository coaches;
  late TeamRepository teams;
  late PlayerRepository players;

  setUp(() {
    db = AppDatabase.inMemory();
    coaches = CoachRepository(db);
    teams = TeamRepository(db);
    players = PlayerRepository(db);
  });

  tearDown(() => db.close());

  test(
    'coach, team and player repositories persist CRUD changes locally',
    () async {
      final coach = await coaches.create(
        const CoachDraft(displayName: 'Coach A'),
      );
      final team = await teams.create(
        const TeamDraft(name: 'Halcones', category: 'U12'),
      );
      final player = await players.create(
        PlayerDraft(
          teamId: team.id,
          displayName: 'Jugador 7',
          jerseyNumber: 7,
          defaultRole: PlayerRole.skater,
        ),
      );

      await coaches.rename(id: coach.id, displayName: 'Coach B');
      await teams.rename(id: team.id, name: 'Halcones Norte');
      await players.rename(id: player.id, displayName: 'Jugador 8');

      expect((await coaches.find(coach.id))?.displayName, 'Coach B');
      expect((await teams.find(team.id))?.name, 'Halcones Norte');
      expect((await players.find(player.id))?.displayName, 'Jugador 8');
      expect(await players.listForTeam(team.id), hasLength(1));

      await players.deactivate(player.id);
      expect((await players.find(player.id))?.active, isFalse);
    },
  );

  test(
    'active jersey numbers are unique per team but reusable when inactive',
    () async {
      final team = await teams.create(const TeamDraft(name: 'Patines'));

      await players.create(
        PlayerDraft(
          teamId: team.id,
          displayName: 'Primero',
          jerseyNumber: 9,
          defaultRole: PlayerRole.skater,
        ),
      );

      await expectLater(
        players.create(
          PlayerDraft(
            teamId: team.id,
            displayName: 'Duplicado',
            jerseyNumber: 9,
            defaultRole: PlayerRole.skater,
          ),
        ),
        throwsA(isA<Exception>()),
      );

      final original = (await players.listForTeam(team.id)).single;
      await players.deactivate(original.id);

      final replacement = await players.create(
        PlayerDraft(
          teamId: team.id,
          displayName: 'Reemplazo',
          jerseyNumber: 9,
          defaultRole: PlayerRole.skater,
        ),
      );

      expect(replacement.jerseyNumber, 9);
    },
  );

  test(
    'sync queue writes roll back with the local entity transaction',
    () async {
      final syncQueue = db.syncQueue;

      await expectLater(
        db.transaction(() async {
          await db
              .into(db.coaches)
              .insert(
                CoachesCompanion.insert(
                  id: '10000000-0000-4000-8000-00000000abcd',
                  displayName: 'Temporal',
                  createdAt: DateTime.utc(2026),
                  updatedAt: DateTime.utc(2026),
                ),
              );
          await db
              .into(syncQueue)
              .insert(
                SyncQueueCompanion.insert(
                  id: '10000000-0000-4000-8000-00000000dcba',
                  entityType: SyncEntityType.coach.storageValue,
                  entityId: '10000000-0000-4000-8000-00000000abcd',
                  payloadJson: '{}',
                  createdAt: DateTime.utc(2026),
                  updatedAt: DateTime.utc(2026),
                ),
              );
          throw StateError('rollback');
        }),
        throwsStateError,
      );

      expect(await db.select(db.coaches).get(), isEmpty);
      expect(await db.select(syncQueue).get(), isEmpty);
    },
  );
}
