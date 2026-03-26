import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grit/shared/providers/supabase_client_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../trainer/data/models/streak_model.dart';

class ClientRepository {
  final SupabaseClient _supabase;

  ClientRepository(this._supabase);

  String? get _currentUserId => _supabase.auth.currentUser?.id;

  /// Fetches the active program assignment for the current client.
  Future<Map<String, dynamic>?> fetchActiveAssignment() async {
    final userId = _currentUserId;
    if (userId == null) return null;

    final assignmentResponse = await _supabase
        .from('program_assignments')
        .select('*')
        .eq('client_id', userId)
        .eq('active', true)
        .limit(1)
        .maybeSingle();

    if (assignmentResponse == null) return null;

    final programResponse = await _supabase
        .from('workout_programs')
        .select('*')
        .eq('id', assignmentResponse['program_id'])
        .maybeSingle();

    final result = Map<String, dynamic>.from(assignmentResponse);
    result['workout_programs'] = programResponse;
    return result;
  }

  /// Fetches the client's current streak.
  Future<StreakModel?> fetchStreak() async {
    final userId = _currentUserId;
    if (userId == null) return null;

    final response = await _supabase
        .from('streaks')
        .select('*')
        .eq('client_id', userId)
        .maybeSingle();

    if (response == null) return null;
    return StreakModel.fromJson(response);
  }

  /// Fetches workout logs for the last 7 days.
  Future<List<String>> fetchLast7DaysActivity() async {
    final userId = _currentUserId;
    if (userId == null) return [];

    final sevenDaysAgo = DateTime.now()
        .subtract(const Duration(days: 7))
        .toIso8601String()
        .split('T')[0];

    final response = await _supabase
        .from('workout_logs')
        .select('date')
        .eq('client_id', userId)
        .gte('date', sevenDaysAgo);

    return (response as List)
        .map((row) => row['date']?.toString() ?? '')
        .where((d) => d.isNotEmpty)
        .toList();
  }

  /// Fetches detailed logs for the last 7 days for calorie/time/volume calculation.
  Future<List<Map<String, dynamic>>> fetchWeeklyLogs() async {
    final userId = _currentUserId;
    if (userId == null) return [];

    final now = DateTime.now();
    final monday = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: now.weekday - 1));
    final mondayStr = monday.toIso8601String().split('T')[0];

    final response = await _supabase
        .from('workout_logs')
        .select('date, exercise_name, reps, weight')
        .eq('client_id', userId)
        .gte('date', mondayStr);

    return List<Map<String, dynamic>>.from(response);
  }

  /// Fetches logs for the previous week for trend comparison.
  Future<List<Map<String, dynamic>>> fetchPreviousWeeklyLogs() async {
    final userId = _currentUserId;
    if (userId == null) return [];

    final now = DateTime.now();
    final monday = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: now.weekday - 1));
    final prevMonday = monday.subtract(const Duration(days: 7));
    final prevSunday = monday.subtract(const Duration(seconds: 1));

    final prevMondayStr = prevMonday.toIso8601String().split('T')[0];
    final prevSundayStr = prevSunday.toIso8601String().split('T')[0];

    final response = await _supabase
        .from('workout_logs')
        .select('date, exercise_name, reps, weight')
        .eq('client_id', userId)
        .gte('date', prevMondayStr)
        .lte('date', prevSundayStr);

    return List<Map<String, dynamic>>.from(response);
  }

  /// Saves a workout log for a specific exercise and set.
  Future<void> logExercise({
    required String assignmentId,
    required String exerciseName,
    required int setNumber,
    required int reps,
    required double weight,
  }) async {
    final userId = _currentUserId;
    if (userId == null) throw Exception('User not authenticated');

    final today = DateTime.now().toIso8601String().split('T')[0];

    await _supabase.from('workout_logs').insert({
      'client_id': userId,
      'assignment_id': assignmentId,
      'exercise_name': exerciseName,
      'set_number': setNumber,
      'reps': reps,
      'weight': weight,
      'date': today,
    });
  }

  /// Updates the user's streak after a workout.
  Future<void> updateStreak() async {
    final userId = _currentUserId;
    if (userId == null) return;

    final today = DateTime.now();
    final todayStr = today.toIso8601String().split('T')[0];

    final streak = await fetchStreak();

    if (streak == null) {
      // First time logging
      await _supabase.from('streaks').insert({
        'client_id': userId,
        'current_streak': 1,
        'last_logged_date': todayStr,
        'longest_streak': 1,
      });
      return;
    }

    if (streak.lastLoggedDate != null) {
      final lastLogged = streak.lastLoggedDate!;
      final difference = DateTime(today.year, today.month, today.day)
          .difference(
            DateTime(lastLogged.year, lastLogged.month, lastLogged.day),
          )
          .inDays;

      if (difference == 0) {
        // Already logged today, no need to update streak count
        return;
      }

      int newStreak = 1;
      if (difference == 1) {
        // Logged yesterday, increment streak
        newStreak = streak.currentStreak + 1;
      }

      final newLongest = newStreak > streak.longestStreak
          ? newStreak
          : streak.longestStreak;

      await _supabase
          .from('streaks')
          .update({
            'current_streak': newStreak,
            'last_logged_date': todayStr,
            'longest_streak': newLongest,
          })
          .eq('client_id', userId);
    }
  }

  /// Fetches names of exercises logged today.
  Future<Set<String>> fetchTodaysLoggedExercises() async {
    final userId = _currentUserId;
    if (userId == null) return {};

    final today = DateTime.now().toIso8601String().split('T')[0];

    final response = await _supabase
        .from('workout_logs')
        .select('exercise_name')
        .eq('client_id', userId)
        .eq('date', today);

    return (response as List)
        .map((row) => row['exercise_name']?.toString() ?? '')
        .where((name) => name.isNotEmpty)
        .toSet();
  }

  /// Fetches the user's goal form (containing weight, height, etc.)
  Future<Map<String, dynamic>?> fetchGoalForm() async {
    final userId = _currentUserId;
    if (userId == null) return null;

    return await _supabase
        .from('goal_forms')
        .select('*')
        .eq('user_id', userId) // Matches snake_case in DB
        .maybeSingle();
  }

  Future<int> fetchCompletedWorkoutDays(String assignmentId) async {
    final userId = _currentUserId;
    if (userId == null) return 0;

    final response = await _supabase
        .from('workout_logs')
        .select('date')
        .eq('client_id', userId)
        .eq('assignment_id', assignmentId);

    final dates = (response as List)
        .map((row) => row['date']?.toString() ?? '')
        .where((d) => d.isNotEmpty)
        .toSet();

    return dates.length;
  }

  Future<String?> fetchLastLoggedDate(String assignmentId) async {
    final userId = _currentUserId;
    if (userId == null) return null;

    final response = await _supabase
        .from('workout_logs')
        .select('date')
        .eq('client_id', userId)
        .eq('assignment_id', assignmentId)
        .order('date', ascending: false)
        .limit(1)
        .maybeSingle();

    return response?['date']?.toString();
  }
}

final clientRepositoryProvider = Provider<ClientRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return ClientRepository(supabase);
});
