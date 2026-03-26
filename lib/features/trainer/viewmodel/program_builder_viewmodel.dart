import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/exercise_model.dart';
import '../data/models/workout_program_model.dart';
import '../data/models/client_profile_model.dart';
import '../data/repository/program_repository.dart';

class ProgramBuilderState {
  final int currentStep; // 0=pick client, 1=setup, 2=build, 3=review
  final ClientProfileModel? selectedClient;
  final String name;
  final String description;
  final String level;
  final int weeks;
  final DateTime startDate;
  final List<ExerciseModel> exercises;
  final bool isLoading;
  final String? error;
  final bool isSaved;
  final Map<String, String> dayLabels;

  ProgramBuilderState({
    this.currentStep = 0,
    this.selectedClient,
    this.name = '',
    this.description = '',
    this.level = 'Beginner',
    this.weeks = 4,
    DateTime? startDate,
    this.exercises = const [],
    this.isLoading = false,
    this.error,
    this.isSaved = false,
    this.dayLabels = const {},
  }) : startDate = startDate ?? DateTime.now();

  int get daysPerWeek => selectedClient?.daysPerWeek ?? 4;

  bool get isFormValid => name.isNotEmpty && exercises.isNotEmpty && selectedClient != null;

  /// All exercises for a specific week and day
  List<ExerciseModel> exercisesFor(int week, int day) =>
      exercises.where((e) => e.week == week && e.day == day).toList();

  static const _unset = Object();

  ProgramBuilderState copyWith({
    int? currentStep,
    Object? selectedClient = _unset,
    String? name,
    String? description,
    String? level,
    int? weeks,
    DateTime? startDate,
    List<ExerciseModel>? exercises,
    bool? isLoading,
    Object? error = _unset,
    bool? isSaved,
    Map<String, String>? dayLabels,
  }) {
    return ProgramBuilderState(
      currentStep: currentStep ?? this.currentStep,
      selectedClient: selectedClient == _unset ? this.selectedClient : selectedClient as ClientProfileModel?,
      name: name ?? this.name,
      description: description ?? this.description,
      level: level ?? this.level,
      weeks: weeks ?? this.weeks,
      startDate: startDate ?? this.startDate,
      exercises: exercises ?? this.exercises,
      isLoading: isLoading ?? this.isLoading,
      error: error == _unset ? this.error : error as String?,
      isSaved: isSaved ?? this.isSaved,
      dayLabels: dayLabels ?? this.dayLabels,
    );
  }
}

class ProgramBuilderViewModel extends StateNotifier<ProgramBuilderState> {
  final ProgramRepository _repository;

  ProgramBuilderViewModel(this._repository) : super(ProgramBuilderState());

  // ── Navigation ──────────────────────────────────────────
  void nextStep() => state = state.copyWith(currentStep: (state.currentStep + 1).clamp(0, 3));
  void prevStep() => state = state.copyWith(currentStep: (state.currentStep - 1).clamp(0, 3));
  void goToStep(int step) => state = state.copyWith(currentStep: step.clamp(0, 3));

  // ── Step 1 ───────────────────────────────────────────────
  void selectClient(ClientProfileModel client) {
    state = state.copyWith(
      selectedClient: client,
      level: _levelFromExperience(client.experienceLevel),
    );
  }

  // ── Step 2 ───────────────────────────────────────────────
  void setName(String name) => state = state.copyWith(name: name);
  void setDescription(String desc) => state = state.copyWith(description: desc);
  void setLevel(String level) => state = state.copyWith(level: level);
  void setWeeks(int weeks) => state = state.copyWith(weeks: weeks.clamp(1, 52));
  void setStartDate(DateTime date) => state = state.copyWith(startDate: date);
  void setDayLabel(int day, String label) {
    final labels = Map<String, String>.from(state.dayLabels);
    labels["day_$day"] = label;
    state = state.copyWith(dayLabels: labels);
  }

  // ── Step 3 ───────────────────────────────────────────────
  void addExercise(ExerciseModel exercise) {
    state = state.copyWith(exercises: [...state.exercises, exercise]);
  }

  void updateExercise(int index, ExerciseModel exercise) {
    final list = [...state.exercises];
    list[index] = exercise;
    state = state.copyWith(exercises: list);
  }

  void removeExercise(int index) {
    final list = [...state.exercises];
    list.removeAt(index);
    state = state.copyWith(exercises: list);
  }

  void addExerciseToSlot(int week, int day, ExerciseModel exercise) {
    final ex = exercise.copyWith(week: week, day: day);
    state = state.copyWith(exercises: [...state.exercises, ex]);
  }

  void updateExerciseInSlot(int week, int day, int indexInSlot, ExerciseModel updated) {
    final list = [...state.exercises];
    int count = 0;
    for (int i = 0; i < list.length; i++) {
      if (list[i].week == week && list[i].day == day) {
        if (count == indexInSlot) {
          list[i] = updated.copyWith(week: week, day: day);
          state = state.copyWith(exercises: list);
          return;
        }
        count++;
      }
    }
  }

  void removeExerciseFromSlot(int week, int day, int indexInSlot) {
    final list = [...state.exercises];
    int count = 0;
    for (int i = 0; i < list.length; i++) {
      if (list[i].week == week && list[i].day == day) {
        if (count == indexInSlot) {
          list.removeAt(i);
          state = state.copyWith(exercises: list);
          return;
        }
        count++;
      }
    }
  }

  // ── Step 4 — Save & Assign ───────────────────────────────
  Future<void> saveAndAssign() async {
    if (!state.isFormValid || state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);
    try {
      final program = WorkoutProgramModel(
        name: state.name,
        description: state.description,
        level: state.level,
        exercises: state.exercises,
        dayLabels: state.dayLabels,
      );

      final saved = await _repository.saveProgram(program);

      await _repository.assignProgram(
        clientId: state.selectedClient!.id,
        programId: saved.id!,
        startDate: state.startDate,
        durationWeeks: state.weeks,
      );

      state = state.copyWith(isLoading: false, isSaved: true);
    } catch (e) {
      debugPrint('[ProgramBuilder] saveAndAssign ERROR: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // ── Helpers ──────────────────────────────────────────────
  String _levelFromExperience(String? experience) {
    switch (experience?.toLowerCase()) {
      case 'beginner': return 'Beginner';
      case 'intermediate': return 'Intermediate';
      case 'advanced': return 'Advanced';
      default: return 'Beginner';
    }
  }
}

final programBuilderProvider =
    StateNotifierProvider.autoDispose<ProgramBuilderViewModel, ProgramBuilderState>((ref) {
  final repository = ref.watch(programRepositoryProvider);
  return ProgramBuilderViewModel(repository);
});
