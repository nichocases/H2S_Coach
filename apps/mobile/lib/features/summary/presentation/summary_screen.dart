import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inline_hockey_coach/domain/entities/hockey_enums.dart';
import 'package:inline_hockey_coach/domain/entities/local_models.dart';
import 'package:inline_hockey_coach/features/summary/application/match_summary_provider.dart';
import 'package:inline_hockey_coach/features/teams/application/team_overview_providers.dart';

class MatchSummaryScreen extends ConsumerWidget {
  const MatchSummaryScreen({required this.sessionId, super.key});

  final String sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(matchSummaryProvider(sessionId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumen del Partido'),
      ),
      body: summaryAsync.when(
        data: (summary) => _SummaryView(summary: summary),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final repo = ref.read(sessionRepositoryProvider);
          await repo.finishSession(sessionId);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Sesión finalizada')),
            );
            context.go('/teams');
          }
        },
        label: const Text('Finalizar Partido'),
        icon: const Icon(Icons.done_all),
      ),
    );
  }
}

class _SummaryView extends StatelessWidget {
  const _SummaryView({required this.summary});

  final MatchSummary summary;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _TeamSummaryCard(summary: summary),
        const SizedBox(height: 16),
        _PlayersSummaryCard(players: summary.playerSummaries),
        const SizedBox(height: 16),
        if (summary.goalkeeperSummary != null)
          _GoalkeeperSummaryCard(goalkeeper: summary.goalkeeperSummary!),
        const SizedBox(height: 16),
        _ShotDistributionCard(distribution: summary.shotDistribution),
        const SizedBox(height: 64),
      ],
    );
  }
}

class _TeamSummaryCard extends StatelessWidget {
  const _TeamSummaryCard({required this.summary});

  final MatchSummary summary;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Totales del Equipo',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text('Goles: ${summary.teamGoals}'),
            Text('Tiros al arco: ${summary.teamShotsOnTarget}'),
            Text('Intentos: ${summary.teamAttempts}'),
            Text('Asistencias: ${summary.teamAssists}'),
            Text('Pases correctos: ${summary.teamPasses}'),
            Text('Pases fallidos: ${summary.teamFailPasses}'),
          ],
        ),
      ),
    );
  }
}

class _PlayersSummaryCard extends StatelessWidget {
  const _PlayersSummaryCard({required this.players});

  final List<PlayerSummary> players;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Jugadores', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Dorsal')),
                  DataColumn(label: Text('Nombre')),
                  DataColumn(label: Text('Goles')),
                  DataColumn(label: Text('Tiros al Arco')),
                  DataColumn(label: Text('Intentos')),
                  DataColumn(label: Text('Asistencias')),
                  DataColumn(label: Text('Pases')),
                  DataColumn(label: Text('Pases Fall.')),
                ],
                rows: players.map((p) {
                  return DataRow(
                    cells: [
                      DataCell(Text(p.jerseyNumber.toString())),
                      DataCell(Text(p.displayName)),
                      DataCell(Text(p.goals.toString())),
                      DataCell(Text(p.shotsOnTarget.toString())),
                      DataCell(Text(p.attempts.toString())),
                      DataCell(Text(p.assists.toString())),
                      DataCell(Text(p.passes.toString())),
                      DataCell(Text(p.failPasses.toString())),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoalkeeperSummaryCard extends StatelessWidget {
  const _GoalkeeperSummaryCard({required this.goalkeeper});

  final GoalkeeperSummary goalkeeper;

  @override
  Widget build(BuildContext context) {
    final savePct = goalkeeper.savePercentage;
    final savePctString = savePct == null
        ? '—'
        : '${(savePct * 100).toStringAsFixed(1)}%';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Arquero', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Nombre: ${goalkeeper.displayName} (${goalkeeper.jerseyNumber})',
            ),
            Text('Atajadas: ${goalkeeper.saves}'),
            Text('Goles recibidos: ${goalkeeper.goalsAllowed}'),
            Text('Disparos enfrentados: ${goalkeeper.shotsFaced}'),
            Text('Porcentaje de atajadas: $savePctString'),
          ],
        ),
      ),
    );
  }
}

class _ShotDistributionCard extends StatelessWidget {
  const _ShotDistributionCard({required this.distribution});

  final Map<GoalTargetZone, int> distribution;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Distribución de Tiros (Zonas)',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            for (final entry in distribution.entries)
              Text('${_zoneLabel(entry.key)}: ${entry.value}'),
          ],
        ),
      ),
    );
  }

  String _zoneLabel(GoalTargetZone zone) {
    switch (zone) {
      case GoalTargetZone.topLeft:
        return 'Arriba Izquierda';
      case GoalTargetZone.topMiddle:
        return 'Arriba Centro';
      case GoalTargetZone.topRight:
        return 'Arriba Derecha';
      case GoalTargetZone.bottomLeft:
        return 'Abajo Izquierda';
      case GoalTargetZone.bottomMiddle:
        return 'Abajo Centro';
      case GoalTargetZone.bottomRight:
        return 'Abajo Derecha';
    }
  }
}
