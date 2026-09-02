import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inline_hockey_coach/data/repositories/dashboard_repository.dart';
import 'package:inline_hockey_coach/features/teams/application/team_overview_providers.dart';
import 'package:inline_hockey_coach/domain/entities/dashboard_models.dart';

class DashboardFilterNotifier extends Notifier<DashboardFilter> {
  @override
  DashboardFilter build() => const DashboardFilter();

  void updateFilter(DashboardFilter newFilter) {
    state = newFilter;
  }
}

final dashboardFilterProvider = NotifierProvider<DashboardFilterNotifier, DashboardFilter>(() {
  return DashboardFilterNotifier();
});

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepository(ref.watch(databaseProvider));
});

DateTime? _getSinceFromFilter(DashboardFilter filter) {
  if (filter.dateRange == DashboardDateRange.last30Days) {
    return DateTime.now().subtract(const Duration(days: 30));
  }
  return null;
}

final teamMetricsProvider = FutureProvider<TeamDashboardMetrics>((ref) {
  final filter = ref.watch(dashboardFilterProvider);
  return ref.watch(dashboardRepositoryProvider).getTeamMetrics(
        categoryId: filter.categoryId,
        teamId: filter.teamId,
        tournamentName: filter.tournamentName,
        since: _getSinceFromFilter(filter),
      );
});

final playerLeaderboardProvider = FutureProvider<List<PlayerLeaderboardRow>>((ref) {
  final filter = ref.watch(dashboardFilterProvider);
  return ref.watch(dashboardRepositoryProvider).getPlayerLeaderboard(
        categoryId: filter.categoryId,
        teamId: filter.teamId,
        tournamentName: filter.tournamentName,
        since: _getSinceFromFilter(filter),
      );
});

final goalkeeperLeaderboardProvider = FutureProvider<List<GoalkeeperLeaderboardRow>>((ref) {
  final filter = ref.watch(dashboardFilterProvider);
  return ref.watch(dashboardRepositoryProvider).getGoalkeeperLeaderboard(
        categoryId: filter.categoryId,
        teamId: filter.teamId,
        tournamentName: filter.tournamentName,
        since: _getSinceFromFilter(filter),
      );
});

// Providers for the dropdowns
final uniqueCategoriesProvider = FutureProvider<List<String>>((ref) async {
  final db = ref.watch(databaseProvider);
  final rows = await db.customSelect('SELECT DISTINCT category FROM teams WHERE category IS NOT NULL ORDER BY category').get();
  return rows.map((r) => r.read<String>('category')).toList();
});

final uniqueTournamentsProvider = FutureProvider<List<String>>((ref) async {
  final db = ref.watch(databaseProvider);
  final rows = await db.customSelect('SELECT DISTINCT tournament_name FROM tournament_sessions WHERE tournament_name IS NOT NULL ORDER BY tournament_name').get();
  return rows.map((r) => r.read<String>('tournament_name')).toList();
});
