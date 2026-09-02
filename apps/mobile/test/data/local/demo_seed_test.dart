import 'package:flutter_test/flutter_test.dart';
import 'package:inline_hockey_coach/data/local/demo_seed.dart';
import 'package:inline_hockey_coach/data/local/drift/app_database.dart';

void main() {
  test(
    'seeds one demo team, five skaters and one goalkeeper idempotently',
    () async {
      final db = AppDatabase.inMemory();
      addTearDown(db.close);

      await ensureDemoSeed(db);
      await ensureDemoSeed(db);

      final summary = await loadDemoRosterSummary(db);
      final players = await db.select(db.players).get();

      expect(summary.teamName, 'Patines Capital Sub-12');
      expect(summary.skaterCount, 5);
      expect(summary.goalkeeperCount, 1);
      expect(players, hasLength(6));
    },
  );
}
