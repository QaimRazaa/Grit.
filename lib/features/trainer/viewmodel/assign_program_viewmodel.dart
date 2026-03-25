import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/client_profile_model.dart';
import '../data/models/workout_program_model.dart';
import '../data/repository/program_repository.dart';

class AssignProgramState {
  final List<ClientProfileModel> clients;
  final List<WorkoutProgramModel> programs;
  final String? selectedClientId;
  final String? selectedProgramId;
  final DateTime startDate;
  final int durationWeeks;
  final int currentStep;
  final bool isLoading;
  final String? error;
  final bool isAssigned;

  AssignProgramState({
    this.clients = const [],
    this.programs = const [],
    this.selectedClientId,
    this.selectedProgramId,
    required this.startDate,
    this.durationWeeks = 12,
    this.currentStep = 0,
    this.isLoading = false,
    this.error,
    this.isAssigned = false,
  });

  bool get canProceed {
    if (currentStep == 0) return selectedClientId != null;
    if (currentStep == 1) return selectedProgramId != null;
    return true;
  }

  static const _unset = Object();

  AssignProgramState copyWith({
    List<ClientProfileModel>? clients,
    List<WorkoutProgramModel>? programs,
    Object? selectedClientId = _unset,
    Object? selectedProgramId = _unset,
    DateTime? startDate,
    int? durationWeeks,
    int? currentStep,
    bool? isLoading,
    Object? error = _unset,
    bool? isAssigned,
  }) {
    return AssignProgramState(
      clients: clients ?? this.clients,
      programs: programs ?? this.programs,
      selectedClientId: selectedClientId == _unset ? this.selectedClientId : selectedClientId as String?,
      selectedProgramId: selectedProgramId == _unset ? this.selectedProgramId : selectedProgramId as String?,
      startDate: startDate ?? this.startDate,
      durationWeeks: durationWeeks ?? this.durationWeeks,
      currentStep: currentStep ?? this.currentStep,
      isLoading: isLoading ?? this.isLoading,
      error: error == _unset ? this.error : error as String?,
      isAssigned: isAssigned ?? this.isAssigned,
    );
  }
}


class AssignProgramViewModel extends StateNotifier<AssignProgramState> {
  final ProgramRepository _repository;

  AssignProgramViewModel(this._repository)
      : super(AssignProgramState(startDate: DateTime.now())) {
    _loadData();
  }

  Future<void> _loadData() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final results = await Future.wait([
        _repository.loadClients(),
        _repository.loadPrograms(),
      ]);

      state = state.copyWith(
        clients: results[0] as List<ClientProfileModel>,
        programs: results[1] as List<WorkoutProgramModel>,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void selectClient(String? clientId) {
    state = state.copyWith(selectedClientId: clientId);
  }

  void selectProgram(String? programId) {
    state = state.copyWith(selectedProgramId: programId);
  }

  void setStartDate(DateTime date) {
    state = state.copyWith(startDate: date);
  }

  void setDuration(int weeks) {
    state = state.copyWith(durationWeeks: weeks);
  }

  void nextStep() {
    if (state.canProceed && state.currentStep < 2) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void prevStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  Future<void> assign() async {
    if (state.isLoading || state.selectedClientId == null || state.selectedProgramId == null) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      await _repository.assignProgram(
        clientId: state.selectedClientId!,
        programId: state.selectedProgramId!,
        startDate: state.startDate,
        durationWeeks: state.durationWeeks,
      );
      state = state.copyWith(isLoading: false, isAssigned: true);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

}

final assignProgramProvider =
    StateNotifierProvider.autoDispose<AssignProgramViewModel, AssignProgramState>((ref) {
  final repository = ref.watch(programRepositoryProvider);
  return AssignProgramViewModel(repository);
});
