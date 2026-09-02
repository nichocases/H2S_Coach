import 'package:flutter_test/flutter_test.dart';
import 'package:inline_hockey_coach/data/local/drift/app_database.dart';
import 'package:inline_hockey_coach/data/repositories/coach_repository.dart';
import 'package:inline_hockey_coach/data/repositories/match_action_repository.dart';
import 'package:inline_hockey_coach/data/repositories/player_repository.dart';
import 'package:inline_hockey_coach/data/repositories/session_repository.dart';
import 'package:inline_hockey_coach/data/repositories/sync_queue_repository.dart';
import 'package:inline_hockey_coach/data/repositories/team_repository.dart';
import 'package:inline_hockey_coach/domain/entities/hockey_enums.dart';
import 'package:inline_hockey_coach/domain/entities/local_models.dart';

void main() {
  late AppDatabase db;
  late CoachRepository coaches;
  late TeamRepository teams;
  late PlayerRepository players;
  late TournamentSessionRepository sessions;
  late MatchActionRepository actions;
  late SyncQueueRepository syncQueue;

  setUp(() {
    db = AppDatabase.inMemory();
    syncQueue = SyncQueueRepository(db);
    coaches = CoachRepository(db, syncQueue: syncQueue);
    teams = TeamRepository(db, syncQueue: syncQueue);
    players = PlayerRepository(db, syncQueue: syncQueue);
    sessions = TournamentSessionRepository(db, syncQueue: syncQueue);
    actions = MatchActionRepository(db, syncQueue: syncQueue);
  });

  tearDown(() => db.close());

  test('records a player action and enqueues sync atomically', () async {
    final fixture = await _createSessionFixture(
      coaches: coaches,
      teams: teams,
      players: players,
      sessions: sessions,
    );
    final queuedBefore = await syncQueue.pendingCount();

    final action = await actions.recordPlayerAction(
      MatchActionDraft(
        sessionId: fixture.session.id,
        playerId: fixture.skater.id,
        actionType: PlayerActionType.pass,
        chronometerMs: 1500,
        deviceId: fixture.session.deviceId,
      ),
    );

    expect(action.actionType, PlayerActionType.pass.storageValue);
    expect(action.clockMs, 1500);
    expect(await db.select(db.matchActions).get(), hasLength(1));
    expect(await db.select(db.shootDetails).get(), isEmpty);
    expect(await syncQueue.pendingCount(), queuedBefore + 1);
  });

  test(
    'rejects shots without result and target zone without local writes',
    () async {
      final fixture = await _createSessionFixture(
        coaches: coaches,
        teams: teams,
        players: players,
        sessions: sessions,
      );
      final queuedBefore = await syncQueue.pendingCount();

      await expectLater(
        actions.recordPlayerAction(
          MatchActionDraft(
            sessionId: fixture.session.id,
            playerId: fixture.skater.id,
            actionType: PlayerActionType.shoot,
            chronometerMs: 2200,
            deviceId: fixture.session.deviceId,
          ),
        ),
        throwsA(isA<MatchActionValidationException>()),
      );

      expect(await db.select(db.matchActions).get(), isEmpty);
      expect(await db.select(db.shootDetails).get(), isEmpty);
      expect(await syncQueue.pendingCount(), queuedBefore);
    },
  );

  test(
    'applies shot metric rules for goal, keeper hit, miss and block',
    () async {
      final fixture = await _createSessionFixture(
        coaches: coaches,
        teams: teams,
        players: players,
        sessions: sessions,
      );

      for (final result in ShotResult.values) {
        await actions.recordPlayerAction(
          MatchActionDraft(
            sessionId: fixture.session.id,
            playerId: fixture.skater.id,
            actionType: PlayerActionType.shoot,
            chronometerMs: 3000,
            deviceId: fixture.session.deviceId,
            shotResult: result,
            targetZone: GoalTargetZone.topLeft,
          ),
        );
      }

      final metrics = await actions.shotMetrics(fixture.session.id);

      expect(metrics.attempts, 4);
      expect(metrics.shotsOnTarget, 2);
      expect(metrics.goals, 1);
      expect(await db.select(db.shootDetails).get(), hasLength(4));
    },
  );

  test(
    'records active goalkeeper actions and derives summary metrics',
    () async {
      final fixture = await _createSessionFixture(
        coaches: coaches,
        teams: teams,
        players: players,
        sessions: sessions,
      );
      final queuedBefore = await syncQueue.pendingCount();

      await actions.recordGoalkeeperAction(
        GoalkeeperActionDraft(
          sessionId: fixture.session.id,
          goalkeeperId: fixture.goalkeeper.id,
          shotOriginZone: ShotOriginZone.zone1,
          result: GoalkeeperActionResult.save,
          chronometerMs: 4100,
          deviceId: fixture.session.deviceId,
        ),
      );
      await actions.recordGoalkeeperAction(
        GoalkeeperActionDraft(
          sessionId: fixture.session.id,
          goalkeeperId: fixture.goalkeeper.id,
          shotOriginZone: ShotOriginZone.zone4,
          result: GoalkeeperActionResult.goalAllowed,
          chronometerMs: 5200,
          deviceId: fixture.session.deviceId,
        ),
      );

      final metrics = await actions.goalkeeperMetrics(fixture.session.id);

      expect(metrics.shotsFaced, 2);
      expect(metrics.saves, 1);
      expect(metrics.goalsAllowed, 1);
      expect(metrics.savePercentage, 0.5);
      expect(await syncQueue.pendingCount(), queuedBefore + 2);
    },
  );

  test('rejects actions for a non-active goalkeeper', () async {
    final fixture = await _createSessionFixture(
      coaches: coaches,
      teams: teams,
      players: players,
      sessions: sessions,
    );
    final reserveGoalkeeper = await players.create(
      PlayerDraft(
        teamId: fixture.team.id,
        displayName: 'Reserva',
        jerseyNumber: 30,
        defaultRole: PlayerRole.goalkeeper,
      ),
    );

    await expectLater(
      actions.recordGoalkeeperAction(
        GoalkeeperActionDraft(
          sessionId: fixture.session.id,
          goalkeeperId: reserveGoalkeeper.id,
          shotOriginZone: ShotOriginZone.zone2,
          result: GoalkeeperActionResult.save,
          chronometerMs: 6000,
          deviceId: fixture.session.deviceId,
        ),
      ),
      throwsA(isA<MatchActionValidationException>()),
    );
  });

  test('rejects actions when session is not inProgress', () async {
    final fixture = await _createSessionFixture(
      coaches: coaches,
      teams: teams,
      players: players,
      sessions: sessions,
    );

    // Update state to finished
    await sessions.finishSession(fixture.session.id);

    await expectLater(
      actions.recordPlayerAction(
        MatchActionDraft(
          sessionId: fixture.session.id,
          playerId: fixture.skater.id,
          actionType: PlayerActionType.pass,
          chronometerMs: 1250,
          deviceId: '10000000-0000-4000-8000-000000000201',
        ),
      ),
      throwsA(isA<MatchActionValidationException>()),
    );
  });

  test(
    'voids the latest event without deleting it and excludes summaries',
    () async {
      final fixture = await _createSessionFixture(
        coaches: coaches,
        teams: teams,
        players: players,
        sessions: sessions,
      );
      final queuedBefore = await syncQueue.pendingCount();

      await actions.recordPlayerAction(
        MatchActionDraft(
          sessionId: fixture.session.id,
          playerId: fixture.skater.id,
          actionType: PlayerActionType.shoot,
          chronometerMs: 7300,
          deviceId: fixture.session.deviceId,
          shotResult: ShotResult.goal,
          targetZone: GoalTargetZone.bottomRight,
        ),
      );

      final voided = await actions.voidLatestEvent(
        sessionId: fixture.session.id,
        reason: 'Correccion',
      );
      final persistedAction = (await db.select(db.matchActions).get()).single;
      final metrics = await actions.shotMetrics(fixture.session.id);

      expect(voided, isNotNull);
      expect(voided!.isVoided, isTrue);
      expect(persistedAction.voidedAt, isNotNull);
      expect(await db.select(db.matchActions).get(), hasLength(1));
      expect(metrics.attempts, 0);
      expect(metrics.shotsOnTarget, 0);
      expect(metrics.goals, 0);
      expect(await syncQueue.pendingCount(), queuedBefore + 2);
    },
  );
}

Future<_SessionFixture> _createSessionFixture({
  required CoachRepository coaches,
  required TeamRepository teams,
  required PlayerRepository players,
  required TournamentSessionRepository sessions,
}) async {
  final coach = await coaches.create(const CoachDraft(displayName: 'Coach'));
  final team = await teams.create(const TeamDraft(name: 'Patines'));
  final skater = await players.create(
    PlayerDraft(
      teamId: team.id,
      displayName: 'Skater',
      jerseyNumber: 10,
      defaultRole: PlayerRole.skater,
    ),
  );
  final goalkeeper = await players.create(
    PlayerDraft(
      teamId: team.id,
      displayName: 'Goalkeeper',
      jerseyNumber: 1,
      defaultRole: PlayerRole.goalkeeper,
    ),
  );
  final session = await sessions.createDraft(
    TournamentSessionDraft(
      tournamentName: 'Copa Bogota',
      scheduledDate: DateTime.utc(2026, 9, 5),
      teamId: team.id,
      coachId: coach.id,
      activeGoalkeeperId: goalkeeper.id,
      deviceId: '10000000-0000-4000-8000-000000000301',
      players: [
        SessionPlayerDraft(playerId: skater.id, role: PlayerRole.skater),
        SessionPlayerDraft(
          playerId: goalkeeper.id,
          role: PlayerRole.goalkeeper,
        ),
      ],
    ),
  );

  final inProgressSession = await sessions.updateClockState(
    sessionId: session.id,
    status: SessionStatus.inProgress,
    elapsedMs: 0,
  );

  return _SessionFixture(
    coach: coach,
    team: team,
    skater: skater,
    goalkeeper: goalkeeper,
    session: inProgressSession,
  );
}

class _SessionFixture {
  const _SessionFixture({
    required this.coach,
    required this.team,
    required this.skater,
    required this.goalkeeper,
    required this.session,
  });

  final Coach coach;
  final Team team;
  final Player skater;
  final Player goalkeeper;
  final TournamentSession session;
}
