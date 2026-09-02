import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inline_hockey_coach/app/app.dart';
import 'package:inline_hockey_coach/data/local/drift/app_database.dart';
import 'package:inline_hockey_coach/features/sync/application/sync_providers.dart';
import 'package:inline_hockey_coach/features/sync/application/sync_service.dart';
import 'package:inline_hockey_coach/features/teams/application/team_overview_providers.dart';

void main() {
  Future<void> pumpApp(WidgetTester tester) async {
    final db = AppDatabase.inMemory();
    addTearDown(db.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          syncSummaryProvider.overrideWith(
            (ref) async => const SyncSummary(
              failedCount: 0,
              pendingCount: 0,
              status: SyncDisplayStatus.synced,
              syncingCount: 0,
            ),
          ),
        ],
        child: const InlineHockeyCoachApp(enableSyncBootstrap: false),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('Layout tests without overflow', () {
    testWidgets('renders correctly on small device (320x480)', (tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 480));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      
      await pumpApp(tester);
      expect(find.byType(Scaffold), findsWidgets);
      // Tap 'Nuevo equipo' to see create team screen
      await tester.tap(find.text('Nuevo equipo').first);
      await tester.pumpAndSettle();
      expect(find.text('Nuevo equipo'), findsWidgets);
    });

    testWidgets('renders correctly on horizontal tablet (1024x768)', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1024, 768));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      
      await pumpApp(tester);
      expect(find.byType(Scaffold), findsWidgets);
      await tester.tap(find.text('Nuevo equipo').first);
      await tester.pumpAndSettle();
      expect(find.text('Nuevo equipo'), findsWidgets);
    });
  });
}
