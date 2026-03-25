import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grit/shared/providers/supabase_client_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseClient _supabase;

  AuthRepository(this._supabase);

  Session? get currentSession => _supabase.auth.currentSession;
  User? get currentUser => _supabase.auth.currentUser;
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required Map<String, dynamic> data,
  }) async {
    return await _supabase.auth.signUp(
      email: email,
      password: password,
      data: data,
    );
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  Future<void> updateUserProfile({
    required String userId,
    required Map<String, dynamic> data,
  }) async {
    await _supabase.from('profiles').update(data).eq('id', userId);
  }

  Future<void> upsertGoalForm({
    required String userId,
    required Map<String, dynamic> data,
  }) async {
    await _supabase.from('goal_forms').upsert(data);
  }


  Future<bool> hasCompletedProfile(String userId) async {
    final response = await _supabase
        .from('profiles')
        .select('profile_completed')
        .eq('id', userId)
        .maybeSingle();
    return response?['profile_completed'] == true;
  }

  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    final response = await _supabase
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();
    return response;
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return AuthRepository(supabase);
});

/// Stream of auth state changes [AuthChangeEvent]
final authStateProvider = StreamProvider<AuthState>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

/// Current authenticated user
final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.maybeWhen(
    data: (state) => state.session?.user,
    orElse: () => ref.read(authRepositoryProvider).currentUser,
  );
});
