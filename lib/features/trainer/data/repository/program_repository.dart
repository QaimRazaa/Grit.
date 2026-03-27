import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grit/shared/providers/supabase_client_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/workout_program_model.dart';
import '../models/client_profile_model.dart';
import '../models/program_assignment_model.dart';
import '../models/streak_model.dart';

class ProgramRepository {
  final SupabaseClient _supabase;

  ProgramRepository(this._supabase);

  String? get _currentUserId => _supabase.auth.currentUser?.id;

  /// Saves a new workout program to the database.
  Future<WorkoutProgramModel> saveProgram(WorkoutProgramModel program) async {
    final userId = _currentUserId;
    if (userId == null) throw Exception('User not authenticated');

    final data = program.toJson();
    data['created_by'] = userId;

    final response = await _supabase
        .from('workout_programs')
        .insert(data)
        .select()
        .single();

    return WorkoutProgramModel.fromJson(response);
  }

  /// Updates an existing workout program.
  Future<WorkoutProgramModel> updateProgram(WorkoutProgramModel program) async {
    if (program.id == null)
      throw Exception('Program ID is required for update');

    final data = program.toJson();
    final response = await _supabase
        .from('workout_programs')
        .update(data)
        .eq('id', program.id!)
        .select()
        .single();

    return WorkoutProgramModel.fromJson(response);
  }

  /// Loads all programs created by the current trainer.
  Future<List<WorkoutProgramModel>> loadPrograms() async {
    final userId = _currentUserId;
    if (userId == null) return [];

    final response = await _supabase
        .from('workout_programs')
        .select()
        .eq('created_by', userId);

    return (response as List)
        .map((e) => WorkoutProgramModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Loads all clients assigned to the current trainer.
  /// Loads all clients assigned to the current trainer.
  Future<List<ClientProfileModel>> loadClients() async {
    final userId = _currentUserId;
    if (userId == null) return [];

    // 1. Load clients
    final profilesResponse = await _supabase
        .from('profiles')
        .select('id, full_name')
        .eq('role', 'client')
        .eq('trainer_id', userId);

    final profiles = profilesResponse as List;
    if (profiles.isEmpty) return [];

    final clientIds = profiles.map((p) => p['id'] as String).toList();

    // 2. Load goal forms separately to avoid join relationship issues
    final goalsResponse = await _supabase
        .from('goal_forms')
        .select('*')
        .filter('user_id', 'in', clientIds);

    final goalsList = goalsResponse as List;
    final goalsMap = {for (var g in goalsList) g['user_id'] as String: g};

    // 3. Merge
    return profiles.map((p) {
      final json = Map<String, dynamic>.from(p);
      final id = p['id'] as String;

      if (goalsMap.containsKey(id)) {
        final goals = goalsMap[id]!;
        json['primary_goal'] = goals['primary_goal'];
        json['experience_level'] = goals['experience_level'];
        json['days_per_week'] = goals['days_per_week'];
        json['injuries'] = goals['injuries'];
      }

      return ClientProfileModel.fromJson(json);
    }).toList();
  }

  /// Loads all program assignments made by the current trainer.
  Future<List<ProgramAssignmentModel>> loadAssignments() async {
    final userId = _currentUserId;
    if (userId == null) return [];

    // 1. Load assignments
    final response = await _supabase
        .from('program_assignments')
        .select('*')
        .eq('assigned_by', userId)
        .eq('active', true)
        .order('start_date', ascending: false);

    final assignments = response as List;
    if (assignments.isEmpty) return [];

    final clientIds = assignments.map((e) => e['client_id'] as String).toList();
    final programIds = assignments
        .map((e) => e['program_id'] as String)
        .toList();

    // 2. Load names separately
    final profiles = await _supabase
        .from('profiles')
        .select('id, full_name')
        .filter('id', 'in', clientIds);

    final programs = await _supabase
        .from('workout_programs')
        .select('id, name, exercises')
        .filter('id', 'in', programIds);

    final profileMap = {
      for (var p in profiles as List) p['id'] as String: p['full_name'],
    };
    final programMap = {for (var p in programs as List) p['id'] as String: p};

    // 3. Fetch completed days for these assignments
    final assignmentIds = assignments.map((e) => e['id'] as String).toList();
    final logsResponse = await _supabase
        .from('workout_logs')
        .select('assignment_id, date')
        .filter('assignment_id', 'in', assignmentIds);

    // Count distinct dates per assignment_id
    final Map<String, Set<String>> logDatesByAssignment = {};
    for (final log in logsResponse as List) {
      final aId = log['assignment_id']?.toString() ?? '';
      final date = log['date']?.toString() ?? '';
      if (aId.isEmpty || date.isEmpty) continue;
      logDatesByAssignment.putIfAbsent(aId, () => {}).add(date);
    }

    return assignments.map((e) {
      final map = Map<String, dynamic>.from(e);
      map['client_name'] = profileMap[e['client_id']] ?? 'Unknown Client';

      final programData = programMap[e['program_id']];
      if (programData != null) {
        map['program_name'] = programData['name'];
        map['exercises'] = programData['exercises'];
      }
      
      map['completed_days'] = logDatesByAssignment[e['id']]?.length ?? 0;

      return ProgramAssignmentModel.fromJson(map);
    }).toList();
  }

  /// Loads all workout logs from today across all assigned clients.
  Future<List<Map<String, dynamic>>> loadTodaysLogsAcrossClients(
    List<String> clientIds,
  ) async {
    if (clientIds.isEmpty) return [];

    final today = DateTime.now().toIso8601String().split('T')[0];

    final response = await _supabase
        .from('workout_logs')
        .select('*, profiles(full_name)')
        .filter('client_id', 'in', clientIds)
        .eq('date', today);

    // Flatten profiles(full_name) for easier consumption
    return (response as List).map((log) {
      final map = Map<String, dynamic>.from(log);
      if (log['profiles'] != null) {
        map['client_name'] = log['profiles']['full_name'];
      }
      return map;
    }).toList();
  }

  /// Loads all recent activity across all assigned clients for the global feed.
  Future<List<Map<String, dynamic>>> loadGlobalActivityFeed(
    List<String> clientIds, {
    int limit = 50,
  }) async {
    if (clientIds.isEmpty) return [];

    final today = DateTime.now().toIso8601String().split('T')[0];

    final response = await _supabase
        .from('workout_logs')
        .select('*, profiles(full_name)')
        .filter('client_id', 'in', clientIds)
        .eq('date', today)
        .order('created_at', ascending: false)
        .limit(limit);

    return (response as List).map((log) {
      final map = Map<String, dynamic>.from(log);
      if (log['profiles'] != null) {
        map['client_name'] = log['profiles']['full_name'];
      }
      return map;
    }).toList();
  }

  /// Loads streaks for a list of clients.
  Future<List<StreakModel>> loadStreaks(List<String> clientIds) async {
    if (clientIds.isEmpty) return [];

    final response = await _supabase
        .from('streaks')
        .select('*')
        .filter('client_id', 'in', clientIds);

    return (response as List)
        .map((json) => StreakModel.fromJson(json))
        .toList();
  }

  /// Loads workout activity (just dates) for the last 7 days for a list of clients.
  Future<List<Map<String, dynamic>>> loadLast7DaysActivity(
    List<String> clientIds,
  ) async {
    if (clientIds.isEmpty) return [];

    final sevenDaysAgo = DateTime.now()
        .subtract(const Duration(days: 7))
        .toIso8601String()
        .split('T')[0];

    final response = await _supabase
        .from('workout_logs')
        .select('client_id, date')
        .filter('client_id', 'in', clientIds)
        .gte('date', sevenDaysAgo);

    return (response as List).cast<Map<String, dynamic>>().toList();
  }

  /// Loads the number of clients who logged a workout today.
  Future<int> loadActiveTodayCount(List<String> clientIds) async {
    if (clientIds.isEmpty) return 0;

    final today = DateTime.now().toIso8601String().split('T')[0];

    final response = await _supabase
        .from('workout_logs')
        .select('client_id')
        .eq('date', today)
        .filter('client_id', 'in', clientIds);

    return (response as List).map((e) => e['client_id']?.toString() ?? '').where((id) => id.isNotEmpty).toSet().length;
  }

  /// Assigns a program to a client.

  Future<void> assignProgram({
    required String clientId,
    required String programId,
    required DateTime startDate,
    required int durationWeeks,
  }) async {
    if (durationWeeks <= 0) throw Exception('Duration must be at least 1 week');
    
    final userId = _currentUserId;
    if (userId == null) throw Exception('User not authenticated');

    // 1. Deactivate any existing active programs for this client
    await _supabase
        .from('program_assignments')
        .update({'active': false})
        .eq('client_id', clientId)
        .eq('active', true);

    // 2. Insert new assignment
    await _supabase.from('program_assignments').insert({
      'program_id': programId,
      'client_id': clientId,
      'assigned_by': userId,
      'start_date': startDate.toIso8601String().split(
        'T',
      )[0], // date format YYYY-MM-DD
      'duration_weeks': durationWeeks,
      'active': true,
    });
  }

  /// Loads a single client's full profile including goals and active assignments.
  Future<Map<String, dynamic>> loadClientFullProfile(String clientId) async {
    final profileResponse = await _supabase
        .from('profiles')
        .select('*')
        .eq('id', clientId)
        .maybeSingle();

    if (profileResponse == null) throw Exception('Client not found');

    final goalsResponse = await _supabase
        .from('goal_forms')
        .select('*')
        .eq('user_id', clientId)
        .maybeSingle();

    final profile = Map<String, dynamic>.from(profileResponse);
    if (goalsResponse != null) {
      profile['goal_forms'] = [goalsResponse];
      profile['injuries'] = goalsResponse['injuries'];
    } else {
      profile['goal_forms'] = [];
    }

    final assignmentResponse = await _supabase
        .from('program_assignments')
        .select('*, workout_programs(name)')
        .eq('client_id', clientId)
        .eq('active', true)
        .maybeSingle();

    int completedDays = 0;
    if (assignmentResponse != null) {
      final logs = await _supabase
          .from('workout_logs')
          .select('date')
          .eq('client_id', clientId)
          .eq('assignment_id', assignmentResponse['id']);
      
      completedDays = (logs as List)
          .map((r) => r['date']?.toString() ?? '')
          .where((d) => d.isNotEmpty)
          .toSet()
          .length;
    }

    final streakResponse = await _supabase
        .from('streaks')
        .select('*')
        .eq('client_id', clientId)
        .maybeSingle();

    final result = {
      'profile': profile,
      'assignment': assignmentResponse != null
          ? {
              ...assignmentResponse,
              'program_name': (assignmentResponse['workout_programs'] as Map?)?['name'],
              'completed_days': completedDays,
            }
          : null,
      'streak': streakResponse,
    };

    return result;
  }

  /// Loads the current trainer's profile details.
  Future<Map<String, dynamic>?> loadTrainerProfile() async {
    final userId = _currentUserId;
    if (userId == null) return null;

    final response = await _supabase
        .from('profiles')
        .select('full_name')
        .eq('id', userId)
        .maybeSingle();

    return response;
  }

  /// Loads all available exercises from the global library.
  Future<List<Map<String, dynamic>>> loadExercises() async {
    final response = await _supabase
        .from('exercises')
        .select('name, muscle_group, equipment, level')
        .order('muscle_group');

    return (response as List).cast<Map<String, dynamic>>();
  }

  /// Deletes a workout program from the database.
  Future<void> deleteProgram(String programId) async {
    await _supabase.from('workout_programs').delete().eq('id', programId);
  }

  /// Loads all workout logs for a specific client.
  Future<List<Map<String, dynamic>>> loadClientWorkoutLogs(String clientId) async {
    final response = await _supabase
        .from('workout_logs')
        .select('*')
        .eq('client_id', clientId)
        .order('date', ascending: false)
        .order('created_at', ascending: false);

    return (response as List).cast<Map<String, dynamic>>();
  }
}

final programRepositoryProvider = Provider<ProgramRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return ProgramRepository(supabase);
});

final exerciseLibraryProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final repo = ref.watch(programRepositoryProvider);
  try {
    final exercises = await repo.loadExercises();
    debugPrint('[ProgramBuilder] loadExercises() returned ${exercises.length} exercises');
    debugPrint('[ProgramBuilder] first exercise: ${exercises.isNotEmpty ? exercises.first : 'EMPTY'}');
    return exercises;
  } catch (e) {
    debugPrint('[ProgramBuilder] loadExercises() ERROR: $e');
    rethrow;
  }
});
