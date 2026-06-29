import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/supabase/supabase_provider.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(supabaseClientProvider));
});

final authStateProvider = StreamProvider<AuthState>((ref) {
  return ref.watch(supabaseClientProvider).auth.onAuthStateChange;
});

final currentUserProvider = Provider<User?>((ref) {
  ref.watch(authStateProvider);
  return ref.watch(supabaseClientProvider).auth.currentUser;
});

class AuthRepository {
  AuthRepository(this._client);

  final SupabaseClient _client;

  Future<void> login({required String email, required String password}) async {
    await _client.auth.signInWithPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String region,
  }) async {
    final response = await _client.auth.signUp(
      email: email.trim(),
      password: password,
      data: {'name': name.trim(), 'region': region.trim()},
    );

    final user = response.user;
    if (user != null && response.session != null) {
      await _client.from('profiles').upsert({
        'id': user.id,
        'name': name.trim(),
        'email': email.trim(),
        'region': region.trim(),
        'xp': 0,
        'level': 1,
        'rank': 'Pemula Batik',
        'streak': 0,
      });
    }
  }

  Future<void> sendPasswordReset(String email) async {
    await _client.auth.resetPasswordForEmail(email.trim());
  }

  Future<void> logout() async {
    await _client.auth.signOut();
  }
}
