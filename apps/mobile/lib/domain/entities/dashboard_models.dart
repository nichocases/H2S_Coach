class TeamDashboardMetrics {
  const TeamDashboardMetrics({
    required this.matchesPlayed,
    required this.goalsFor,
    required this.goalsAgainst,
  });

  final int matchesPlayed;
  final int goalsFor;
  final int goalsAgainst;

  int get goalDifference => goalsFor - goalsAgainst;
}

class PlayerLeaderboardRow {
  const PlayerLeaderboardRow({
    required this.playerId,
    required this.playerName,
    required this.jerseyNumber,
    required this.goals,
    required this.assists,
    required this.shots,
  });

  final String playerId;
  final String playerName;
  final int jerseyNumber;
  final int goals;
  final int assists;
  final int shots;

  int get points => goals + assists;
  double get shootingPercentage => shots == 0 ? 0.0 : (goals / shots) * 100;
}

class GoalkeeperLeaderboardRow {
  const GoalkeeperLeaderboardRow({
    required this.playerId,
    required this.playerName,
    required this.jerseyNumber,
    required this.shotsFaced,
    required this.goalsAllowed,
  });

  final String playerId;
  final String playerName;
  final int jerseyNumber;
  final int shotsFaced;
  final int goalsAllowed;

  int get saves => shotsFaced - goalsAllowed;
  double get savePercentage => shotsFaced == 0 ? 0.0 : (saves / shotsFaced) * 100;
}

enum DashboardDateRange {
  allTime('Todo el tiempo'),
  last30Days('Últimos 30 días');

  const DashboardDateRange(this.label);
  final String label;
}

class DashboardFilter {
  const DashboardFilter({
    this.categoryId,
    this.teamId,
    this.tournamentName,
    this.dateRange = DashboardDateRange.allTime,
  });

  final String? categoryId;
  final String? teamId;
  final String? tournamentName;
  final DashboardDateRange dateRange;

  DashboardFilter copyWith({
    String? categoryId,
    String? teamId,
    String? tournamentName,
    DashboardDateRange? dateRange,
    bool clearCategory = false,
    bool clearTeam = false,
    bool clearTournament = false,
  }) {
    return DashboardFilter(
      categoryId: clearCategory ? null : (categoryId ?? this.categoryId),
      teamId: clearTeam ? null : (teamId ?? this.teamId),
      tournamentName: clearTournament ? null : (tournamentName ?? this.tournamentName),
      dateRange: dateRange ?? this.dateRange,
    );
  }
}
