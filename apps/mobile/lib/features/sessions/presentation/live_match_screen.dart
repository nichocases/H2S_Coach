import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inline_hockey_coach/data/local/drift/app_database.dart';
import 'package:inline_hockey_coach/domain/entities/hockey_enums.dart';
import 'package:inline_hockey_coach/domain/entities/local_models.dart';
import 'package:inline_hockey_coach/domain/services/monotonic_chronometer.dart';
import 'package:inline_hockey_coach/features/sync/application/sync_providers.dart';
import 'package:inline_hockey_coach/features/sync/presentation/sync_status_panel.dart';
import 'package:inline_hockey_coach/features/teams/application/team_overview_providers.dart';

class LiveMatchScreen extends ConsumerStatefulWidget {
  const LiveMatchScreen({required this.sessionId, super.key});

  final String sessionId;

  @override
  ConsumerState<LiveMatchScreen> createState() => _LiveMatchScreenState();
}

class _LiveMatchScreenState extends ConsumerState<LiveMatchScreen> {
  MonotonicChronometer? _chronometer;
  Timer? _ticker;
  String? _loadedSessionId;
  int _elapsedMs = 0;
  SessionStatus _status = SessionStatus.draft;
  bool _savingClock = false;

  @override
  void dispose() {
    _ticker?.cancel();
    final chronometer = _chronometer;
    if (chronometer != null && chronometer.isRunning) {
      unawaited(
        ref
            .read(sessionRepositoryProvider)
            .updateClockState(
              sessionId: widget.sessionId,
              status: _status,
              elapsedMs: chronometer.chronometerMsForAction(),
            ),
      );
    }
    super.dispose();
  }

  Future<void> _startOrResume() async {
    final chronometer = _chronometer;
    if (chronometer == null || chronometer.isRunning) {
      return;
    }

    chronometer.start();
    _startTicker();
    setState(() {
      _status = SessionStatus.inProgress;
      _elapsedMs = chronometer.elapsedMs;
      _savingClock = true;
    });

    await _persistClock(SessionStatus.inProgress, _elapsedMs);
  }

  Future<void> _pause() async {
    final chronometer = _chronometer;
    if (chronometer == null || !chronometer.isRunning) {
      return;
    }

    final elapsedMs = chronometer.pause();
    _ticker?.cancel();
    setState(() {
      _status = SessionStatus.paused;
      _elapsedMs = elapsedMs;
      _savingClock = true;
    });

    await _persistClock(SessionStatus.paused, elapsedMs);
  }

  Future<void> _finish() async {
    final chronometer = _chronometer;
    final elapsedMs = chronometer?.elapsedMs ?? _elapsedMs;
    
    if (chronometer != null && chronometer.isRunning) {
      chronometer.pause();
      _ticker?.cancel();
    }

    setState(() {
      _status = SessionStatus.finished;
      _elapsedMs = elapsedMs;
      _savingClock = true;
    });

    await _persistClock(SessionStatus.finished, elapsedMs);
  }

  Future<void> _persistClock(SessionStatus status, int elapsedMs) async {
    try {
      await ref
          .read(sessionRepositoryProvider)
          .updateClockState(
            sessionId: widget.sessionId,
            status: status,
            elapsedMs: elapsedMs,
          );
      ref.invalidate(sessionProvider(widget.sessionId));
    } finally {
      if (mounted) {
        setState(() => _savingClock = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionProvider(widget.sessionId));
    final roster = ref.watch(sessionRosterProvider(widget.sessionId));
    final recentEvents = ref.watch(recentMatchEventsProvider(widget.sessionId));
    final shotMetrics = ref.watch(shotMetricsProvider(widget.sessionId));
    final goalkeeperMetrics = ref.watch(
      goalkeeperMetricsProvider(widget.sessionId),
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/teams'),
        ),
        title: const Text('Partido en vivo'),
      ),
      body: SafeArea(
        child: session.when(
          data: (row) {
            if (row == null) {
              return const Center(child: Text('Sesión no encontrada.'));
            }
            _restoreFrom(row);
            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              children: [
                _LiveMatchHeader(
                  elapsedMs: _elapsedMs,
                  onPause: _pause,
                  onStartOrResume: _startOrResume,
                  onFinish: _finish,
                  savingClock: _savingClock,
                  session: row,
                  status: _status,
                ),
                const SizedBox(height: 16),
                const SyncStatusPanel(),
                const SizedBox(height: 16),
                _CaptureSummary(
                  goalkeeperMetrics: goalkeeperMetrics,
                  shotMetrics: shotMetrics,
                ),
                const SizedBox(height: 16),
                _CaptureRoster(
                  roster: roster,
                  onGoalkeeperTap: (goalkeeper) =>
                      _openGoalkeeperSheet(row, goalkeeper),
                  onPlayerTap: (player) => _openPlayerActions(row, player),
                ),
                const SizedBox(height: 16),
                _RecentActionList(
                  events: recentEvents,
                  onVoidLatest: _voidLatestEvent,
                ),
              ],
            );
          },
          error: (error, _) => Center(child: Text('No se pudo cargar: $error')),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }

  Future<void> _openPlayerActions(
    TournamentSession session,
    Player player,
  ) async {

    final action = await showModalBottomSheet<PlayerActionType>(
      context: context,
      showDragHandle: true,
      builder: (_) => _PlayerActionSheet(player: player),
    );
    if (!mounted || action == null) {
      return;
    }

    if (action == PlayerActionType.shoot) {
      await _openShotSelector(session, player);
      return;
    }

    await _savePlayerAction(
      session: session,
      player: player,
      actionType: action,
    );
  }

  Future<void> _openShotSelector(
    TournamentSession session,
    Player player,
  ) async {
    final selection = await showModalBottomSheet<_ShotSelection>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => const _ShotSelectionSheet(),
    );
    if (!mounted || selection == null) {
      return;
    }

    await _savePlayerAction(
      session: session,
      player: player,
      actionType: PlayerActionType.shoot,
      shotResult: selection.result,
      targetZone: selection.zone,
    );
  }

  Future<void> _savePlayerAction({
    required TournamentSession session,
    required Player player,
    required PlayerActionType actionType,
    ShotResult? shotResult,
    GoalTargetZone? targetZone,
  }) async {
    try {
      await ref
          .read(matchActionRepositoryProvider)
          .recordPlayerAction(
            MatchActionDraft(
              sessionId: session.id,
              playerId: player.id,
              actionType: actionType,
              chronometerMs: _captureChronometerMs,
              deviceId: session.deviceId,
              shotResult: shotResult,
              targetZone: targetZone,
            ),
          );
      _refreshCaptureProviders();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Acción guardada localmente.')),
        );
      }
    } on Object catch (error) {
      _showCaptureError(error);
    }
  }

  Future<void> _openGoalkeeperSheet(
    TournamentSession session,
    Player goalkeeper,
  ) async {

    final selection = await showModalBottomSheet<_GoalkeeperSelection>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => const _GoalkeeperActionSheet(),
    );
    if (!mounted || selection == null) {
      return;
    }

    try {
      await ref
          .read(matchActionRepositoryProvider)
          .recordGoalkeeperAction(
            GoalkeeperActionDraft(
              sessionId: session.id,
              goalkeeperId: goalkeeper.id,
              shotOriginZone: selection.zone,
              result: selection.result,
              chronometerMs: _captureChronometerMs,
              deviceId: session.deviceId,
            ),
          );
      _refreshCaptureProviders();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Acción de arquero guardada.')),
        );
      }
    } on Object catch (error) {
      _showCaptureError(error);
    }
  }

  Future<void> _openGoalkeeperSwapSheet(TournamentSession session, Player activeGoalkeeper) async {
    final newGoalkeeperId = await showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        return _GoalkeeperSwapSheet(
          teamId: session.teamId,
          activeGoalkeeperId: activeGoalkeeper.id,
        );
      },
    );
    if (newGoalkeeperId == null) {
      return;
    }
    
    try {
      await ref.read(sessionRepositoryProvider).swapGoalkeeper(
        sessionId: session.id,
        newGoalkeeperId: newGoalkeeperId,
      );
      ref.invalidate(sessionRosterProvider(widget.sessionId));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Arquero sustituido exitosamente.')),
        );
      }
    } on Object catch(error) {
      _showCaptureError(error);
    }
  }

  Future<void> _voidLatestEvent() async {
    try {
      final event = await ref
          .read(matchActionRepositoryProvider)
          .voidLatestEvent(
            sessionId: widget.sessionId,
            reason: 'Corrección del entrenador',
          );
      _refreshCaptureProviders();
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            event == null ? 'No hay eventos por anular.' : 'Evento anulado.',
          ),
        ),
      );
    } on Object catch (error) {
      _showCaptureError(error);
    }
  }

  int get _captureChronometerMs {
    final chronometer = _chronometer;
    if (chronometer == null) {
      return _elapsedMs;
    }
    return chronometer.chronometerMsForAction();
  }

  void _refreshCaptureProviders() {
    ref
      ..invalidate(recentMatchEventsProvider(widget.sessionId))
      ..invalidate(shotMetricsProvider(widget.sessionId))
      ..invalidate(goalkeeperMetricsProvider(widget.sessionId))
      ..invalidate(syncSummaryProvider);
  }

  void _showCaptureError(Object error) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('No se pudo guardar: $error')),
    );
  }

  void _restoreFrom(TournamentSession session) {
    if (_loadedSessionId == session.id) {
      return;
    }

    final restoredStatus = SessionStatus.fromStorage(session.status);
    _loadedSessionId = session.id;
    _status = restoredStatus;
    _elapsedMs = session.elapsedMs;
    _chronometer = MonotonicChronometer(
      timeSource: StopwatchMonotonicTimeSource(),
      initialElapsedMs: session.elapsedMs,
      initiallyRunning: restoredStatus == SessionStatus.inProgress,
    );

    if (restoredStatus == SessionStatus.inProgress) {
      _startTicker();
    }
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(milliseconds: 250), (_) {
      final chronometer = _chronometer;
      if (!mounted || chronometer == null || !chronometer.isRunning) {
        return;
      }
      setState(() => _elapsedMs = chronometer.elapsedMs);
    });
  }
}

class _LiveMatchHeader extends StatelessWidget {
  const _LiveMatchHeader({
    required this.elapsedMs,
    required this.onPause,
    required this.onStartOrResume,
    required this.onFinish,
    required this.savingClock,
    required this.session,
    required this.status,
  });

  final int elapsedMs;
  final Future<void> Function() onPause;
  final Future<void> Function() onStartOrResume;
  final Future<void> Function() onFinish;
  final bool savingClock;
  final TournamentSession session;
  final SessionStatus status;

  @override
  Widget build(BuildContext context) {
    final isRunning = status == SessionStatus.inProgress;
    final timeLabel = formatChronometerMs(elapsedMs);
    final statusLabel = switch (status) {
      SessionStatus.draft => 'Listo',
      SessionStatus.inProgress => 'En juego',
      SessionStatus.paused => 'Pausado',
      SessionStatus.finished => 'Finalizado',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          session.tournamentName,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text('Estado: $statusLabel'),
        const SizedBox(height: 24),
        Semantics(
          label: 'Reloj del partido $timeLabel. Estado $statusLabel.',
          liveRegion: true,
          child: ExcludeSemantics(
            child: Text(
              timeLabel,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (status != SessionStatus.finished)
          Row(
            children: [
              if (!isRunning) ...[
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: FilledButton.icon(
                      onPressed: savingClock ? null : onStartOrResume,
                      icon: const Icon(Icons.play_arrow),
                      label: Text(
                        status == SessionStatus.paused ? 'Reanudar' : 'Iniciar',
                      ),
                    ),
                  ),
                ),
                if (status == SessionStatus.paused) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                        ),
                        onPressed: savingClock ? null : onFinish,
                        icon: const Icon(Icons.stop),
                        label: const Text('Finalizar'),
                      ),
                    ),
                  ),
                ]
              ] else ...[
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed: savingClock ? null : onPause,
                      icon: const Icon(Icons.pause),
                      label: const Text('Pausar'),
                    ),
                  ),
                ),
              ],
            ],
          ),
        const SizedBox(height: 12),
        Text(
          savingClock ? 'Guardando reloj localmente' : 'Reloj local listo',
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _CaptureSummary extends StatelessWidget {
  const _CaptureSummary({
    required this.goalkeeperMetrics,
    required this.shotMetrics,
  });

  final AsyncValue<GoalkeeperMetrics> goalkeeperMetrics;
  final AsyncValue<ShotMetrics> shotMetrics;

  @override
  Widget build(BuildContext context) {
    final shots = shotMetrics.maybeWhen(
      data: (value) => value,
      orElse: () => null,
    );
    final goalkeeper = goalkeeperMetrics.maybeWhen(
      data: (value) => value,
      orElse: () => null,
    );
    final savePercentage = goalkeeper?.savePercentage;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Resumen', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _MetricPill(label: 'Intentos', value: '${shots?.attempts ?? 0}'),
            _MetricPill(
              label: 'Al arco',
              value: '${shots?.shotsOnTarget ?? 0}',
            ),
            _MetricPill(label: 'Goles', value: '${shots?.goals ?? 0}'),
            _MetricPill(
              label: 'Atajadas',
              value: '${goalkeeper?.saves ?? 0}',
            ),
            _MetricPill(
              label: 'Goles recibidos',
              value: '${goalkeeper?.goalsAllowed ?? 0}',
            ),
            _MetricPill(
              label: 'Porcentaje',
              value: savePercentage == null
                  ? '--'
                  : '${(savePercentage * 100).round()}%',
            ),
          ],
        ),
        if (shotMetrics.isLoading || goalkeeperMetrics.isLoading) ...[
          const SizedBox(height: 8),
          const LinearProgressIndicator(),
        ],
        if (shotMetrics.hasError || goalkeeperMetrics.hasError) ...[
          const SizedBox(height: 8),
          const Text('No se pudieron cargar las métricas.'),
        ],
      ],
    );
  }
}

class _MetricPill extends StatelessWidget {
  const _MetricPill({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      constraints: const BoxConstraints(minHeight: 44),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: colors.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text('$label $value'),
    );
  }
}

class _CaptureRoster extends StatelessWidget {
  const _CaptureRoster({
    required this.onGoalkeeperTap,
    required this.onGoalkeeperSwapTap,
    required this.onPlayerTap,
    required this.roster,
  });

  final void Function(Player goalkeeper) onGoalkeeperTap;
  final void Function(Player goalkeeper)? onGoalkeeperSwapTap;
  final void Function(Player player) onPlayerTap;
  final AsyncValue<SessionRoster?> roster;

  @override
  Widget build(BuildContext context) {
    return roster.when(
      data: (value) {
        if (value == null) {
          return const Text('Sesión no encontrada.');
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Jugadores', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (value.skaters.isEmpty)
                  const Text('No hay jugadores activos.')
                else
                  for (final skater in value.skaters)
                    SizedBox(
                      height: 48,
                      child: FilledButton.tonal(
                        onPressed: () => onPlayerTap(skater),
                        child: Text(
                          skater.rosterLabel,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
              ],
            ),
            const SizedBox(height: 16),
            Text('Arquero', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            if (value.goalkeeper == null)
              const Text('No hay arquero activo.')
            else
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: FilledButton.icon(
                        onPressed: () => onGoalkeeperTap(value.goalkeeper!),
                        icon: const Icon(Icons.sports_hockey),
                        label: Text(
                          value.goalkeeper!.rosterLabel,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                  if (onGoalkeeperSwapTap != null) ...[
                    const SizedBox(width: 8),
                    IconButton.filledTonal(
                      onPressed: () => onGoalkeeperSwapTap!(value.goalkeeper!),
                      icon: const Icon(Icons.swap_horiz),
                      tooltip: 'Sustituir arquero',
                    ),
                  ],
                ],
              ),
          ],
        );
      },
      error: (error, _) => Text('No se pudo cargar el roster: $error'),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

class _RecentActionList extends StatelessWidget {
  const _RecentActionList({
    required this.events,
    required this.onVoidLatest,
  });

  final AsyncValue<List<RecentMatchEvent>> events;
  final Future<void> Function() onVoidLatest;

  @override
  Widget build(BuildContext context) {
    final loadedEvents = events.maybeWhen(
      data: (value) => value,
      orElse: () => const <RecentMatchEvent>[],
    );
    final canVoid = loadedEvents.any((event) => !event.isVoided);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Historial reciente',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            SizedBox(
              height: 44,
              child: OutlinedButton.icon(
                onPressed: canVoid ? onVoidLatest : null,
                icon: const Icon(Icons.undo),
                label: const Text('Anular última'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        events.when(
          data: (value) {
            if (value.isEmpty) {
              return const Text('Sin acciones registradas.');
            }
            return Column(
              children: [
                for (final event in value) _RecentEventTile(event: event),
              ],
            );
          },
          error: (error, _) => Text('No se pudo cargar el historial: $error'),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ],
    );
  }
}

class _RecentEventTile extends StatelessWidget {
  const _RecentEventTile({required this.event});

  final RecentMatchEvent event;

  @override
  Widget build(BuildContext context) {
    final detail = [
      if (event.detailLabel.isNotEmpty) event.detailLabel,
      formatChronometerMs(event.chronometerMs),
      if (event.isVoided) 'Anulado',
    ].join(' · ');

    return ListTile(
      contentPadding: EdgeInsets.zero,
      minVerticalPadding: 8,
      title: Text(event.primaryLabel),
      subtitle: Text(detail),
    );
  }
}

class _PlayerActionSheet extends StatelessWidget {
  const _PlayerActionSheet({required this.player});

  final Player player;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Acción de ${player.rosterLabel}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _SheetActionButton(
              icon: Icons.swap_horiz,
              label: 'Pase correcto',
              onPressed: () => Navigator.of(context).pop(PlayerActionType.pass),
            ),
            _SheetActionButton(
              icon: Icons.close,
              label: 'Pase fallido',
              onPressed: () =>
                  Navigator.of(context).pop(PlayerActionType.failPass),
            ),
            _SheetActionButton(
              icon: Icons.add_circle_outline,
              label: 'Asistencia',
              onPressed: () =>
                  Navigator.of(context).pop(PlayerActionType.assist),
            ),
            _SheetActionButton(
              icon: Icons.adjust,
              label: 'Tiro',
              onPressed: () =>
                  Navigator.of(context).pop(PlayerActionType.shoot),
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetActionButton extends StatelessWidget {
  const _SheetActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: SizedBox(
        height: 48,
        child: FilledButton.icon(
          onPressed: onPressed,
          icon: Icon(icon),
          label: Text(label),
        ),
      ),
    );
  }
}

class _ShotSelectionSheet extends StatefulWidget {
  const _ShotSelectionSheet();

  @override
  State<_ShotSelectionSheet> createState() => _ShotSelectionSheetState();
}

class _ShotSelectionSheetState extends State<_ShotSelectionSheet> {
  GoalTargetZone? _zone;
  ShotResult? _result;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Tiro', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            _GoalTargetGrid(
              selected: _zone,
              onSelected: (zone) => setState(() => _zone = zone),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final result in ShotResult.values)
                  _ChoiceButton(
                    label: result.label,
                    selected: _result == result,
                    onPressed: () => setState(() => _result = result),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 48,
              child: FilledButton.icon(
                onPressed: _zone == null || _result == null
                    ? null
                    : () => Navigator.of(context).pop(
                        _ShotSelection(zone: _zone!, result: _result!),
                      ),
                icon: const Icon(Icons.save),
                label: const Text('Guardar tiro'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoalTargetGrid extends StatelessWidget {
  const _GoalTargetGrid({
    required this.onSelected,
    required this.selected,
  });

  final void Function(GoalTargetZone zone) onSelected;
  final GoalTargetZone? selected;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      childAspectRatio: 1.8,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        for (final zone in GoalTargetZone.values)
          _ChoiceButton(
            label: zone.label,
            selected: selected == zone,
            onPressed: () => onSelected(zone),
          ),
      ],
    );
  }
}

class _GoalkeeperActionSheet extends StatefulWidget {
  const _GoalkeeperActionSheet();

  @override
  State<_GoalkeeperActionSheet> createState() => _GoalkeeperActionSheetState();
}

class _GoalkeeperActionSheetState extends State<_GoalkeeperActionSheet> {
  ShotOriginZone? _zone;
  GoalkeeperActionResult? _result;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Arquero', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 2.5,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                for (final zone in ShotOriginZone.values)
                  _ChoiceButton(
                    label: zone.label,
                    selected: _zone == zone,
                    onPressed: () => setState(() => _zone = zone),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final result in GoalkeeperActionResult.values)
                  _ChoiceButton(
                    label: result.label,
                    selected: _result == result,
                    onPressed: () => setState(() => _result = result),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 48,
              child: FilledButton.icon(
                onPressed: _zone == null || _result == null
                    ? null
                    : () => Navigator.of(context).pop(
                        _GoalkeeperSelection(
                          zone: _zone!,
                          result: _result!,
                        ),
                      ),
                icon: const Icon(Icons.save),
                label: const Text('Guardar acción'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChoiceButton extends StatelessWidget {
  const _ChoiceButton({
    required this.label,
    required this.onPressed,
    required this.selected,
  });

  final String label;
  final VoidCallback onPressed;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SizedBox(
      height: 48,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: selected ? colors.primaryContainer : null,
          foregroundColor: selected ? colors.onPrimaryContainer : null,
        ),
        child: Text(label, textAlign: TextAlign.center),
      ),
    );
  }
}

class _ShotSelection {
  const _ShotSelection({required this.zone, required this.result});

  final GoalTargetZone zone;
  final ShotResult result;
}

class _GoalkeeperSelection {
  const _GoalkeeperSelection({required this.zone, required this.result});

  final ShotOriginZone zone;
  final GoalkeeperActionResult result;
}

extension _PlayerLabel on Player {
  String get rosterLabel => '#$jerseyNumber $displayName';
}

extension _ShotResultLabel on ShotResult {
  String get label {
    return switch (this) {
      ShotResult.goal => 'Gol',
      ShotResult.missed => 'Desviado',
      ShotResult.hitKeeper => 'Al arquero',
      ShotResult.blocked => 'Bloqueado',
    };
  }
}

extension _GoalTargetZoneLabel on GoalTargetZone {
  String get label {
    return switch (this) {
      GoalTargetZone.topLeft => 'Superior izquierda',
      GoalTargetZone.topMiddle => 'Superior centro',
      GoalTargetZone.topRight => 'Superior derecha',
      GoalTargetZone.bottomLeft => 'Inferior izquierda',
      GoalTargetZone.bottomMiddle => 'Inferior centro',
      GoalTargetZone.bottomRight => 'Inferior derecha',
    };
  }
}

extension _GoalkeeperActionResultLabel on GoalkeeperActionResult {
  String get label {
    return switch (this) {
      GoalkeeperActionResult.save => 'Atajada',
      GoalkeeperActionResult.goalAllowed => 'Gol recibido',
    };
  }
}

extension _ShotOriginZoneLabel on ShotOriginZone {
  String get label {
    return switch (this) {
      ShotOriginZone.zone1 => 'Z1',
      ShotOriginZone.zone2 => 'Z2',
      ShotOriginZone.zone3 => 'Z3',
      ShotOriginZone.zone4 => 'Z4',
    };
  }
}

class _GoalkeeperSwapSheet extends ConsumerStatefulWidget {
  const _GoalkeeperSwapSheet({
    required this.teamId,
    required this.activeGoalkeeperId,
  });

  final String teamId;
  final String activeGoalkeeperId;

  @override
  ConsumerState<_GoalkeeperSwapSheet> createState() => _GoalkeeperSwapSheetState();
}

class _GoalkeeperSwapSheetState extends ConsumerState<_GoalkeeperSwapSheet> {
  List<Player>? _goalkeepers;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final allPlayers = await ref.read(playerRepositoryProvider).listForTeam(widget.teamId);
      final gks = allPlayers.where((p) => p.defaultRole == PlayerRole.goalkeeper.storageValue && p.active && p.id != widget.activeGoalkeeperId).toList();
      if (mounted) {
        setState(() => _goalkeepers = gks);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _error = e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Sustituir Arquero',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 16),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text('Error: $_error', style: const TextStyle(color: Colors.red)),
              )
            else if (_goalkeepers == null)
              const Center(child: CircularProgressIndicator())
            else if (_goalkeepers!.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('No hay otros arqueros en el equipo.'),
              )
            else
              for (final gk in _goalkeepers!)
                ListTile(
                  leading: const Icon(Icons.sports_hockey),
                  title: Text(gk.rosterLabel),
                  onTap: () => Navigator.pop(context, gk.id),
                ),
          ],
        ),
      ),
    );
  }
}
