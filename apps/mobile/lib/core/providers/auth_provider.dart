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

  final response = await Supabase.instance.client
      .from('profiles')
      .select('role')
      .eq('id', user.id)
      .single();
  return response['role'] as String;
});

final isCoachOrAdminProvider = Provider<bool>((ref) {
  final roleAsync = ref.watch(userRoleProvider);
  if (roleAsync.hasError || roleAsync.isLoading) return false;
  final role = roleAsync.value;
  return role == 'coach' || role == 'super_admin';
});
