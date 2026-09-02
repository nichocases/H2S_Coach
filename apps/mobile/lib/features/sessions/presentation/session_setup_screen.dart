import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inline_hockey_coach/data/local/drift/app_database.dart';
import 'package:inline_hockey_coach/data/repositories/session_repository.dart';
import 'package:inline_hockey_coach/domain/entities/hockey_enums.dart';
import 'package:inline_hockey_coach/domain/entities/local_models.dart';
import 'package:inline_hockey_coach/features/teams/application/team_overview_providers.dart';
import 'package:uuid/uuid.dart';

class SessionSetupScreen extends ConsumerStatefulWidget {
  const SessionSetupScreen({super.key});

  @override
  ConsumerState<SessionSetupScreen> createState() => _SessionSetupScreenState();
}

class _SessionSetupScreenState extends ConsumerState<SessionSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tournament = TextEditingController();
  final _date = TextEditingController(text: _formatDate(DateTime.now()));
  final _startTime = TextEditingController();
  final _selectedSkaterIds = <String>{};

  String? _selectedTeamId;
  String? _selectedCoachId;
  String? _selectedGoalkeeperId;
  bool _saving = false;

  @override
  void dispose() {
    _tournament.dispose();
    _date.dispose();
    _startTime.dispose();
    super.dispose();
  }

  Future<void> _createSession({
    required String teamId,
    required String coachId,
    required List<Player> players,
  }) async {
    final messenger = ScaffoldMessenger.of(context);
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final scheduledDate = _parseDate(_date.text);
    final selectedGoalkeeperId = _selectedGoalkeeperId;
    final selectedPlayers = players
        .where((player) => _selectedSkaterIds.contains(player.id))
        .map(
          (player) => SessionPlayerDraft(
            playerId: player.id,
            role: PlayerRole.skater,
          ),
        )
        .toList();

    if (selectedGoalkeeperId != null) {
      selectedPlayers.add(
        SessionPlayerDraft(
          playerId: selectedGoalkeeperId,
          role: PlayerRole.goalkeeper,
        ),
      );
    }

    setState(() => _saving = true);
    try {
      final session = await ref
          .read(sessionRepositoryProvider)
          .createDraft(
            TournamentSessionDraft(
              tournamentName: _tournament.text.trim(),
              scheduledDate: scheduledDate,
              startTime: _formatTime(_startTime.text),
              teamId: teamId,
              coachId: coachId,
              activeGoalkeeperId: selectedGoalkeeperId ?? '',
              deviceId: const Uuid().v4(),
              players: selectedPlayers,
            ),
          );

      ref.invalidate(sessionProvider(session.id));

      if (!mounted) {
        return;
      }
      context.go('/sessions/${session.id}/live');
    } on SessionValidationException catch (error, stack) {
      print('=== ERROR SAVING SESSION ===');
      print(error);
      print(stack);
      messenger.showSnackBar(SnackBar(content: Text(error.message)));
    } on FormatException catch (error, stack) {
      print('=== ERROR SAVING SESSION ===');
      print(error);
      print(stack);
      messenger.showSnackBar(SnackBar(content: Text(error.message)));
    } on Exception catch (error, stack) {
      print('=== ERROR SAVING SESSION ===');
      print(error);
      print(stack);
      messenger.showSnackBar(
        SnackBar(content: Text('No se pudo crear la sesión: $error')),
      );
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final teams = ref.watch(teamListProvider);
    final coaches = ref.watch(coachListProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        title: const Text('Configuración del partido'),
      ),
      body: SafeArea(
        child: teams.when(
          data: (teamSummaries) => coaches.when(
            data: (coachRows) {
              if (teamSummaries.isEmpty || coachRows.isEmpty) {
                return _EmptySetupState(
                  onCreateTeam: () => context.go('/teams/new'),
                );
              }
              final selectedTeamId = _effectiveTeamId(teamSummaries);
              final selectedCoachId = _effectiveCoachId(coachRows);
              final players = ref.watch(playersForTeamProvider(selectedTeamId));

              return players.when(
                data: (playerRows) => _buildForm(
                  teamSummaries: teamSummaries,
                  coaches: coachRows,
                  players: playerRows,
                  selectedTeamId: selectedTeamId,
                  selectedCoachId: selectedCoachId,
                ),
                error: (error, _) => _LoadError(message: error.toString()),
                loading: () => const Center(child: CircularProgressIndicator()),
              );
            },
            error: (error, _) => _LoadError(message: error.toString()),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
          error: (error, _) => _LoadError(message: error.toString()),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }

  Widget _buildForm({
    required List<TeamRosterSummary> teamSummaries,
    required List<Coach> coaches,
    required List<Player> players,
    required String selectedTeamId,
    required String selectedCoachId,
  }) {
    final skaters = players
        .where((player) => player.defaultRole == PlayerRole.skater.storageValue)
        .toList(growable: false);
    final goalkeepers = players
        .where(
          (player) => player.defaultRole == PlayerRole.goalkeeper.storageValue,
        )
        .toList(growable: false);
    _normalizePlayerSelections(skaters: skaters, goalkeepers: goalkeepers);

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          TextFormField(
            controller: _tournament,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(labelText: 'Torneo'),
            validator: _required,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _date,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              helperText: 'YYYY-MM-DD',
              labelText: 'Fecha',
            ),
            validator: _dateValidator,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _startTime,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              helperText: 'Opcional, HH:MM',
              labelText: 'Hora',
            ),
            validator: _timeValidator,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: selectedTeamId,
            decoration: const InputDecoration(labelText: 'Equipo'),
            items: [
              for (final summary in teamSummaries)
                DropdownMenuItem(
                  value: summary.team.id,
                  child: Text(summary.team.name),
                ),
            ],
            onChanged: _saving
                ? null
                : (value) {
                    if (value == null) {
                      return;
                    }
                    setState(() {
                      _selectedTeamId = value;
                      _selectedSkaterIds.clear();
                      _selectedGoalkeeperId = null;
                    });
                  },
            validator: _required,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: selectedCoachId,
            decoration: const InputDecoration(labelText: 'Coach'),
            items: [
              for (final coach in coaches)
                DropdownMenuItem(
                  value: coach.id,
                  child: Text(coach.displayName),
                ),
            ],
            onChanged: _saving
                ? null
                : (value) => setState(() => _selectedCoachId = value),
            validator: _required,
          ),
          const SizedBox(height: 24),
          Text('Jugadores', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          if (skaters.isEmpty)
            const Text('Agrega al menos un jugador de campo.')
          else
            for (final skater in skaters)
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                title: Text('#${skater.jerseyNumber} ${skater.displayName}'),
                value: _selectedSkaterIds.contains(skater.id),
                onChanged: _saving
                    ? null
                    : (checked) {
                        setState(() {
                          if (checked ?? false) {
                            _selectedSkaterIds.add(skater.id);
                          } else {
                            _selectedSkaterIds.remove(skater.id);
                          }
                        });
                      },
              ),
          const SizedBox(height: 16),
          Text('Arquero', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          if (goalkeepers.isEmpty)
            const Text('Agrega exactamente un arquero.')
          else
            for (final goalkeeper in goalkeepers)
              _GoalkeeperOption(
                label: '#${goalkeeper.jerseyNumber} ${goalkeeper.displayName}',
                selected: _selectedGoalkeeperId == goalkeeper.id,
                onTap: _saving
                    ? null
                    : () => setState(
                        () => _selectedGoalkeeperId = goalkeeper.id,
                      ),
              ),
          const SizedBox(height: 24),
          SizedBox(
            height: 48,
            child: FilledButton.icon(
              onPressed: _saving
                  ? null
                  : () => _createSession(
                      teamId: selectedTeamId,
                      coachId: selectedCoachId,
                      players: players,
                    ),
              icon: const Icon(Icons.sports_hockey),
              label: Text(_saving ? 'Creando' : 'Crear sesión'),
            ),
          ),
        ],
      ),
    );
  }

  String _effectiveTeamId(List<TeamRosterSummary> teams) {
    final selected = _selectedTeamId;
    if (selected != null &&
        teams.any((summary) => summary.team.id == selected)) {
      return selected;
    }
    _selectedTeamId = teams.first.team.id;
    return _selectedTeamId!;
  }

  String _effectiveCoachId(List<Coach> coaches) {
    final selected = _selectedCoachId;
    if (selected != null && coaches.any((coach) => coach.id == selected)) {
      return selected;
    }
    _selectedCoachId = coaches.first.id;
    return _selectedCoachId!;
  }

  void _normalizePlayerSelections({
    required List<Player> skaters,
    required List<Player> goalkeepers,
  }) {
    final skaterIds = skaters.map((player) => player.id).toSet();
    _selectedSkaterIds.removeWhere((id) => !skaterIds.contains(id));
    if (_selectedSkaterIds.isEmpty && skaterIds.isNotEmpty) {
      _selectedSkaterIds.addAll(skaterIds);
    }

    final goalkeeperIds = goalkeepers.map((player) => player.id).toSet();
    if (!goalkeeperIds.contains(_selectedGoalkeeperId)) {
      _selectedGoalkeeperId = goalkeepers.isEmpty ? null : goalkeepers.first.id;
    }
  }
}

class _EmptySetupState extends StatelessWidget {
  const _EmptySetupState({required this.onCreateTeam});

  final VoidCallback onCreateTeam;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.groups_outlined, size: 48),
            const SizedBox(height: 16),
            Text(
              'Crea un equipo y un coach antes de configurar partido.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onCreateTeam,
              icon: const Icon(Icons.add),
              label: const Text('Nuevo equipo'),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoalkeeperOption extends StatelessWidget {
  const _GoalkeeperOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(
          selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
        ),
        minLeadingWidth: 44,
        onTap: onTap,
        title: Text(label),
      ),
    );
  }
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text('No se pudo cargar: $message'),
      ),
    );
  }
}

String? _required(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Requerido';
  }
  return null;
}

String? _dateValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Requerido';
  }
  try {
    _parseDate(value);
    return null;
  } on FormatException catch (error) {
    return error.message;
  }
}

String? _timeValidator(String? value) {
  final trimmed = value?.trim() ?? '';
  if (trimmed.isEmpty) {
    return null;
  }
  final parts = trimmed.split(':');
  if (parts.length != 2) {
    return 'HH:MM';
  }
  final hour = int.tryParse(parts[0]);
  final minute = int.tryParse(parts[1]);
  if (hour == null || minute == null || hour > 23 || minute > 59) {
    return 'HH:MM';
  }
  return null;
}

DateTime _parseDate(String value) {
  final parts = value.trim().split('-');
  if (parts.length != 3) {
    throw const FormatException('YYYY-MM-DD');
  }
  final year = int.tryParse(parts[0]);
  final month = int.tryParse(parts[1]);
  final day = int.tryParse(parts[2]);
  if (year == null || month == null || day == null) {
    throw const FormatException('YYYY-MM-DD');
  }
  final parsed = DateTime.utc(year, month, day);
  if (parsed.year != year || parsed.month != month || parsed.day != day) {
    throw const FormatException('YYYY-MM-DD');
  }
  return parsed;
}

String _formatDate(DateTime value) {
  final utc = value.toUtc();
  final month = utc.month.toString().padLeft(2, '0');
  final day = utc.day.toString().padLeft(2, '0');
  return '${utc.year}-$month-$day';
}

String? _formatTime(String? value) {
  final trimmed = value?.trim();
  if (trimmed == null || trimmed.isEmpty) return null;
  final parts = trimmed.split(':');
  if (parts.length != 2) return trimmed;
  final hh = parts[0].padLeft(2, '0');
  final mm = parts[1].padLeft(2, '0');
  return '$hh:$mm';
}

String? _blankToNull(String value) {
  final trimmed = value.trim();
  return trimmed.isEmpty ? null : trimmed;
}
