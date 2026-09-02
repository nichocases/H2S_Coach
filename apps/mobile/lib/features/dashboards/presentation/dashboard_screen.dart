import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inline_hockey_coach/domain/entities/dashboard_models.dart';
import 'package:inline_hockey_coach/features/dashboards/application/dashboard_providers.dart';
import 'package:inline_hockey_coach/features/teams/application/team_overview_providers.dart';
import 'package:inline_hockey_coach/features/dashboards/presentation/widgets/goalkeeper_metrics_view.dart';
import 'package:inline_hockey_coach/features/dashboards/presentation/widgets/player_leaderboard_view.dart';
import 'package:inline_hockey_coach/features/dashboards/presentation/widgets/team_metrics_view.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DashboardFilter filter = ref.watch(dashboardFilterProvider);
    final teamsAsync = ref.watch(teamListProvider);
    final categoriesAsync = ref.watch(uniqueCategoriesProvider);
    final tournamentsAsync = ref.watch(uniqueTournamentsProvider);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Estadísticas'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'General'),
              Tab(text: 'Jugadores'),
              Tab(text: 'Arqueros'),
            ],
          ),
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
              width: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    // CATEGORIA
                    SizedBox(
                      width: 140,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String?>(
                          isExpanded: true,
                          value: filter.categoryId,
                          hint: const Text('Categoría'),
                          items: [
                            const DropdownMenuItem<String?>(
                              value: null,
                              child: Text('Todas', overflow: TextOverflow.ellipsis),
                            ),
                            if (categoriesAsync.value != null)
                              for (final c in categoriesAsync.value!)
                                DropdownMenuItem<String?>(
                                  value: c,
                                  child: Text(c, overflow: TextOverflow.ellipsis),
                                ),
                          ],
                          onChanged: (String? val) {
                            ref.read(dashboardFilterProvider.notifier).updateFilter(
                                filter.copyWith(categoryId: val, clearCategory: val == null));
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // EQUIPO
                    SizedBox(
                      width: 160,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String?>(
                          isExpanded: true,
                          value: filter.teamId,
                          hint: const Text('Equipo'),
                          items: [
                            const DropdownMenuItem<String?>(
                              value: null,
                              child: Text('Todos los equipos', overflow: TextOverflow.ellipsis),
                            ),
                            if (teamsAsync.value != null)
                              for (final t in teamsAsync.value!)
                                DropdownMenuItem<String?>(
                                  value: t.team.id,
                                  child: Text(t.team.name, overflow: TextOverflow.ellipsis),
                                ),
                          ],
                          onChanged: (String? val) {
                            ref.read(dashboardFilterProvider.notifier).updateFilter(
                                filter.copyWith(teamId: val, clearTeam: val == null));
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // TORNEO
                    SizedBox(
                      width: 160,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String?>(
                          isExpanded: true,
                          value: filter.tournamentName,
                          hint: const Text('Torneo'),
                          items: [
                            const DropdownMenuItem<String?>(
                              value: null,
                              child: Text('Todos los torneos', overflow: TextOverflow.ellipsis),
                            ),
                            if (tournamentsAsync.value != null)
                              for (final t in tournamentsAsync.value!)
                                DropdownMenuItem<String?>(
                                  value: t,
                                  child: Text(t, overflow: TextOverflow.ellipsis),
                                ),
                          ],
                          onChanged: (String? val) {
                            ref.read(dashboardFilterProvider.notifier).updateFilter(
                                filter.copyWith(tournamentName: val, clearTournament: val == null));
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // PERIODO
                    SizedBox(
                      width: 140,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<DashboardDateRange>(
                          isExpanded: true,
                          value: filter.dateRange,
                          items: DashboardDateRange.values.map((DashboardDateRange r) {
                            return DropdownMenuItem<DashboardDateRange>(
                              value: r,
                              child: Text(r.label, overflow: TextOverflow.ellipsis),
                            );
                          }).toList(),
                          onChanged: (DashboardDateRange? val) {
                            if (val != null) {
                              ref.read(dashboardFilterProvider.notifier).updateFilter(
                                  filter.copyWith(dateRange: val));
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  TeamMetricsView(),
                  PlayerLeaderboardView(),
                  GoalkeeperMetricsView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
