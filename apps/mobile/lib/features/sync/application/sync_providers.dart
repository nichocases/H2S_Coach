import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inline_hockey_coach/features/sync/application/sync_service.dart';
import 'package:inline_hockey_coach/features/teams/application/team_overview_providers.dart';

final connectivityGatewayProvider = Provider<ConnectivityGateway>((ref) {
  return ConnectivityPlusGateway();
});

final syncApiClientProvider = Provider<SyncApiClient>((ref) {
  final client = HttpSyncApiClient(
    baseUri: Uri.parse(
      const String.fromEnvironment(
        'SYNC_API_BASE_URL',
        defaultValue: 'http://127.0.0.1:8000',
      ),
    ),
  );
  ref.onDispose(client.close);
  return client;
});

final syncServiceProvider = Provider<SyncService>((ref) {
  return SyncService(
    api: ref.watch(syncApiClientProvider),
    queue: ref.watch(syncQueueRepositoryProvider),
  );
});

final syncControllerProvider = Provider<SyncController>((ref) {
  final controller = SyncController(
    connectivity: ref.watch(connectivityGatewayProvider),
    service: ref.watch(syncServiceProvider),
  );
  ref.onDispose(controller.dispose);
  return controller;
});

final syncSummaryProvider = FutureProvider<SyncSummary>((ref) {
  return ref.watch(syncControllerProvider).currentSummary();
});
