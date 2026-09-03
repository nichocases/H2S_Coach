import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final adminUsersProvider = FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final response = await Supabase.instance.client
      .from('admin_user_profiles')
      .select('id, email, role')
      .order('email');
  return List<Map<String, dynamic>>.from(response);
});

class AdminController extends StateNotifier<bool> {
  AdminController(this.ref) : super(false);
  
  final Ref ref;

  Future<void> updateUserRole(String userId, String newRole) async {
    state = true;
    try {
      await Supabase.instance.client
          .from('admin_user_profiles')
          .update({'role': newRole})
          .eq('id', userId);
      ref.invalidate(adminUsersProvider);
    } catch (e) {
      print('Error updating role: $e');
    } finally {
      state = false;
    }
  }
}

final adminControllerProvider = StateNotifierProvider.autoDispose<AdminController, bool>((ref) {
  return AdminController(ref);
});
