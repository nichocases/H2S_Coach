import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inline_hockey_coach/features/auth/application/admin_providers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminUsersScreen extends ConsumerStatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  ConsumerState<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends ConsumerState<AdminUsersScreen> {
  bool _isLoading = false;

  Future<void> _updateUserRole(String userId, String newRole) async {
    setState(() => _isLoading = true);
    try {
      await Supabase.instance.client
          .from('admin_user_profiles')
          .update({'role': newRole})
          .eq('id', userId);
      ref.invalidate(adminUsersProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(adminUsersProvider);

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
                          _updateUserRole(userId, newRole);
                        }
                      },
                    ),
                  );
                },
              ),
              if (_isLoading)
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
