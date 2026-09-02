import 'package:flutter_test/flutter_test.dart';
import 'package:inline_hockey_coach/data/local/drift/app_database.dart';
import 'package:inline_hockey_coach/data/repositories/coach_repository.dart';
import 'package:inline_hockey_coach/data/repositories/match_action_repository.dart';
import 'package:inline_hockey_coach/data/repositories/player_repository.dart';
import 'package:inline_hockey_coach/data/repositories/session_repository.dart';
import 'package:inline_hockey_coach/data/repositories/sync_queue_repository.dart';
import 'package:inline_hockey_coach/data/repositories/team_repository.dart';
import 'package:inline_hockey_coach/domain/entities/hockey_enums.dart';
import 'package:inline_hockey_coach/domain/entities/local_models.dart';

void main() {
  late AppDatabase db;
  late SyncQueueRepository syncQueue;
  late MatchActionRepository actions;
  late TournamentSessionRepository sessions;
  late CoachRepository coaches;
  late TeamRepository teams;
  late PlayerRepository players;

  setUp(() {
    db = AppDatabase.inMemory();
    syncQueue = SyncQueueRepository(db);
    coaches = CoachRepository(db, syncQueue: syncQueue);
    teams = TeamRepository(db, syncQueue: syncQueue);
    players = PlayerRepository(db, syncQueue: syncQueue);
    sessions = TournamentSessionRepository(db, syncQueue: syncQueue);
    actions = MatchActionRepository(db, syncQueue: syncQueue);
  });

  tearDown(() => db.close());

  test('inserts 5000 match actions and queues them correctly', () async {
    final coach = await coaches.create(const CoachDraft(displayName: 'Coach'));
    final team = await teams.create(const TeamDraft(name: 'Team Stress'));
    final skater = await players.create(PlayerDraft(teamId: team.id, displayName: 'S1', jerseyNumber: 10, defaultRole: PlayerRole.skater));
    final gk = await players.create(PlayerDraft(teamId: team.id, displayName: 'GK', jerseyNumber: 1, defaultRole: PlayerRole.goalkeeper));
    
    var session = await sessions.createDraft(
      TournamentSessionDraft(
        tournamentName: 'Stress Cup',
        scheduledDate: DateTime.now(),
        teamId: team.id,
        coachId: coach.id,
        activeGoalkeeperId: gk.id,
        deviceId: 'device-1',
        players: [
          SessionPlayerDraft(playerId: skater.id, role: PlayerRole.skater),
          SessionPlayerDraft(playerId: gk.id, role: PlayerRole.goalkeeper),
        ],
      ),
    );

    session = await sessions.updateClockState(sessionId: session.id, status: SessionStatus.inProgress, elapsedMs: 0);

    final queuedBefore = await syncQueue.pendingCount();

    // Insert 5000 events
    for (int i = 0; i < 5000; i++) {
      await actions.recordPlayerAction(
        MatchActionDraft(
          sessionId: session.id,
          playerId: skater.id,
          actionType: PlayerActionType.pass,
          chronometerMs: i,
          deviceId: 'device-1',
        ),
      );
    }

    final totalQueued = await syncQueue.pendingCount();
    expect(totalQueued, queuedBefore + 5000);

    // Fetch batch of 200
    final batch = await syncQueue.readyBatch(limit: 200);
    expect(batch.length, 200);
  });
}
