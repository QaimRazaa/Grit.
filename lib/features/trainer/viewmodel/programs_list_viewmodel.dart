import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/workout_program_model.dart';
import '../data/models/program_assignment_model.dart';
import '../data/repository/program_repository.dart';

class ProgramsListState {
  final List<WorkoutProgramModel> programs;
  final List<ProgramAssignmentModel> assignments;
  final int selectedTab;
  final bool isLoading;
  final String? error;

  ProgramsListState({
    this.programs = const [],
    this.assignments = const [],
    this.selectedTab = 0,
    this.isLoading = false,
    this.error,
  });

  static const _unset = Object();

  ProgramsListState copyWith({
    List<WorkoutProgramModel>? programs,
    List<ProgramAssignmentModel>? assignments,
    int? selectedTab,
    bool? isLoading,
    Object? error = _unset,
  }) {
    return ProgramsListState(
      programs: programs ?? this.programs,
      assignments: assignments ?? this.assignments,
      selectedTab: selectedTab ?? this.selectedTab,
      isLoading: isLoading ?? this.isLoading,
      error: error == _unset ? this.error : error as String?,
    );
  }
}

class ProgramsListViewModel extends StateNotifier<ProgramsListState> {
  final ProgramRepository _repository;

  ProgramsListViewModel(this._repository) : super(ProgramsListState()) {
    refresh();
  }

  void setTab(int index) {
    state = state.copyWith(selectedTab: index);
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final results = await Future.wait([
        _repository.loadPrograms(),
        _repository.loadAssignments(),
      ]);
      
      state = state.copyWith(
        programs: results[0] as List<WorkoutProgramModel>,
        assignments: results[1] as List<ProgramAssignmentModel>,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> deleteProgram(String id) async {
    try {
      await _repository.deleteProgram(id);
      state = state.copyWith(
        programs: state.programs.where((p) => p.id != id).toList(),
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}


final programsListProvider =
    StateNotifierProvider<ProgramsListViewModel, ProgramsListState>((ref) {
  final repository = ref.watch(programRepositoryProvider);
  return ProgramsListViewModel(repository);
});

