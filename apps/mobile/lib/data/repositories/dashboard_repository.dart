import 'package:drift/drift.dart';
import 'package:inline_hockey_coach/data/local/drift/app_database.dart';
import 'package:inline_hockey_coach/domain/entities/dashboard_models.dart';

class DashboardRepository {
  DashboardRepository(this._db);

  final AppDatabase _db;

  Future<TeamDashboardMetrics> getTeamMetrics({
    String? categoryId,
    String? teamId,
    String? tournamentName,
    DateTime? since,
  }) async {
    final categoryFilter = categoryId != null ? "AND t.category = ?" : "";
    final teamFilter = teamId != null ? "AND s.team_id = ?" : "";
    final tournamentFilter = tournamentName != null ? "AND s.tournament_name = ?" : "";
    final dateFilter = since != null ? "AND s.created_at >= ?" : "";
    
    final vars = <Variable<Object>>[];
    if (categoryId != null) vars.add(Variable.withString(categoryId));
    if (teamId != null) vars.add(Variable.withString(teamId));
    if (tournamentName != null) vars.add(Variable.withString(tournamentName));
    if (since != null) vars.add(Variable.withDateTime(since));

    final gfQuery = await _db.customSelect(
      '''
      SELECT COUNT(*) AS c 
      FROM match_actions m
      JOIN tournament_sessions s ON s.id = m.session_id
      JOIN teams t ON t.id = s.team_id
      WHERE m.action_type = 'SHOOT' AND m.outcome = 'GOAL' AND m.voided_at IS NULL 
        $categoryFilter $teamFilter $tournamentFilter $dateFilter
      ''',
      variables: vars,
    ).getSingle();
    final gf = gfQuery.read<int>('c');

    final gcQuery = await _db.customSelect(
      '''
      SELECT COUNT(*) AS c 
      FROM goalkeeper_actions g
      JOIN tournament_sessions s ON s.id = g.session_id
      JOIN teams t ON t.id = s.team_id
      WHERE g.action_type = 'GOAL_ALLOWED' AND g.voided_at IS NULL 
        $categoryFilter $teamFilter $tournamentFilter $dateFilter
      ''',
      variables: vars,
    ).getSingle();
    final gc = gcQuery.read<int>('c');

    final mpQuery = await _db.customSelect(
      '''
      SELECT COUNT(DISTINCT s.id) AS c
      FROM tournament_sessions s
      JOIN teams t ON t.id = s.team_id
      WHERE s.status IN ('FINISHED', 'IN_PROGRESS') 
        $categoryFilter $teamFilter $tournamentFilter $dateFilter
      ''',
      variables: vars,
    ).getSingle();
    final mp = mpQuery.read<int>('c');

    return TeamDashboardMetrics(
      matchesPlayed: mp,
      goalsFor: gf,
      goalsAgainst: gc,
    );
  }

  Future<List<PlayerLeaderboardRow>> getPlayerLeaderboard({
    String? categoryId,
    String? teamId,
    String? tournamentName,
    DateTime? since,
  }) async {
    final teamFilter = teamId != null ? "AND p.team_id = ?" : "";
    final categoryFilter = categoryId != null ? "AND t.category = ?" : "";
    final tournamentFilter = tournamentName != null ? "AND s.tournament_name = ?" : "";
    final dateFilter = since != null ? "AND s.created_at >= ?" : "";
    
    final vars = <Variable<Object>>[];
    if (categoryId != null) vars.add(Variable.withString(categoryId));
    if (tournamentName != null) vars.add(Variable.withString(tournamentName));
    if (since != null) vars.add(Variable.withDateTime(since));
    if (teamId != null) vars.add(Variable.withString(teamId));

    final rows = await _db.customSelect(
      '''
      SELECT 
        p.id AS player_id,
        p.display_name AS player_name,
        p.jersey_number AS jersey,
        SUM(CASE WHEN m.action_type = 'SHOOT' AND m.outcome = 'GOAL' THEN 1 ELSE 0 END) AS goals,
        SUM(CASE WHEN m.action_type = 'ASSIST' THEN 1 ELSE 0 END) AS assists,
        SUM(CASE WHEN m.action_type = 'SHOOT' THEN 1 ELSE 0 END) AS shots
      FROM players p
      LEFT JOIN (
        SELECT ma.* FROM match_actions ma 
        JOIN tournament_sessions s ON s.id = ma.session_id
        JOIN teams t ON t.id = s.team_id
        WHERE ma.voided_at IS NULL $categoryFilter $tournamentFilter $dateFilter
      ) m ON m.player_id = p.id
      WHERE p.default_role = 'SKATER' $teamFilter
      GROUP BY p.id
      ORDER BY goals DESC, assists DESC, shots DESC
      ''',
      variables: vars,
    ).get();

    return rows.map((row) {
      return PlayerLeaderboardRow(
        playerId: row.read<String>('player_id'),
        playerName: row.read<String>('player_name'),
        jerseyNumber: row.read<int>('jersey'),
        goals: row.read<int>('goals') ?? 0,
        assists: row.read<int>('assists') ?? 0,
        shots: row.read<int>('shots') ?? 0,
      );
    }).toList();
  }

  Future<List<GoalkeeperLeaderboardRow>> getGoalkeeperLeaderboard({
    String? categoryId,
    String? teamId,
    String? tournamentName,
    DateTime? since,
  }) async {
    final teamFilter = teamId != null ? "AND p.team_id = ?" : "";
    final categoryFilter = categoryId != null ? "AND t.category = ?" : "";
    final tournamentFilter = tournamentName != null ? "AND s.tournament_name = ?" : "";
    final dateFilter = since != null ? "AND s.created_at >= ?" : "";
    
    final vars = <Variable<Object>>[];
    if (categoryId != null) vars.add(Variable.withString(categoryId));
    if (tournamentName != null) vars.add(Variable.withString(tournamentName));
    if (since != null) vars.add(Variable.withDateTime(since));
    if (teamId != null) vars.add(Variable.withString(teamId));

    final rows = await _db.customSelect(
      '''
      SELECT 
        p.id AS player_id,
        p.display_name AS player_name,
        p.jersey_number AS jersey,
        SUM(CASE WHEN g.action_type = 'GOAL_ALLOWED' THEN 1 ELSE 0 END) AS goals_allowed,
        COUNT(g.id) AS shots_faced
      FROM players p
      LEFT JOIN (
        SELECT ga.* FROM goalkeeper_actions ga 
        JOIN tournament_sessions s ON s.id = ga.session_id
        JOIN teams t ON t.id = s.team_id
        WHERE ga.voided_at IS NULL $categoryFilter $tournamentFilter $dateFilter
      ) g ON g.goalkeeper_id = p.id
      WHERE p.default_role = 'GOALKEEPER' $teamFilter
      GROUP BY p.id
      ORDER BY shots_faced DESC, goals_allowed ASC
      ''',
      variables: vars,
    ).get();

    return rows.map((row) {
      return GoalkeeperLeaderboardRow(
        playerId: row.read<String>('player_id'),
        playerName: row.read<String>('player_name'),
        jerseyNumber: row.read<int>('jersey'),
        goalsAllowed: row.read<int>('goals_allowed') ?? 0,
        shotsFaced: row.read<int>('shots_faced'),
      );
    }).toList();
  }
}
