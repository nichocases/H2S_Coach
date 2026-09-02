import 'package:flutter_test/flutter_test.dart';
import 'package:inline_hockey_coach/data/local/drift/app_database.dart';
import 'package:inline_hockey_coach/data/repositories/dashboard_repository.dart';
import 'package:uuid/uuid.dart';

void main() {
  late AppDatabase db;
  late DashboardRepository repo;
  const uuid = Uuid();

  setUp(() {
    db = AppDatabase.inMemory();
    repo = DashboardRepository(db);
  });

  tearDown(() => db.close());

  Future<String> createTeam() async {
    final id = uuid.v4();
    await db.into(db.teams).insert(
      Team(
        id: id,
        name: 'Test Team',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        version: 1,
      ),
    );
    return id;
  }

  Future<String> createPlayer(String teamId, String role, {int jerseyNumber = 10}) async {
    final id = uuid.v4();
    await db.into(db.players).insert(
      Player(
        id: id,
        teamId: teamId,
        displayName: 'Player $id',
        jerseyNumber: jerseyNumber,
        defaultRole: role,
        active: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        version: 1,
      ),
    );
    return id;
  }

  Future<String> createCoach() async {
    final id = uuid.v4();
    await db.into(db.coaches).insert(
      Coach(
        id: id,
        displayName: 'Test Coach',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        version: 1,
      ),
    );
    return id;
  }

  Future<String> createSession(String teamId, String coachId, String goalkeeperId) async {
    final id = uuid.v4();
    await db.into(db.tournamentSessions).insert(
      TournamentSession(
        id: id,
        tournamentName: 'Test',
        scheduledDate: '2026-01-01',
        startTime: '10:00',
        teamId: teamId,
        coachId: coachId,
        activeGoalkeeperId: goalkeeperId,
        deviceId: uuid.v4(),
        status: 'FINISHED',
        elapsedMs: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        version: 1,
      ),
    );
    return id;
  }

  test('getTeamMetrics calculates goals correctly', () async {
    final teamId = await createTeam();
    final coachId = await createCoach();
    final p1 = await createPlayer(teamId, 'SKATER');
    final g1 = await createPlayer(teamId, 'GOALKEEPER', jerseyNumber: 1);
    final session1 = await createSession(teamId, coachId, g1);

    // Goal for
    await db.into(db.matchActions).insert(
      MatchAction(
        id: uuid.v4(),
        sessionId: session1,
        playerId: p1,
        actionType: 'SHOOT',
        outcome: 'GOAL',
        clockMs: 100,
        clientEventId: uuid.v4(),
        deviceId: uuid.v4(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        version: 1,
      ),
    );

    // Goal against
    await db.into(db.goalkeeperActions).insert(
      GoalkeeperAction(
        id: uuid.v4(),
        sessionId: session1,
        goalkeeperId: g1,
        actionType: 'GOAL_ALLOWED',
        clockMs: 200,
        clientEventId: uuid.v4(),
        deviceId: uuid.v4(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        version: 1,
      ),
    );

    final metrics = await repo.getTeamMetrics(teamId: teamId);
    expect(metrics.matchesPlayed, 1);
    expect(metrics.goalsFor, 1);
    expect(metrics.goalsAgainst, 1);
    expect(metrics.goalDifference, 0);
  });

  test('getPlayerLeaderboard aggregates goals, assists, shots', () async {
    final teamId = await createTeam();
    final coachId = await createCoach();
    final p1 = await createPlayer(teamId, 'SKATER');
    final g1 = await createPlayer(teamId, 'GOALKEEPER', jerseyNumber: 1);
    final session1 = await createSession(teamId, coachId, g1);

    // 1 Goal
    await db.into(db.matchActions).insert(
      MatchAction(
        id: uuid.v4(),
        sessionId: session1,
        playerId: p1,
        actionType: 'SHOOT',
        outcome: 'GOAL',
        clockMs: 100,
        clientEventId: uuid.v4(),
        deviceId: uuid.v4(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        version: 1,
      ),
    );

    // 1 Missed Shot
    await db.into(db.matchActions).insert(
      MatchAction(
        id: uuid.v4(),
        sessionId: session1,
        playerId: p1,
        actionType: 'SHOOT',
        outcome: 'MISSED',
        clockMs: 150,
        clientEventId: uuid.v4(),
        deviceId: uuid.v4(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        version: 1,
      ),
    );

    // 1 Assist
    await db.into(db.matchActions).insert(
      MatchAction(
        id: uuid.v4(),
        sessionId: session1,
        playerId: p1,
        actionType: 'ASSIST',
        clockMs: 200,
        clientEventId: uuid.v4(),
        deviceId: uuid.v4(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        version: 1,
      ),
    );

    final board = await repo.getPlayerLeaderboard(teamId: teamId);
    expect(board.length, 1);
    expect(board.first.goals, 1);
    expect(board.first.assists, 1);
    expect(board.first.shots, 2);
    expect(board.first.points, 2);
    expect(board.first.shootingPercentage, 50.0);
  });

  test('getGoalkeeperLeaderboard calculates SV%', () async {
    final teamId = await createTeam();
    final coachId = await createCoach();
    final g1 = await createPlayer(teamId, 'GOALKEEPER', jerseyNumber: 1);
    final session1 = await createSession(teamId, coachId, g1);

    // Save
    await db.into(db.goalkeeperActions).insert(
      GoalkeeperAction(
        id: uuid.v4(),
        sessionId: session1,
        goalkeeperId: g1,
        actionType: 'SAVE',
        clockMs: 100,
        clientEventId: uuid.v4(),
        deviceId: uuid.v4(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        version: 1,
      ),
    );

    // Goal Allowed
    await db.into(db.goalkeeperActions).insert(
      GoalkeeperAction(
        id: uuid.v4(),
        sessionId: session1,
        goalkeeperId: g1,
        actionType: 'GOAL_ALLOWED',
        clockMs: 200,
        clientEventId: uuid.v4(),
        deviceId: uuid.v4(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        version: 1,
      ),
    );

    final board = await repo.getGoalkeeperLeaderboard(teamId: teamId);
    expect(board.length, 1);
    expect(board.first.shotsFaced, 2);
    expect(board.first.goalsAllowed, 1);
    expect(board.first.saves, 1);
    expect(board.first.savePercentage, 50.0);
  });

  test('getTeamMetrics respects since date filter', () async {
    final teamId = await createTeam();
    final coachId = await createCoach();
    final p1 = await createPlayer(teamId, 'SKATER');
    final g1 = await createPlayer(teamId, 'GOALKEEPER', jerseyNumber: 99);
    final session1 = await createSession(teamId, coachId, g1);

    // Goal for (old - should be filtered out if we pass DateTime.now)
    final oldDate = DateTime.now().subtract(const Duration(days: 40)).toUtc();
    
    // update session1 to be old
    await db.customUpdate(
      'UPDATE tournament_sessions SET created_at = ? WHERE id = ?',
      variables: [Variable.withDateTime(oldDate), Variable.withString(session1)],
      updates: {db.tournamentSessions},
    );

    await db.into(db.matchActions).insert(
      MatchAction(
        id: uuid.v4(),
        sessionId: session1,
        playerId: p1,
        actionType: 'SHOOT',
        outcome: 'GOAL',
        clockMs: 100,
        clientEventId: uuid.v4(),
        deviceId: uuid.v4(),
        createdAt: oldDate,
        updatedAt: oldDate,
        version: 1,
      ),
    );

    final since = DateTime.now().subtract(const Duration(days: 30));
    final metrics = await repo.getTeamMetrics(teamId: teamId, since: since);
    
    // The match is older than 30 days, so metrics should be 0.
    expect(metrics.matchesPlayed, 0);
    expect(metrics.goalsFor, 0);
  });
}
