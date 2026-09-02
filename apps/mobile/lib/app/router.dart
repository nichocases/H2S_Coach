import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inline_hockey_coach/app/app_shell.dart';
import 'package:inline_hockey_coach/features/dashboards/presentation/dashboard_screen.dart';
import 'package:inline_hockey_coach/features/sessions/presentation/live_match_screen.dart';
import 'package:inline_hockey_coach/features/sessions/presentation/session_setup_screen.dart';
import 'package:inline_hockey_coach/features/summary/presentation/summary_screen.dart';
import 'package:inline_hockey_coach/features/teams/presentation/create_team_screen.dart';
import 'package:inline_hockey_coach/features/teams/presentation/edit_team_screen.dart';
import 'package:inline_hockey_coach/features/teams/presentation/team_overview_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorTeamsKey = GlobalKey<NavigatorState>(debugLabel: 'teams');
final _shellNavigatorDashboardsKey = GlobalKey<NavigatorState>(debugLabel: 'dashboards');

GoRouter createRouter() => GoRouter(
  navigatorKey: _rootNavigatorKey,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AppShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _shellNavigatorTeamsKey,
          routes: [
            GoRoute(
              path: '/',
              name: 'teams',
              builder: (context, state) => const TeamOverviewScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorDashboardsKey,
          routes: [
            GoRoute(
              path: '/dashboards',
              name: 'dashboards',
              builder: (context, state) => const DashboardScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/teams/new',
      name: 'team-create',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const CreateTeamScreen(),
    ),
    GoRoute(
      path: '/teams/:teamId/edit',
      name: 'team-edit',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => EditTeamScreen(teamId: state.pathParameters['teamId']!),
    ),
    GoRoute(
      path: '/sessions/new',
      name: 'session-create',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SessionSetupScreen(),
    ),
    GoRoute(
      path: '/sessions/:sessionId/live',
      name: 'session-live',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        return LiveMatchScreen(sessionId: state.pathParameters['sessionId']!);
      },
    ),
    GoRoute(
      path: '/sessions/:sessionId/summary',
      name: 'session-summary',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        return MatchSummaryScreen(
          sessionId: state.pathParameters['sessionId']!,
        );
      },
    ),
  ],
);
