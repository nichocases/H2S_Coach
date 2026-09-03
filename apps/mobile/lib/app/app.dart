import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inline_hockey_coach/app/router.dart';
import 'package:inline_hockey_coach/app/theme.dart';
import 'package:inline_hockey_coach/features/sync/application/sync_bootstrap.dart';

class InlineHockeyCoachApp extends ConsumerWidget {
  const InlineHockeyCoachApp({this.enableSyncBootstrap = true, super.key});

  final bool enableSyncBootstrap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Inline Hockey Coach',
      routerConfig: router,
      builder: (context, child) {
        final routedChild = child ?? const SizedBox.shrink();
        if (!enableSyncBootstrap) {
          return routedChild;
        }
        return SyncBootstrap(child: routedChild);
      },
      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
    );
  }
}
