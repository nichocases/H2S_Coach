import 'package:flutter_test/flutter_test.dart';
import 'package:inline_hockey_coach/data/local/drift/app_database.dart';
import 'package:inline_hockey_coach/data/repositories/coach_repository.dart';
import 'package:inline_hockey_coach/data/repositories/player_repository.dart';
import 'package:inline_hockey_coach/data/repositories/session_repository.dart';
import 'package:inline_hockey_coach/data/repositories/sync_queue_repository.dart';
import 'package:inline_hockey_coach/data/repositories/team_repository.dart';
import 'package:inline_hockey_coach/domain/entities/hockey_enums.dart';
import 'package:inline_hockey_coach/domain/entities/local_models.dart';

void main() {
  late AppDatabase db;
  late CoachRepository coaches;
  late TeamRepository teams;
  late PlayerRepository players;
  late TournamentSessionRepository sessions;
  late SyncQueueRepository syncQueue;

  setUp(() {
    db = AppDatabase.inMemory();
    syncQueue = SyncQueueRepository(db);
    coaches = CoachRepository(db, syncQueue: syncQueue);
    teams = TeamRepository(db, syncQueue: syncQueue);
    players = PlayerRepository(db, syncQueue: syncQueue);
    sessions = TournamentSessionRepository(db, syncQueue: syncQueue);
  });

  tearDown(() => db.close());

  test(
    'creates a draft session offline with selected players and sync payload',
    () async {
      final fixture = await _createRoster(
        coaches: coaches,
        teams: teams,
        players: players,
      );

      final session = await sessions.createDraft(
        TournamentSessionDraft(
          tournamentName: 'Copa Bogota',
          scheduledDate: DateTime.utc(2026, 9, 5),
          teamId: fixture.team.id,
          coachId: fixture.coach.id,
          activeGoalkeeperId: fixture.goalkeeper.id,
          deviceId: '10000000-0000-4000-8000-000000000201',
          players: [
            SessionPlayerDraft(
              playerId: fixture.skater.id,
              role: PlayerRole.skater,
            ),
            SessionPlayerDraft(
              playerId: fixture.goalkeeper.id,
              role: PlayerRole.goalkeeper,
            ),
          ],
        ),
      );

      expect(session.status, SessionStatus.draft.storageValue);
      expect(session.scheduledDate, '2026-09-05');
      expect(session.elapsedMs, 0);
      expect(await sessions.playersForSession(session.id), hasLength(2));
      expect(await syncQueue.pendingCount(), 5);
    },
  );

  test('rejects a draft without exactly one goalkeeper', () async {
    final fixture = await _createRoster(
      coaches: coaches,
      teams: teams,
      players: players,
    );

    await expectLater(
      sessions.createDraft(
        TournamentSessionDraft(
          tournamentName: 'Copa Bogota',
          scheduledDate: DateTime.utc(2026, 9, 5),
          teamId: fixture.team.id,
          coachId: fixture.coach.id,
          activeGoalkeeperId: fixture.goalkeeper.id,
          deviceId: '10000000-0000-4000-8000-000000000201',
          players: [
            SessionPlayerDraft(
              playerId: fixture.skater.id,
              role: PlayerRole.skater,
            ),
          ],
        ),
      ),
      throwsA(isA<SessionValidationException>()),
    );
  });

  test('rejects a player selected as skater and active goalkeeper', () async {
    final fixture = await _createRoster(
      coaches: coaches,
      teams: teams,
      players: players,
    );

    await expectLater(
      sessions.createDraft(
        TournamentSessionDraft(
          tournamentName: 'Copa Bogota',
          scheduledDate: DateTime.utc(2026, 9, 5),
          teamId: fixture.team.id,
          coachId: fixture.coach.id,
          activeGoalkeeperId: fixture.goalkeeper.id,
          deviceId: '10000000-0000-4000-8000-000000000201',
          players: [
            SessionPlayerDraft(
              playerId: fixture.goalkeeper.id,
              role: PlayerRole.skater,
            ),
            SessionPlayerDraft(
              playerId: fixture.goalkeeper.id,
              role: PlayerRole.goalkeeper,
            ),
          ],
        ),
      ),
      throwsA(isA<SessionValidationException>()),
    );
  });

  test('persists clock state locally and enqueues session upserts', () async {
    final fixture = await _createRoster(
      coaches: coaches,
      teams: teams,
      players: players,
    );
    final session = await sessions.createDraft(
      TournamentSessionDraft(
        tournamentName: 'Copa Bogota',
        scheduledDate: DateTime.utc(2026, 9, 5),
        teamId: fixture.team.id,
        coachId: fixture.coach.id,
        activeGoalkeeperId: fixture.goalkeeper.id,
        deviceId: '10000000-0000-4000-8000-000000000201',
        players: [
          SessionPlayerDraft(
            playerId: fixture.skater.id,
            role: PlayerRole.skater,
          ),
          SessionPlayerDraft(
            playerId: fixture.goalkeeper.id,
            role: PlayerRole.goalkeeper,
          ),
        ],
      ),
    );

    final started = await sessions.updateClockState(
      sessionId: session.id,
      status: SessionStatus.inProgress,
      elapsedMs: 1250,
    );
    final paused = await sessions.updateClockState(
      sessionId: session.id,
      status: SessionStatus.paused,
      elapsedMs: 2500,
    );

    expect(started.status, SessionStatus.inProgress.storageValue);
    expect(started.elapsedMs, 1250);
    expect(started.startedAt, isNotNull);
    expect(paused.status, SessionStatus.paused.storageValue);
    expect(paused.elapsedMs, 2500);
    expect(paused.startedAt, isNotNull);
    expect(await syncQueue.pendingCount(), 7);
  });

  test('finishes a session and sets finishedAt', () async {
    final fixture = await _createRoster(
      coaches: coaches,
      teams: teams,
      players: players,
    );
    final session = await sessions.createDraft(
      TournamentSessionDraft(
        tournamentName: 'Copa Bogota',
        scheduledDate: DateTime.utc(2026, 9, 5),
        teamId: fixture.team.id,
        coachId: fixture.coach.id,
        activeGoalkeeperId: fixture.goalkeeper.id,
        deviceId: '10000000-0000-4000-8000-000000000201',
        players: [
          SessionPlayerDraft(
            playerId: fixture.skater.id,
            role: PlayerRole.skater,
          ),
          SessionPlayerDraft(
            playerId: fixture.goalkeeper.id,
            role: PlayerRole.goalkeeper,
          ),
        ],
      ),
    );

    final started = await sessions.updateClockState(
      sessionId: session.id,
      status: SessionStatus.inProgress,
      elapsedMs: 1000,
    );

    final finished = await sessions.finishSession(started.id);

    expect(finished.status, SessionStatus.finished.storageValue);
    expect(finished.finishedAt, isNotNull);
    expect(await syncQueue.pendingCount(), 7); // create + update + finish
  });
}

Future<_RosterFixture> _createRoster({
  required CoachRepository coaches,
  required TeamRepository teams,
  required PlayerRepository players,
}) async {
  final coach = await coaches.create(const CoachDraft(displayName: 'Coach'));
  final team = await teams.create(const TeamDraft(name: 'Patines'));
  final skater = await players.create(
    PlayerDraft(
      teamId: team.id,
      displayName: 'Skater',
      jerseyNumber: 10,
      defaultRole: PlayerRole.skater,
    ),
  );
  final goalkeeper = await players.create(
    PlayerDraft(
      teamId: team.id,
      displayName: 'Goalkeeper',
      jerseyNumber: 1,
      defaultRole: PlayerRole.goalkeeper,
    ),
  );

  return _RosterFixture(
    coach: coach,
    team: team,
    skater: skater,
    goalkeeper: goalkeeper,
  );
}

class _RosterFixture {
  const _RosterFixture({
    required this.coach,
    required this.team,
    required this.skater,
    required this.goalkeeper,
  });

  final Coach coach;
  final Team team;
  final Player skater;
  final Player goalkeeper;
}
