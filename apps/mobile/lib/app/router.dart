import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inline_hockey_coach/app/app_shell.dart';
import 'package:inline_hockey_coach/core/providers/auth_provider.dart';
import 'package:inline_hockey_coach/features/auth/presentation/login_screen.dart';
import 'package:inline_hockey_coach/features/auth/presentation/register_screen.dart';
import 'package:inline_hockey_coach/features/auth/presentation/admin_users_screen.dart';

import 'package:inline_hockey_coach/features/dashboards/presentation/dashboard_screen.dart';
import 'package:inline_hockey_coach/features/sessions/presentation/live_match_screen.dart';
import 'package:inline_hockey_coach/features/sessions/presentation/session_setup_screen.dart';
import 'package:inline_hockey_coach/features/summary/presentation/summary_screen.dart';
import 'package:inline_hockey_coach/features/teams/presentation/create_team_screen.dart';
import 'package:inline_hockey_coach/features/teams/presentation/edit_team_screen.dart';
import 'package:inline_hockey_coach/features/teams/presentation/team_overview_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorTeamsKey = GlobalKey<NavigatorState>(debugLabel: 'teams');
final _shellNavigatorDashboardsKey = GlobalKey<NavigatorState>(debugLabel: 'dashboards');

final routerProvider = Provider<GoRouter>((ref) {
  final isCoach = ref.watch(isCoachOrAdminProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/dashboards', // Public users see dashboards by default
    redirect: (context, state) {
      // Protect coach routes
      final protectedRoutes = [
        '/teams',
        '/teams/new',
        '/sessions/new',
      ];
      
      final isProtected = protectedRoutes.any((route) => state.uri.path.startsWith(route));
      if (isProtected && !isCoach) {
        return '/dashboards';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _shellNavigatorTeamsKey,
            routes: [
              GoRoute(
                path: '/teams',
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
      GoRoute(
        path: '/admin/users',
        name: 'admin-users',
        parentNavigatorKey: _rootNavigatorKey,
        redirect: (context, state) {
          // If not super_admin, don't let them in
          final roleAsync = ref.read(userRoleProvider);
          if (roleAsync.value != 'super_admin') return '/dashboards';
          return null;
        },
        builder: (context, state) => const AdminUsersScreen(),
      ),
    ],
  );
});
