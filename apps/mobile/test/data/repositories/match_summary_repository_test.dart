import 'package:flutter_test/flutter_test.dart';
import 'package:inline_hockey_coach/data/local/drift/app_database.dart';
import 'package:inline_hockey_coach/data/repositories/coach_repository.dart';
import 'package:inline_hockey_coach/data/repositories/match_action_repository.dart';
import 'package:inline_hockey_coach/data/repositories/match_summary_repository.dart';
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
  late MatchActionRepository matchActions;
  late MatchSummaryRepository matchSummary;
  late SyncQueueRepository syncQueue;

  setUp(() {
    db = AppDatabase.inMemory();
    syncQueue = SyncQueueRepository(db);
    coaches = CoachRepository(db, syncQueue: syncQueue);
    teams = TeamRepository(db, syncQueue: syncQueue);
    players = PlayerRepository(db, syncQueue: syncQueue);
    sessions = TournamentSessionRepository(db, syncQueue: syncQueue);
    matchActions = MatchActionRepository(db, syncQueue: syncQueue);
    matchSummary = MatchSummaryRepository(db);
  });

  tearDown(() => db.close());

  test('calculates summary correctly', () async {
    final coach = await coaches.create(const CoachDraft(displayName: 'Coach'));
    final team = await teams.create(const TeamDraft(name: 'Team A'));
    final skater1 = await players.create(
      PlayerDraft(
        teamId: team.id,
        displayName: 'S1',
        jerseyNumber: 10,
        defaultRole: PlayerRole.skater,
      ),
    );
    final skater2 = await players.create(
      PlayerDraft(
        teamId: team.id,
        displayName: 'S2',
        jerseyNumber: 11,
        defaultRole: PlayerRole.skater,
      ),
    );
    final gk = await players.create(
      PlayerDraft(
        teamId: team.id,
        displayName: 'GK',
        jerseyNumber: 1,
        defaultRole: PlayerRole.goalkeeper,
      ),
    );

    final session = await sessions.createDraft(
      TournamentSessionDraft(
        tournamentName: 'Test',
        scheduledDate: DateTime.now(),
        teamId: team.id,
        coachId: coach.id,
        activeGoalkeeperId: gk.id,
        deviceId: 'device-1',
        players: [
          SessionPlayerDraft(playerId: skater1.id, role: PlayerRole.skater),
          SessionPlayerDraft(playerId: skater2.id, role: PlayerRole.skater),
          SessionPlayerDraft(playerId: gk.id, role: PlayerRole.goalkeeper),
        ],
      ),
    );

    await sessions.updateClockState(
      sessionId: session.id,
      status: SessionStatus.inProgress,
      elapsedMs: 100,
    );

    await matchActions.recordPlayerAction(
      MatchActionDraft(
        sessionId: session.id,
        playerId: skater1.id,
        actionType: PlayerActionType.pass,
        chronometerMs: 100,
        deviceId: 'device-1',
      ),
    );

    await matchActions.recordPlayerAction(
      MatchActionDraft(
        sessionId: session.id,
        playerId: skater2.id,
        actionType: PlayerActionType.shoot,
        shotResult: ShotResult.goal,
        targetZone: GoalTargetZone.topLeft,
        chronometerMs: 200,
        deviceId: 'device-1',
      ),
    );

    await matchActions.recordGoalkeeperAction(
      GoalkeeperActionDraft(
        sessionId: session.id,
        goalkeeperId: gk.id,
        shotOriginZone: ShotOriginZone.zone1,
        result: GoalkeeperActionResult.save,
        chronometerMs: 300,
        deviceId: 'device-1',
      ),
    );

    final summary = await matchSummary.getMatchSummary(session.id);

    expect(summary.teamGoals, 1);
    expect(summary.teamPasses, 1);
    expect(summary.shotDistribution[GoalTargetZone.topLeft], 1);

    final gkSum = summary.goalkeeperSummary!;
    expect(gkSum.saves, 1);
    expect(gkSum.savePercentage, 1.0);
  });
}
