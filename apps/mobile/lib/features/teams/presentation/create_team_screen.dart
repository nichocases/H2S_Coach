import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inline_hockey_coach/domain/entities/hockey_enums.dart';
import 'package:inline_hockey_coach/domain/entities/local_models.dart';
import 'package:inline_hockey_coach/features/teams/application/team_overview_providers.dart';

class CreateTeamScreen extends ConsumerStatefulWidget {
  const CreateTeamScreen({super.key});

  @override
  ConsumerState<CreateTeamScreen> createState() => _CreateTeamScreenState();
}

class _CreateTeamScreenState extends ConsumerState<CreateTeamScreen> {
  final _formKey = GlobalKey<FormState>();
  final _teamName = TextEditingController();
  final _category = TextEditingController();
  final _coachName = TextEditingController(text: 'Coach');
  final _players = <_PlayerInput>[
    _PlayerInput(role: PlayerRole.skater, jersey: '7'),
    _PlayerInput(role: PlayerRole.skater, jersey: '12'),
    _PlayerInput(role: PlayerRole.goalkeeper, jersey: '1'),
  ];

  bool _saving = false;

  @override
  void dispose() {
    _teamName.dispose();
    _category.dispose();
    _coachName.dispose();
    for (final player in _players) {
      player.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    final messenger = ScaffoldMessenger.of(context);
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final jerseys = <int>{};
    for (final player in _players) {
      final jersey = int.parse(player.jersey.text);
      if (!jerseys.add(jersey)) {
        messenger.showSnackBar(
          const SnackBar(content: Text('Los dorsales no se pueden repetir.')),
        );
        return;
      }
    }

    setState(() => _saving = true);
    try {
      final coach = await ref
          .read(coachRepositoryProvider)
          .create(
            CoachDraft(displayName: _coachName.text.trim()),
          );
      final team = await ref
          .read(teamRepositoryProvider)
          .create(
            TeamDraft(
              name: _teamName.text.trim(),
              category: _blankToNull(_category.text),
            ),
          );

      for (final player in _players) {
        await ref
            .read(playerRepositoryProvider)
            .create(
              PlayerDraft(
                teamId: team.id,
                displayName: player.name.text.trim(),
                jerseyNumber: int.parse(player.jersey.text),
                defaultRole: player.role,
              ),
            );
      }

      ref
        ..invalidate(teamListProvider)
        ..invalidate(coachListProvider);

      if (!mounted) {
        return;
      }
      messenger.showSnackBar(
        SnackBar(
          content: Text('${team.name} quedó listo con ${coach.displayName}.'),
        ),
      );
      context.go('/teams');
    } on Exception catch (error, stackTrace) {
      print('=== ERROR SAVING TEAM ===');
      print(error);
      print(stackTrace);
      messenger.showSnackBar(
        SnackBar(content: Text('No se pudo guardar: $error')),
      );
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/teams'),
        ),
        title: const Text('Nuevo equipo'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              TextFormField(
                controller: _teamName,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'Equipo'),
                validator: _required,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _category,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'Categoría'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _coachName,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'Coach'),
                validator: _required,
              ),
              const SizedBox(height: 24),
              Text('Roster', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              for (var index = 0; index < _players.length; index++) ...[
                _PlayerInputRow(
                  input: _players[index],
                  index: index,
                  canRemove: _players.length > 2,
                  onRemove: () {
                    setState(() {
                      _players.removeAt(index).dispose();
                    });
                  },
                ),
                const SizedBox(height: 12),
              ],
              OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    _players.add(_PlayerInput(role: PlayerRole.skater));
                  });
                },
                icon: const Icon(Icons.person_add_alt_1),
                label: const Text('Agregar jugador'),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 48,
                child: FilledButton.icon(
                  onPressed: _saving ? null : _save,
                  icon: const Icon(Icons.save),
                  label: Text(_saving ? 'Guardando' : 'Guardar equipo'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlayerInputRow extends StatelessWidget {
  const _PlayerInputRow({
    required this.input,
    required this.index,
    required this.canRemove,
    required this.onRemove,
  });

  final _PlayerInput input;
  final int index;
  final bool canRemove;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: TextFormField(
            key: ValueKey('player-name-$index'),
            controller: input.name,
            decoration: InputDecoration(
              labelText: input.role == PlayerRole.goalkeeper
                  ? 'Arquero'
                  : 'Jugador',
            ),
            validator: _required,
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 92,
          child: TextFormField(
            key: ValueKey('player-jersey-$index'),
            controller: input.jersey,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Dorsal'),
            validator: _jersey,
          ),
        ),
        const SizedBox(width: 8),
        SizedBox.square(
          dimension: 48,
          child: IconButton(
            tooltip: 'Quitar',
            onPressed: canRemove ? onRemove : null,
            icon: const Icon(Icons.remove_circle_outline),
          ),
        ),
      ],
    );
  }
}

class _PlayerInput {
  _PlayerInput({required this.role, String? jersey})
    : name = TextEditingController(
        text: role == PlayerRole.goalkeeper ? 'Arquero' : 'Jugador',
      ),
      jersey = TextEditingController(text: jersey ?? '');

  final PlayerRole role;
  final TextEditingController name;
  final TextEditingController jersey;

  void dispose() {
    name.dispose();
    jersey.dispose();
  }
}

String? _required(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Requerido';
  }
  return null;
}

String? _jersey(String? value) {
  final parsed = int.tryParse(value ?? '');
  if (parsed == null || parsed < 0 || parsed > 99) {
    return '0-99';
  }
  return null;
}

String? _blankToNull(String value) {
  final trimmed = value.trim();
  return trimmed.isEmpty ? null : trimmed;
}
