import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inline_hockey_coach/data/local/drift/app_database.dart';
import 'package:inline_hockey_coach/domain/entities/hockey_enums.dart';
import 'package:inline_hockey_coach/domain/entities/local_models.dart';
import 'package:inline_hockey_coach/features/teams/application/team_overview_providers.dart';

// We create a provider to fetch the team and its players
final editTeamFutureProvider = FutureProvider.autoDispose.family<TeamRosterSummary, String>((ref, teamId) async {
  final teamRepo = ref.watch(teamRepositoryProvider);
  final playerRepo = ref.watch(playerRepositoryProvider);

  final team = await teamRepo.find(teamId);
  if (team == null) throw Exception('Team not found');

  final players = await playerRepo.listForTeam(teamId);
  final activePlayers = players.where((p) => p.active).toList();

  return TeamRosterSummary(
    team: team,
    skaterCount: activePlayers.where((p) => p.defaultRole == PlayerRole.skater.storageValue).length,
    goalkeeperCount: activePlayers.where((p) => p.defaultRole == PlayerRole.goalkeeper.storageValue).length,
  );
});

final teamPlayersFutureProvider = FutureProvider.autoDispose.family<List<Player>, String>((ref, teamId) async {
  final playerRepo = ref.watch(playerRepositoryProvider);
  final players = await playerRepo.listForTeam(teamId);
  return players.where((p) => p.active).toList();
});

class EditTeamScreen extends ConsumerStatefulWidget {
  const EditTeamScreen({super.key, required this.teamId});

  final String teamId;

  @override
  ConsumerState<EditTeamScreen> createState() => _EditTeamScreenState();
}

class _EditTeamScreenState extends ConsumerState<EditTeamScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _categoryController;

  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _categoryController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _saveTeam(Team team) async {
    if (_formKey.currentState!.validate()) {
      await ref.read(teamRepositoryProvider).updateTeam(
            id: team.id,
            name: _nameController.text.trim(),
            category: _categoryController.text.trim().isEmpty ? null : _categoryController.text.trim(),
          );
      ref.invalidate(teamListProvider);
      ref.invalidate(editTeamFutureProvider(widget.teamId));
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Equipo actualizado')));
    }
  }

  Future<void> _showPlayerDialog([Player? player]) async {
    final isEditing = player != null;
    final nameController = TextEditingController(text: player?.displayName ?? '');
    final jerseyController = TextEditingController(text: player?.jerseyNumber.toString() ?? '');
    PlayerRole role = player != null 
        ? PlayerRole.values.firstWhere((r) => r.storageValue == player.defaultRole, orElse: () => PlayerRole.skater)
        : PlayerRole.skater;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(isEditing ? 'Editar Jugador' : 'Añadir Jugador'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Nombre'),
                    ),
                    TextField(
                      controller: jerseyController,
                      decoration: const InputDecoration(labelText: 'Número'),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<PlayerRole>(
                      value: role,
                      decoration: const InputDecoration(labelText: 'Rol'),
                      items: PlayerRole.values.map((r) {
                        final label = r == PlayerRole.skater ? 'JUGADOR' : 'ARQUERO';
                        return DropdownMenuItem(
                          value: r,
                          child: Text(label),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => role = val);
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () async {
                    final name = nameController.text.trim();
                    final jersey = int.tryParse(jerseyController.text.trim());
                    if (name.isNotEmpty && jersey != null) {
                      final repo = ref.read(playerRepositoryProvider);
                      if (isEditing) {
                        await repo.updatePlayer(
                          id: player.id,
                          displayName: name,
                          jerseyNumber: jersey,
                          role: role,
                        );
                      } else {
                        await repo.create(PlayerDraft(
                          teamId: widget.teamId,
                          displayName: name,
                          jerseyNumber: jersey,
                          defaultRole: role,
                        ));
                      }
                      ref.invalidate(teamPlayersFutureProvider(widget.teamId));
                      ref.invalidate(teamListProvider);
                      if (context.mounted) Navigator.pop(context);
                    }
                  },
                  child: const Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _deactivatePlayer(Player player) async {
    final repo = ref.read(playerRepositoryProvider);
    await repo.deactivate(player.id);
    ref.invalidate(teamPlayersFutureProvider(widget.teamId));
    ref.invalidate(teamListProvider);
  }

  @override
  Widget build(BuildContext context) {
    final teamAsync = ref.watch(editTeamFutureProvider(widget.teamId));
    final playersAsync = ref.watch(teamPlayersFutureProvider(widget.teamId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Equipo'),
      ),
      body: teamAsync.when(
        data: (summary) {
          if (!_isInitialized) {
            _nameController.text = summary.team.name;
            _categoryController.text = summary.team.category ?? '';
            _isInitialized = true;
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre del equipo',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => v != null && v.trim().isEmpty ? 'Requerido' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _categoryController,
                      decoration: const InputDecoration(
                        labelText: 'Categoría (Opcional)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _saveTeam(summary.team),
                      child: const Text('Guardar Cambios del Equipo'),
                    ),
                  ],
                ),
              ),
              const Divider(height: 48),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Roster', style: Theme.of(context).textTheme.titleLarge),
                  FilledButton.icon(
                    onPressed: () => _showPlayerDialog(),
                    icon: const Icon(Icons.add),
                    label: const Text('Añadir Jugador'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              playersAsync.when(
                data: (players) {
                  if (players.isEmpty) {
                    return const Text('No hay jugadores registrados.');
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: players.length,
                    itemBuilder: (context, index) {
                      final p = players[index];
                      return ListTile(
                        leading: CircleAvatar(child: Text('${p.jerseyNumber}')),
                        title: Text(p.displayName),
                        subtitle: Text(p.defaultRole == PlayerRole.skater.storageValue ? 'Jugador' : 'Arquero'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _showPlayerDialog(p),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deactivatePlayer(p),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, st) => Text('Error: $e'),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error cargando equipo: $e')),
      ),
    );
  }
}
