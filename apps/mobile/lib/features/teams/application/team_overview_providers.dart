import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inline_hockey_coach/data/local/demo_seed.dart';
import 'package:inline_hockey_coach/data/local/drift/app_database.dart';
import 'package:inline_hockey_coach/data/repositories/coach_repository.dart';
import 'package:inline_hockey_coach/data/repositories/match_action_repository.dart';
import 'package:inline_hockey_coach/data/repositories/player_repository.dart';
import 'package:inline_hockey_coach/data/repositories/session_repository.dart';
import 'package:inline_hockey_coach/data/repositories/sync_queue_repository.dart';
import 'package:inline_hockey_coach/data/repositories/team_repository.dart';
import 'package:inline_hockey_coach/domain/entities/hockey_enums.dart';
import 'package:inline_hockey_coach/domain/entities/local_models.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase.openDefault();
  ref.onDispose(database.close);
  return database;
});

final syncQueueRepositoryProvider = Provider<SyncQueueRepository>((ref) {
  return SyncQueueRepository(ref.watch(databaseProvider));
});

final coachRepositoryProvider = Provider<CoachRepository>((ref) {
  return CoachRepository(
    ref.watch(databaseProvider),
    syncQueue: ref.watch(syncQueueRepositoryProvider),
  );
});

final teamRepositoryProvider = Provider<TeamRepository>((ref) {
  return TeamRepository(
    ref.watch(databaseProvider),
    syncQueue: ref.watch(syncQueueRepositoryProvider),
  );
});

final playerRepositoryProvider = Provider<PlayerRepository>((ref) {
  return PlayerRepository(
    ref.watch(databaseProvider),
    syncQueue: ref.watch(syncQueueRepositoryProvider),
  );
});

final sessionRepositoryProvider = Provider<TournamentSessionRepository>((ref) {
  return TournamentSessionRepository(
    ref.watch(databaseProvider),
    syncQueue: ref.watch(syncQueueRepositoryProvider),
  );
});

final matchActionRepositoryProvider = Provider<MatchActionRepository>((ref) {
  return MatchActionRepository(
    ref.watch(databaseProvider),
    syncQueue: ref.watch(syncQueueRepositoryProvider),
  );
});

final demoRosterSummaryProvider = FutureProvider<DemoRosterSummary>((
  ref,
) async {
  final database = ref.watch(databaseProvider);
  await ensureDemoSeed(database);
  return loadDemoRosterSummary(database);
});

final teamListProvider = FutureProvider<List<TeamRosterSummary>>((ref) async {
  final database = ref.watch(databaseProvider);
  await ensureDemoSeed(database);

  final teams = await ref.watch(teamRepositoryProvider).list();
  final playerRepository = ref.watch(playerRepositoryProvider);
  final summaries = <TeamRosterSummary>[];
  for (final team in teams) {
    final players = await playerRepository.listForTeam(team.id);
    final activePlayers = players.where((player) => player.active);
    summaries.add(
      TeamRosterSummary(
        team: team,
        skaterCount: activePlayers
            .where(
              (player) => player.defaultRole == PlayerRole.skater.storageValue,
            )
            .length,
        goalkeeperCount: activePlayers
            .where(
              (player) =>
                  player.defaultRole == PlayerRole.goalkeeper.storageValue,
            )
            .length,
      ),
    );
  }
  return summaries;
});

final coachListProvider = FutureProvider<List<Coach>>((ref) async {
  await ensureDemoSeed(ref.watch(databaseProvider));
  return ref.watch(coachRepositoryProvider).list();
});

// Riverpod keeps the public family-builder type internal to this import, so the
// variable stays inferred to preserve the callable provider API.
// ignore: specify_nonobvious_property_types
final playersForTeamProvider = FutureProvider.family<List<Player>, String>((
  ref,
  teamId,
) async {
  await ensureDemoSeed(ref.watch(databaseProvider));
  final players = await ref.watch(playerRepositoryProvider).listForTeam(teamId);
  return players.where((player) => player.active).toList(growable: false);
});

// Riverpod keeps the public family-builder type internal to this import, so the
// variable stays inferred to preserve the callable provider API.
// ignore: specify_nonobvious_property_types
final sessionListProvider = FutureProvider<List<TournamentSession>>((ref) {
  return ref.watch(sessionRepositoryProvider).allSessions();
});

final sessionProvider = FutureProvider.family<TournamentSession?, String>((
  ref,
  sessionId,
) {
  return ref.watch(sessionRepositoryProvider).find(sessionId);
});

// Riverpod keeps the public family-builder type internal to this import, so the
// variable stays inferred to preserve the callable provider API.
// ignore: specify_nonobvious_property_types
final sessionRosterProvider = FutureProvider.family<SessionRoster?, String>((
  ref,
  sessionId,
) async {
  final database = ref.watch(databaseProvider);
  await ensureDemoSeed(database);

  final sessionRepository = ref.watch(sessionRepositoryProvider);
  final session = await sessionRepository.find(sessionId);
  if (session == null) {
    return null;
  }

  final selections = await sessionRepository.playersForSession(sessionId);
  final selectedRoles = {
    for (final selection in selections) selection.playerId: selection.role,
  };
  final players = await ref
      .watch(playerRepositoryProvider)
      .listForTeam(
        session.teamId,
      );
  final activePlayers = players.where((player) => player.active);
  final skaters = activePlayers
      .where(
        (player) => selectedRoles[player.id] == PlayerRole.skater.storageValue,
      )
      .toList(growable: false);
  Player? goalkeeper;
  for (final player in activePlayers) {
    if (player.id == session.activeGoalkeeperId &&
        selectedRoles[player.id] == PlayerRole.goalkeeper.storageValue) {
      goalkeeper = player;
      break;
    }
  }

  return SessionRoster(skaters: skaters, goalkeeper: goalkeeper);
});

// Riverpod keeps the public family-builder type internal to this import, so the
// variable stays inferred to preserve the callable provider API.
// ignore: specify_nonobvious_property_types
final recentMatchEventsProvider =
    FutureProvider.family<List<RecentMatchEvent>, String>((ref, sessionId) {
      return ref.watch(matchActionRepositoryProvider).recentEvents(sessionId);
    });

// Riverpod keeps the public family-builder type internal to this import, so the
// variable stays inferred to preserve the callable provider API.
// ignore: specify_nonobvious_property_types
final shotMetricsProvider = FutureProvider.family<ShotMetrics, String>((
  ref,
  sessionId,
) {
  return ref.watch(matchActionRepositoryProvider).shotMetrics(sessionId);
});

// Riverpod keeps the public family-builder type internal to this import, so the
// variable stays inferred to preserve the callable provider API.
// ignore: specify_nonobvious_property_types
final goalkeeperMetricsProvider =
    FutureProvider.family<GoalkeeperMetrics, String>((ref, sessionId) {
      return ref
          .watch(matchActionRepositoryProvider)
          .goalkeeperMetrics(
            sessionId,
          );
    });

class TeamRosterSummary {
  const TeamRosterSummary({
    required this.team,
    required this.skaterCount,
    required this.goalkeeperCount,
  });

  final Team team;
  final int skaterCount;
  final int goalkeeperCount;
}

class SessionRoster {
  const SessionRoster({required this.skaters, required this.goalkeeper});

  final List<Player> skaters;
  final Player? goalkeeper;

  bool get isEmpty => skaters.isEmpty && goalkeeper == null;
}
