import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../client/data/models/goal_form_model.dart';
import '../data/models/client_profile_model.dart';
import '../data/models/program_assignment_model.dart';
import '../data/repository/program_repository.dart';


class ClientProfileState {
  final ClientProfileModel? client;
  final GoalFormModel? goals;
  final ProgramAssignmentModel? activeAssignment;
  final bool isLoading;
  final String? error;

  ClientProfileState({
    this.client,
    this.goals,
    this.activeAssignment,
    this.isLoading = false,
    this.error,
  });

  ClientProfileState copyWith({
    ClientProfileModel? client,
    GoalFormModel? goals,
    ProgramAssignmentModel? activeAssignment,
    bool? isLoading,
    String? error,
  }) {
    return ClientProfileState(
      client: client ?? this.client,
      goals: goals ?? this.goals,
      activeAssignment: activeAssignment ?? this.activeAssignment,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
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
      final data = await _repository.loadClientFullProfile(_clientId);
      
      final profileJson = data['profile'] as Map<String, dynamic>;
      final assignmentJson = data['assignment'] as Map<String, dynamic>?;
      final streakJson = data['streak'] as Map<String, dynamic>?;

      final goalJson = (profileJson['goal_forms'] as List).isNotEmpty 
          ? profileJson['goal_forms'][0] as Map<String, dynamic> 
          : null;

      state = state.copyWith(
        client: ClientProfileModel.fromJson({
          ...profileJson,
          'streak': streakJson,
        }),
        goals: goalJson != null ? GoalFormModel.fromJson(goalJson) : null,
        activeAssignment: assignmentJson != null ? ProgramAssignmentModel.fromJson(assignmentJson) : null,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final clientProfileProvider =
    StateNotifierProvider.family<ClientProfileViewModel, ClientProfileState, String>((ref, clientId) {
  final repository = ref.watch(programRepositoryProvider);
  return ClientProfileViewModel(repository, clientId);
});
