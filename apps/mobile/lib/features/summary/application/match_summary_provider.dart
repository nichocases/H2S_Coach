import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inline_hockey_coach/data/repositories/match_summary_repository.dart';
import 'package:inline_hockey_coach/domain/entities/local_models.dart';
import 'package:inline_hockey_coach/features/teams/application/team_overview_providers.dart';

final matchSummaryRepositoryProvider = Provider<MatchSummaryRepository>((ref) {
  return MatchSummaryRepository(ref.watch(databaseProvider));
});

// Riverpod keeps the public family-builder type internal to this import, so the
// variable stays inferred to preserve the callable provider API.
// ignore: specify_nonobvious_property_types
final matchSummaryProvider = FutureProvider.family<MatchSummary, String>((
  ref,
  sessionId,
) {
  return ref.watch(matchSummaryRepositoryProvider).getMatchSummary(sessionId);
});
