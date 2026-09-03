import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authStateProvider = StreamProvider<AuthState>((ref) {
  return Supabase.instance.client.auth.onAuthStateChange;
});

final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.value?.session?.user ?? Supabase.instance.client.auth.currentUser;
});

// Provides the role from the public.profiles table
final userRoleProvider = FutureProvider<String>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return 'guest';

  try {
    final response = await Supabase.instance.client
        .from('profiles')
        .select('role')
        .eq('id', user.id)
        .single();
    print('User role fetched: ${response['role']}');
    return response['role'] as String;
  } catch (e) {
    print('Error fetching user role: $e');
    return 'parent'; // default fallback
  }
});

final isCoachOrAdminProvider = Provider<bool>((ref) {
  final role = ref.watch(userRoleProvider).value;
  return role == 'coach' || role == 'super_admin';
});
