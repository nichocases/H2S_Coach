import 'package:inline_hockey_coach/domain/entities/hockey_enums.dart';

class CoachDraft {
  const CoachDraft({required this.displayName});

  final String displayName;
}

class TeamDraft {
  const TeamDraft({required this.name, this.category});

  final String name;
  final String? category;
}

class PlayerDraft {
  const PlayerDraft({
    required this.teamId,
    required this.displayName,
    required this.jerseyNumber,
    required this.defaultRole,
    this.active = true,
  });

  final String teamId;
  final String displayName;
  final int jerseyNumber;
  final PlayerRole defaultRole;
  final bool active;
}

class SessionPlayerDraft {
  const SessionPlayerDraft({required this.playerId, required this.role});

  final String playerId;
  final PlayerRole role;
}

class TournamentSessionDraft {
  const TournamentSessionDraft({
    required this.tournamentName,
    required this.scheduledDate,
    required this.teamId,
    required this.coachId,
    required this.activeGoalkeeperId,
    required this.deviceId,
    required this.players,
    this.startTime,
  });

  final String tournamentName;
  final DateTime scheduledDate;
  final String? startTime;
  final String teamId;
  final String coachId;
  final String activeGoalkeeperId;
  final String deviceId;
  final List<SessionPlayerDraft> players;
}

class DemoRosterSummary {
  const DemoRosterSummary({
    required this.teamName,
    required this.skaterCount,
    required this.goalkeeperCount,
  });

  final String teamName;
  final int skaterCount;
  final int goalkeeperCount;
}

class MatchActionDraft {
  const MatchActionDraft({
    required this.sessionId,
    required this.playerId,
    required this.actionType,
    required this.chronometerMs,
    required this.deviceId,
    this.shotResult,
    this.targetZone,
    this.keeperSide = KeeperSide.unknown,
  });

  final String sessionId;
  final String playerId;
  final PlayerActionType actionType;
  final int chronometerMs;
  final String deviceId;
  final ShotResult? shotResult;
  final GoalTargetZone? targetZone;
  final KeeperSide keeperSide;
}

class GoalkeeperActionDraft {
  const GoalkeeperActionDraft({
    required this.sessionId,
    required this.goalkeeperId,
    required this.shotOriginZone,
    required this.result,
    required this.chronometerMs,
    required this.deviceId,
  });

  final String sessionId;
  final String goalkeeperId;
  final ShotOriginZone shotOriginZone;
  final GoalkeeperActionResult result;
  final int chronometerMs;
  final String deviceId;
}

class ShotMetrics {
  const ShotMetrics({
    required this.attempts,
    required this.shotsOnTarget,
    required this.goals,
  });

  final int attempts;
  final int shotsOnTarget;
  final int goals;
}

class GoalkeeperMetrics {
  const GoalkeeperMetrics({
    required this.shotsFaced,
    required this.saves,
    required this.goalsAllowed,
  });

  final int shotsFaced;
  final int saves;
  final int goalsAllowed;

  double? get savePercentage {
    if (shotsFaced == 0) {
      return null;
    }
    return saves / shotsFaced;
  }
}

enum RecentEventKind { playerAction, goalkeeperAction }

class RecentMatchEvent {
  const RecentMatchEvent({
    required this.id,
    required this.kind,
    required this.primaryLabel,
    required this.detailLabel,
    required this.chronometerMs,
    required this.createdAt,
    this.voidedAt,
    this.voidReason,
  });

  final String id;
  final RecentEventKind kind;
  final String primaryLabel;
  final String detailLabel;
  final int chronometerMs;
  final DateTime createdAt;
  final DateTime? voidedAt;
  final String? voidReason;

  bool get isVoided => voidedAt != null;
}

class PlayerSummary {
  const PlayerSummary({
    required this.playerId,
    required this.displayName,
    required this.jerseyNumber,
    required this.passes,
    required this.failPasses,
    required this.assists,
    required this.attempts,
    required this.shotsOnTarget,
    required this.goals,
  });

  final String playerId;
  final String displayName;
  final int jerseyNumber;
  final int passes;
  final int failPasses;
  final int assists;
  final int attempts;
  final int shotsOnTarget;
  final int goals;
}

class GoalkeeperSummary {
  const GoalkeeperSummary({
    required this.goalkeeperId,
    required this.displayName,
    required this.jerseyNumber,
    required this.saves,
    required this.goalsAllowed,
    required this.shotsFaced,
  });

  final String goalkeeperId;
  final String displayName;
  final int jerseyNumber;
  final int saves;
  final int goalsAllowed;
  final int shotsFaced;

  double? get savePercentage {
    if (shotsFaced == 0) return null;
    return saves / shotsFaced;
  }
}

class MatchSummary {
  const MatchSummary({
    required this.sessionId,
    required this.teamPasses,
    required this.teamFailPasses,
    required this.teamAssists,
    required this.teamAttempts,
    required this.teamShotsOnTarget,
    required this.teamGoals,
    required this.playerSummaries,
    required this.goalkeeperSummary,
    required this.shotDistribution,
  });

  final String sessionId;
  final int teamPasses;
  final int teamFailPasses;
  final int teamAssists;
  final int teamAttempts;
  final int teamShotsOnTarget;
  final int teamGoals;

  final List<PlayerSummary> playerSummaries;
  final GoalkeeperSummary? goalkeeperSummary;
  final Map<GoalTargetZone, int> shotDistribution;
}
