import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inline_hockey_coach/features/dashboards/application/dashboard_providers.dart';

class PlayerLeaderboardView extends ConsumerStatefulWidget {
  const PlayerLeaderboardView({super.key});

  @override
  ConsumerState<PlayerLeaderboardView> createState() => _PlayerLeaderboardViewState();
}

class _PlayerLeaderboardViewState extends ConsumerState<PlayerLeaderboardView> {
  int _sortColumnIndex = 4; // Points by default
  bool _sortAscending = false;

  @override
  Widget build(BuildContext context) {
    final boardAsync = ref.watch(playerLeaderboardProvider);

    return boardAsync.when(
      data: (rows) {
        if (rows.isEmpty) {
          return const Center(child: Text('No hay datos de jugadores.'));
        }

        // Sort locally
        final sortedRows = List.of(rows);
        sortedRows.sort((a, b) {
          int cmp;
          switch (_sortColumnIndex) {
            case 0:
              cmp = a.jerseyNumber.compareTo(b.jerseyNumber);
            case 1:
              cmp = a.playerName.compareTo(b.playerName);
            case 2:
              cmp = a.goals.compareTo(b.goals);
            case 3:
              cmp = a.assists.compareTo(b.assists);
            case 4:
              cmp = a.points.compareTo(b.points);
            case 5:
              cmp = a.shootingPercentage.compareTo(b.shootingPercentage);
            default:
              cmp = 0;
          }
          return _sortAscending ? cmp : -cmp;
        });

        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              sortColumnIndex: _sortColumnIndex,
              sortAscending: _sortAscending,
              columns: [
                DataColumn(
                  label: const Text('#'),
                  numeric: true,
                  onSort: _onSort,
                ),
                DataColumn(
                  label: const Text('Jugador'),
                  onSort: _onSort,
                ),
                DataColumn(
                  label: const Text('G'),
                  tooltip: 'Goles',
                  numeric: true,
                  onSort: _onSort,
                ),
                DataColumn(
                  label: const Text('A'),
                  tooltip: 'Asistencias',
                  numeric: true,
                  onSort: _onSort,
                ),
                DataColumn(
                  label: const Text('PTS'),
                  tooltip: 'Puntos',
                  numeric: true,
                  onSort: _onSort,
                ),
                DataColumn(
                  label: const Text('% Tiro'),
                  tooltip: 'Efectividad de Tiro',
                  numeric: true,
                  onSort: _onSort,
                ),
              ],
              rows: sortedRows.map((row) {
                return DataRow(
                  cells: [
                    DataCell(Text('${row.jerseyNumber}')),
                    DataCell(Text(row.playerName)),
                    DataCell(Text('${row.goals}')),
                    DataCell(Text('${row.assists}')),
                    DataCell(
                      Text(
                        '${row.points}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataCell(Text('${row.shootingPercentage.toStringAsFixed(1)}%')),
                  ],
                );
              }).toList(),
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  void _onSort(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }
}
