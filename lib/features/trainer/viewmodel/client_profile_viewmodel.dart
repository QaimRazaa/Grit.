import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../client/data/models/goal_form_model.dart';
import '../data/models/client_profile_model.dart';
import '../data/models/program_assignment_model.dart';
import '../data/repository/program_repository.dart';


class ClientProfileState {
  final ClientProfileModel? client;
  final GoalFormModel? goals;
  final ProgramAssignmentModel? activeAssignment;
  final List<Map<String, dynamic>> workoutLogs;
  final List<bool> last7DaysActivity;
  final bool isLoading;
  final String? error;

  ClientProfileState({
    this.client,
    this.goals,
    this.activeAssignment,
    this.workoutLogs = const [],
    this.last7DaysActivity = const [false, false, false, false, false, false, false],
    this.isLoading = false,
    this.error,
  });

  static const _unset = Object();

  ClientProfileState copyWith({
    ClientProfileModel? client,
    GoalFormModel? goals,
    Object? activeAssignment = _unset,
    List<Map<String, dynamic>>? workoutLogs,
    List<bool>? last7DaysActivity,
    bool? isLoading,
    Object? error = _unset,
  }) {
    return ClientProfileState(
      client: client ?? this.client,
      goals: goals ?? this.goals,
      activeAssignment: activeAssignment == _unset ? this.activeAssignment : activeAssignment as ProgramAssignmentModel?,
      workoutLogs: workoutLogs ?? this.workoutLogs,
      last7DaysActivity: last7DaysActivity ?? this.last7DaysActivity,
      isLoading: isLoading ?? this.isLoading,
      error: error == _unset ? this.error : error as String?,
    );
  }
}

class ClientProfileViewModel extends StateNotifier<ClientProfileState> {
  final ProgramRepository _repository;
  final String _clientId;

  ClientProfileViewModel(this._repository, this._clientId) : super(ClientProfileState()) {
    load();
  }

  Future<void> load() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final results = await Future.wait([
        _repository.loadClientFullProfile(_clientId),
        _repository.loadClientWorkoutLogs(_clientId),
      ]);
      
      final data = results[0] as Map<String, dynamic>;
      final workoutLogs = results[1] as List<Map<String, dynamic>>;
      
      final profileJson = data['profile'] as Map<String, dynamic>;
      final assignmentJson = data['assignment'] as Map<String, dynamic>?;
      final streakJson = data['streak'] as Map<String, dynamic>?;

      final goalJson = (profileJson['goal_forms'] as List).isNotEmpty 
          ? profileJson['goal_forms'][0] as Map<String, dynamic> 
          : null;

      // Compute last 7 days activity (Mon-Sun)
      final now = DateTime.now();
      final monday = DateTime(now.year, now.month, now.day).subtract(Duration(days: now.weekday - 1));
      final List<bool> activity = [];
      final loggedDates = workoutLogs.map((log) => log['date']?.toString() ?? '').toSet();
      
      for (int i = 0; i < 7; i++) {
        final day = monday.add(Duration(days: i));
        final dayStr = day.toIso8601String().split('T')[0];
        activity.add(loggedDates.contains(dayStr));
      }

      state = state.copyWith(
        client: ClientProfileModel.fromJson({
          ...profileJson,
          'streak': streakJson,
        }),
        goals: goalJson != null ? GoalFormModel.fromJson(goalJson) : null,
        activeAssignment: assignmentJson != null ? ProgramAssignmentModel.fromJson(assignmentJson) : null,
        workoutLogs: workoutLogs,
        last7DaysActivity: activity,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final clientProfileProvider =
    StateNotifierProvider.family.autoDispose<ClientProfileViewModel, ClientProfileState, String>((ref, clientId) {
  final repository = ref.watch(programRepositoryProvider);
  return ClientProfileViewModel(repository, clientId);
});
