import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inline_hockey_coach/app/app.dart';
import 'package:inline_hockey_coach/data/local/drift/app_database.dart';
import 'package:inline_hockey_coach/features/teams/application/team_overview_providers.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('app starts at the team overview route', (tester) async {
    final db = AppDatabase.inMemory();
    addTearDown(db.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const InlineHockeyCoachApp(enableSyncBootstrap: false),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Equipos y sesiones'), findsOneWidget);
    expect(find.text('Patines Capital Sub-12'), findsOneWidget);
  });
}
