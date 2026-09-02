import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inline_hockey_coach/features/teams/application/team_overview_providers.dart';

class TeamOverviewScreen extends ConsumerWidget {
  const TeamOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teams = ref.watch(teamListProvider);
    final sessions = ref.watch(sessionListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Inline Hockey Coach')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/teams/new'),
        icon: const Icon(Icons.add),
        label: const Text('Nuevo equipo'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              'Equipos',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            teams.when(
              data: (summaries) {
                if (summaries.isEmpty) {
                  return const _EmptyState();
                }
                return _TeamList(summaries: summaries);
              },
              loading: () => const _LoadingState(),
              error: (error, stackTrace) => _ErrorState(error: error),
            ),
            const SizedBox(height: 32),
            Text(
              'Partidos',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 48,
              child: FilledButton.icon(
                onPressed: () => context.go('/sessions/new'),
                icon: const Icon(Icons.sports_hockey),
                label: const Text('Configurar partido'),
              ),
            ),
            const SizedBox(height: 16),
            sessions.when(
              data: (sessionList) {
                if (sessionList.isEmpty) {
                  return const Text('No hay partidos todavía.');
                }
                return Column(
                  children: [
                    for (final s in sessionList) ...[
                      ListTile(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.outlineVariant,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        title: Text(s.tournamentName),
                        subtitle: Text('${s.scheduledDate} ${s.startTime} - Estado: ${s.status}'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => context.go('/sessions/${s.id}/live'),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ],
                );
              },
              loading: () => const _LoadingState(),
              error: (error, stackTrace) => _ErrorState(error: error),
            ),
          ],
        ),
      ),
    );
  }
}

class _TeamList extends StatelessWidget {
  const _TeamList({required this.summaries});

  final List<TeamRosterSummary> summaries;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final summary in summaries) ...[
          _TeamSummary(summary: summary),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _TeamSummary extends StatelessWidget {
  const _TeamSummary({required this.summary});

  final TeamRosterSummary summary;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    summary.team.name,
                    style: textTheme.titleLarge,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => context.go('/teams/${summary.team.id}/edit'),
                  tooltip: 'Editar equipo',
                ),
              ],
            ),
            if (summary.team.category != null) ...[
              Text(
                summary.team.category!,
                style: textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _MetricTile(
                  label: 'Jugadores',
                  value: summary.skaterCount.toString(),
                ),
                _MetricTile(
                  label: 'Arquero',
                  value: summary.goalkeeperCount.toString(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 120, minHeight: 72),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 4),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Text('No hay equipos todavía. Crea uno para iniciar.'),
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const SizedBox.square(
      dimension: 44,
      child: Padding(
        padding: EdgeInsets.all(6),
        child: CircularProgressIndicator(strokeWidth: 3),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    return Text('No se pudo abrir la base local: $error');
  }
}
