import 'package:flutter_test/flutter_test.dart';
import 'package:inline_hockey_coach/data/local/drift/app_database.dart';

void main() {
  test('creates the local database schema from zero', () async {
    final db = AppDatabase.inMemory();
    addTearDown(db.close);

    final tables = await db
        .customSelect(
          "SELECT name FROM sqlite_master WHERE type = 'table'",
        )
        .get();
    final tableNames = tables.map((row) => row.data['name'] as String).toSet();

    expect(
      tableNames,
      containsAll({
        'coaches',
        'teams',
        'players',
        'tournament_sessions',
        'session_players',
        'match_actions',
        'shoot_details',
        'goalkeeper_actions',
        'sync_queue',
      }),
    );

    final indexes = await db
        .customSelect(
          "SELECT name FROM sqlite_master WHERE type = 'index'",
        )
        .get();
    final indexNames = indexes.map((row) => row.data['name'] as String).toSet();

    expect(indexNames, contains('uq_players_active_team_jersey'));
  });
}
