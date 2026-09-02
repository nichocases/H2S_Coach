import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inline_hockey_coach/features/dashboards/application/dashboard_providers.dart';

class TeamMetricsView extends ConsumerWidget {
  const TeamMetricsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // For now we pass null to get metrics across all teams.
    // In Phase 9 we will add a filter.
    final metricsAsync = ref.watch(teamMetricsProvider);

    return metricsAsync.when(
      data: (metrics) {
        if (metrics.matchesPlayed == 0) {
          return const Center(
            child: Text('No hay partidos registrados todavía.'),
          );
        }

        final totalGoals = metrics.goalsFor + metrics.goalsAgainst;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                Expanded(
                  child: _MetricCard(
                    title: 'Partidos',
                    value: '${metrics.matchesPlayed}',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _MetricCard(
                    title: 'Goles a favor',
                    value: '${metrics.goalsFor}',
                    valueColor: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _MetricCard(
                    title: 'Goles en contra',
                    value: '${metrics.goalsAgainst}',
                    valueColor: Colors.red,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _MetricCard(
                    title: 'Diferencia',
                    value: '${metrics.goalDifference > 0 ? '+' : ''}${metrics.goalDifference}',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            if (totalGoals > 0) ...[
              Text(
                'Distribución de Goles',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 40,
                    sections: [
                      PieChartSectionData(
                        value: metrics.goalsFor.toDouble(),
                        title: '${metrics.goalsFor}',
                        color: Colors.green,
                        radius: 50,
                        titleStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      PieChartSectionData(
                        value: metrics.goalsAgainst.toDouble(),
                        title: '${metrics.goalsAgainst}',
                        color: Colors.red,
                        radius: 50,
                        titleStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _LegendItem(color: Colors.green, label: 'A Favor'),
                  SizedBox(width: 16),
                  _LegendItem(color: Colors.red, label: 'En Contra'),
                ],
              ),
            ],
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    this.valueColor,
  });

  final String title;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.labelMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: valueColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }
}
