import 'package:drift/drift.dart';
import 'package:inline_hockey_coach/data/local/drift/app_database.dart';
import 'package:inline_hockey_coach/domain/entities/hockey_enums.dart';
import 'package:inline_hockey_coach/domain/entities/local_models.dart';

class MatchSummaryRepository {
  MatchSummaryRepository(this._db);

  final AppDatabase _db;

  Future<MatchSummary> getMatchSummary(String sessionId) async {
    // 1. Fetch match actions (not voided)
    final matchActions =
        await (_db.select(_db.matchActions)..where(
              (row) => row.sessionId.equals(sessionId) & row.voidedAt.isNull(),
            ))
            .get();

    // 2. Fetch goalkeeper actions (not voided)
    final goalkeeperActions =
        await (_db.select(_db.goalkeeperActions)..where(
              (row) => row.sessionId.equals(sessionId) & row.voidedAt.isNull(),
            ))
            .get();

    // 3. Fetch players and session players to construct summaries
    final sessionPlayers = await (_db.select(
      _db.sessionPlayers,
    )..where((row) => row.sessionId.equals(sessionId))).get();

    if (sessionPlayers.isEmpty) {
      throw StateError('No players found for session: $sessionId');
    }

    final playerIds = sessionPlayers.map((p) => p.playerId).toSet();
    final players = await (_db.select(
      _db.players,
    )..where((row) => row.id.isIn(playerIds))).get();

    final playerMap = {for (final p in players) p.id: p};

    // Counters for Team
    var teamPasses = 0;
    var teamFailPasses = 0;
    var teamAssists = 0;
    var teamAttempts = 0;
    var teamShotsOnTarget = 0;
    var teamGoals = 0;

    // Shot distribution by GoalTargetZone
    final shotDistribution = <GoalTargetZone, int>{};

    // Group actions by player
    final actionsByPlayer = <String, List<MatchAction>>{};
    for (final action in matchActions) {
      actionsByPlayer.putIfAbsent(action.playerId, () => []).add(action);

      final type = PlayerActionType.fromStorage(action.actionType);
      switch (type) {
        case PlayerActionType.pass:
          teamPasses++;
        case PlayerActionType.failPass:
          teamFailPasses++;
        case PlayerActionType.assist:
          teamAssists++;
        case PlayerActionType.shoot:
          teamAttempts++;
          if (action.outcome == ShotResult.goal.storageValue ||
              action.outcome == ShotResult.hitKeeper.storageValue) {
            teamShotsOnTarget++;
          }
          if (action.outcome == ShotResult.goal.storageValue) {
            teamGoals++;
          }
          if (action.rinkZone != null) {
            final zone = GoalTargetZone.fromStorage(action.rinkZone!);
            shotDistribution[zone] = (shotDistribution[zone] ?? 0) + 1;
          }
      }
    }

    // Build PlayerSummaries
    final skaterSessionPlayers = sessionPlayers.where(
      (sp) => sp.role == PlayerRole.skater.storageValue,
    );
    final playerSummaries = <PlayerSummary>[];

    for (final sp in skaterSessionPlayers) {
      final player = playerMap[sp.playerId];
      if (player == null) continue;

      final pActions = actionsByPlayer[player.id] ?? [];
      var passes = 0;
      var failPasses = 0;
      var assists = 0;
      var attempts = 0;
      var shotsOnTarget = 0;
      var goals = 0;

      for (final a in pActions) {
        final type = PlayerActionType.fromStorage(a.actionType);
        if (type == PlayerActionType.pass) passes++;
        if (type == PlayerActionType.failPass) failPasses++;
        if (type == PlayerActionType.assist) assists++;
        if (type == PlayerActionType.shoot) {
          attempts++;
          if (a.outcome == ShotResult.goal.storageValue ||
              a.outcome == ShotResult.hitKeeper.storageValue) {
            shotsOnTarget++;
          }
          if (a.outcome == ShotResult.goal.storageValue) {
            goals++;
          }
        }
      }

      playerSummaries.add(
        PlayerSummary(
          playerId: player.id,
          displayName: player.displayName,
          jerseyNumber: player.jerseyNumber,
          passes: passes,
          failPasses: failPasses,
          assists: assists,
          attempts: attempts,
          shotsOnTarget: shotsOnTarget,
          goals: goals,
        ),
      );
    }

    // Build GoalkeeperSummary
    final goalkeeperSessionPlayer = sessionPlayers
        .where((sp) => sp.role == PlayerRole.goalkeeper.storageValue)
        .firstOrNull;
    GoalkeeperSummary? goalkeeperSummary;

    if (goalkeeperSessionPlayer != null) {
      final gkPlayer = playerMap[goalkeeperSessionPlayer.playerId];
      if (gkPlayer != null) {
        var saves = 0;
        var goalsAllowed = 0;

        for (final a in goalkeeperActions) {
          if (a.actionType == GoalkeeperActionResult.save.storageValue) {
            saves++;
          } else if (a.actionType ==
              GoalkeeperActionResult.goalAllowed.storageValue) {
            goalsAllowed++;
          }
        }

        goalkeeperSummary = GoalkeeperSummary(
          goalkeeperId: gkPlayer.id,
          displayName: gkPlayer.displayName,
          jerseyNumber: gkPlayer.jerseyNumber,
          saves: saves,
          goalsAllowed: goalsAllowed,
          shotsFaced: saves + goalsAllowed,
        );
      }
    }

    return MatchSummary(
      sessionId: sessionId,
      teamPasses: teamPasses,
      teamFailPasses: teamFailPasses,
      teamAssists: teamAssists,
      teamAttempts: teamAttempts,
      teamShotsOnTarget: teamShotsOnTarget,
      teamGoals: teamGoals,
      playerSummaries: playerSummaries,
      goalkeeperSummary: goalkeeperSummary,
      shotDistribution: shotDistribution,
    );
  }
}
