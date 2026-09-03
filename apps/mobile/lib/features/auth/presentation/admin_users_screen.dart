import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inline_hockey_coach/features/auth/application/admin_providers.dart';

class AdminUsersScreen extends ConsumerWidget {
  const AdminUsersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(adminUsersProvider);
    final controllerState = ref.watch(adminControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrar Usuarios'),
      ),
      body: usersAsync.when(
        data: (users) {
          if (users.isEmpty) {
            return const Center(child: Text('No hay usuarios registrados.'));
          }

          return Stack(
            children: [
              ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  final userId = user['id'] as String;
                  final email = user['email'] as String? ?? 'Sin email';
                  final currentRole = user['role'] as String? ?? 'guest';

                  return ListTile(
                    title: Text(email),
                    subtitle: Text('ID: $userId'),
                    trailing: DropdownButton<String>(
                      value: ['super_admin', 'coach', 'parent', 'guest'].contains(currentRole) ? currentRole : 'guest',
                      items: const [
                        DropdownMenuItem(value: 'super_admin', child: Text('Super Admin')),
                        DropdownMenuItem(value: 'coach', child: Text('Coach (Entrenador)')),
                        DropdownMenuItem(value: 'parent', child: Text('Parent / Espectador')),
                        DropdownMenuItem(value: 'guest', child: Text('Guest (Pendiente)')),
                      ],
                      onChanged: (newRole) {
                        if (newRole != null && newRole != currentRole) {
                          ref.read(adminControllerProvider.notifier).updateUserRole(userId, newRole);
                        }
                      },
                    ),
                  );
                },
              ),
              if (controllerState)
                const ColoredBox(
                  color: Colors.black54,
                  child: Center(child: CircularProgressIndicator()),
                ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
