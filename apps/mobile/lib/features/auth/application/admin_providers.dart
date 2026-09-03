import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final adminUsersProvider = FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final response = await Supabase.instance.client
      .from('admin_user_profiles')
      .select('id, email, role')
      .order('email');
  return List<Map<String, dynamic>>.from(response);
});
