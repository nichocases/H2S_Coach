import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inline_hockey_coach/features/dashboards/application/dashboard_providers.dart';

class GoalkeeperMetricsView extends ConsumerStatefulWidget {
  const GoalkeeperMetricsView({super.key});

  @override
  ConsumerState<GoalkeeperMetricsView> createState() => _GoalkeeperMetricsViewState();
}

class _GoalkeeperMetricsViewState extends ConsumerState<GoalkeeperMetricsView> {
  int _sortColumnIndex = 4; // SV% by default
  bool _sortAscending = false;

  @override
  Widget build(BuildContext context) {
    final boardAsync = ref.watch(goalkeeperLeaderboardProvider);

    return boardAsync.when(
      data: (rows) {
        if (rows.isEmpty) {
          return const Center(child: Text('No hay datos de arqueros.'));
        }

        final sortedRows = List.of(rows);
        sortedRows.sort((a, b) {
          int cmp;
          switch (_sortColumnIndex) {
            case 0:
              cmp = a.jerseyNumber.compareTo(b.jerseyNumber);
            case 1:
              cmp = a.playerName.compareTo(b.playerName);
            case 2:
              cmp = a.shotsFaced.compareTo(b.shotsFaced);
            case 3:
              cmp = a.goalsAllowed.compareTo(b.goalsAllowed);
            case 4:
              cmp = a.savePercentage.compareTo(b.savePercentage);
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
                  label: const Text('Arquero'),
                  onSort: _onSort,
                ),
                DataColumn(
                  label: const Text('Tiros'),
                  tooltip: 'Tiros Recibidos',
                  numeric: true,
                  onSort: _onSort,
                ),
                DataColumn(
                  label: const Text('GC'),
                  tooltip: 'Goles en Contra',
                  numeric: true,
                  onSort: _onSort,
                ),
                DataColumn(
                  label: const Text('SV%'),
                  tooltip: 'Porcentaje de Salvadas',
                  numeric: true,
                  onSort: _onSort,
                ),
              ],
              rows: sortedRows.map((row) {
                return DataRow(
                  cells: [
                    DataCell(Text('${row.jerseyNumber}')),
                    DataCell(Text(row.playerName)),
                    DataCell(Text('${row.shotsFaced}')),
                    DataCell(Text('${row.goalsAllowed}')),
                    DataCell(
                      Text(
                        '${row.savePercentage.toStringAsFixed(1)}%',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
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
