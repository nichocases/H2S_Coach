import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inline_hockey_coach/app/app.dart';
import 'package:inline_hockey_coach/app/router.dart';
import 'package:inline_hockey_coach/data/local/drift/app_database.dart';
import 'package:inline_hockey_coach/features/sync/application/sync_providers.dart';
import 'package:inline_hockey_coach/features/sync/application/sync_service.dart';
import 'package:inline_hockey_coach/features/teams/application/team_overview_providers.dart';

void main() {
  testWidgets('renders the seeded team overview route', (tester) async {
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

    expect(find.text('Inline Hockey Coach'), findsOneWidget);
    expect(find.text('Equipos y sesiones'), findsOneWidget);
    expect(find.text('Patines Capital Sub-12'), findsOneWidget);
    expect(find.text('Jugadores'), findsOneWidget);
    expect(find.text('Arquero'), findsOneWidget);
  });

  testWidgets('renders an empty team overview state', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          teamListProvider.overrideWith(
            (ref) async => const <TeamRosterSummary>[],
          ),
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

    expect(
      find.text('No hay equipos todavía. Crea uno para iniciar.'),
      findsOneWidget,
    );
    expect(find.text('Nuevo equipo'), findsWidgets);
  });

  testWidgets('creates a draft session and opens the live header', (
    tester,
  ) async {
    await _openLiveSession(tester, tournamentName: 'Copa Demo');

    expect(find.text('Partido en vivo'), findsOneWidget);
    expect(find.text('00:00'), findsOneWidget);
    expect(find.text('Iniciar'), findsOneWidget);
    expect(find.text('Reloj local listo'), findsOneWidget);
  });

  testWidgets('captures a player pass in two taps and voids it', (
    tester,
  ) async {
    await _openLiveSession(tester, tournamentName: 'Copa Pases');

    await tester.tap(find.text('Iniciar'));
    await tester.pumpAndSettle();

    await _tapVisible(tester, '#7 Sofia Ruiz');
    await tester.tap(find.text('Pase correcto'));
    await tester.pumpAndSettle();

    expect(find.text('Pase correcto'), findsOneWidget);

    await _tapVisible(tester, 'Anular última');
    await tester.pumpAndSettle();

    expect(find.textContaining('Anulado'), findsOneWidget);

    await _tapVisible(tester, 'Pausar');
    await tester.pumpAndSettle();
  });

  testWidgets('captures shot zones, shot result and goalkeeper action', (
    tester,
  ) async {
    await _openLiveSession(tester, tournamentName: 'Copa Tiros');

    await tester.tap(find.text('Iniciar'));
    await tester.pumpAndSettle();

    await _tapVisible(tester, '#7 Sofia Ruiz');
    await tester.tap(find.text('Tiro'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Superior izquierda'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Gol'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Guardar tiro'));
    await tester.pumpAndSettle();

    await _scrollToTop(tester);
    expect(find.text('Intentos 1'), findsOneWidget);
    expect(find.text('Al arco 1'), findsOneWidget);
    expect(find.text('Goles 1'), findsOneWidget);

    await _tapVisible(tester, '#1 Daniel Cano');
    await tester.tap(find.text('Z1'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Atajada'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Guardar acción'));
    await tester.pumpAndSettle();

    await _scrollToTop(tester);
    expect(find.text('Atajadas 1'), findsOneWidget);
    expect(find.text('Porcentaje 100%'), findsOneWidget);

    await _tapVisible(tester, 'Pausar');
    await _tapVisible(tester, 'Pausar');
    await tester.pumpAndSettle();
  });
}

Future<void> _openLiveSession(
  WidgetTester tester, {
  required String tournamentName,
}) async {
  await tester.binding.setSurfaceSize(const Size(900, 1200));
  addTearDown(() => tester.binding.setSurfaceSize(null));

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

  await tester.tap(find.text('Configurar partido'));
  await tester.pumpAndSettle();

  expect(find.text('Configuración del partido'), findsOneWidget);
  await tester.enterText(
    find.widgetWithText(TextFormField, 'Torneo'),
    tournamentName,
  );
  for (var attempt = 0; attempt < 4; attempt += 1) {
    if (find.text('Crear sesión').evaluate().isNotEmpty) {
      break;
    }
    await tester.drag(find.byType(ListView), const Offset(0, -300));
    await tester.pumpAndSettle();
  }
  expect(find.text('Crear sesión'), findsOneWidget);
  await tester.tap(find.text('Crear sesión'));
  await tester.pumpAndSettle();
}

Future<void> _tapVisible(WidgetTester tester, String label) async {
  final finder = find.text(label);
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> _scrollToTop(WidgetTester tester) async {
  final listFinder = find.byType(ListView).first;
  for (var attempt = 0; attempt < 4; attempt += 1) {
    await tester.drag(listFinder, const Offset(0, 500));
    await tester.pumpAndSettle();
  }
}
