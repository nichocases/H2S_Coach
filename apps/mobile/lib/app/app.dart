import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inline_hockey_coach/app/router.dart';
import 'package:inline_hockey_coach/app/theme.dart';
import 'package:inline_hockey_coach/features/sync/application/sync_bootstrap.dart';

class InlineHockeyCoachApp extends StatefulWidget {
  const InlineHockeyCoachApp({this.enableSyncBootstrap = true, super.key});

  final bool enableSyncBootstrap;

  @override
  State<InlineHockeyCoachApp> createState() => _InlineHockeyCoachAppState();
}

class _InlineHockeyCoachAppState extends State<InlineHockeyCoachApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = createRouter();
  }

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Inline Hockey Coach',
      routerConfig: _router,
      builder: (context, child) {
        final routedChild = child ?? const SizedBox.shrink();
        if (!widget.enableSyncBootstrap) {
          return routedChild;
        }
        return SyncBootstrap(child: routedChild);
      },
      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
    );
  }
}
