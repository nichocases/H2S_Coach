import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final adminUsersProvider = FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final response = await Supabase.instance.client
      .from('profiles')
      .select('id, email, role')
      .order('email');
  return List<Map<String, dynamic>>.from(response);
});

class AdminController extends StateNotifier<AsyncValue<void>> {
  AdminController(this.ref) : super(const AsyncData(null));
  
  final Ref ref;

  Future<void> updateUserRole(String userId, String newRole) async {
    state = const AsyncLoading();
    try {
      await Supabase.instance.client
          .from('profiles')
          .update({'role': newRole})
          .eq('id', userId);
      ref.invalidate(adminUsersProvider);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final adminControllerProvider = StateNotifierProvider<AdminController, AsyncValue<void>>((ref) {
  return AdminController(ref);
});
