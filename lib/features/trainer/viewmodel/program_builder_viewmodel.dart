import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/exercise_model.dart';
import '../data/models/workout_program_model.dart';
import '../data/repository/program_repository.dart';

class ProgramBuilderState {
  final String name;
  final String description;
  final String level;
  final List<ExerciseModel> exercises;
  final bool isLoading;
  final String? error;
  final bool isSaved;

  ProgramBuilderState({
    this.name = '',
    this.description = '',
    this.level = 'Beginner',
    this.exercises = const [],
    this.isLoading = false,
    this.error,
    this.isSaved = false,
  });

  bool get isFormValid => name.isNotEmpty && exercises.isNotEmpty;

  static const _unset = Object();

  ProgramBuilderState copyWith({
    String? name,
    String? description,
    String? level,
    List<ExerciseModel>? exercises,
    bool? isLoading,
    Object? error = _unset,
    bool? isSaved,
  }) {
    return ProgramBuilderState(
      name: name ?? this.name,
      description: description ?? this.description,
      level: level ?? this.level,
      exercises: exercises ?? this.exercises,
      isLoading: isLoading ?? this.isLoading,
      error: error == _unset ? this.error : error as String?,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}

class ProgramBuilderViewModel extends StateNotifier<ProgramBuilderState> {
  final ProgramRepository _repository;

  ProgramBuilderViewModel(this._repository) : super(ProgramBuilderState());

  void setName(String name) => state = state.copyWith(name: name);
  void setDescription(String desc) => state = state.copyWith(description: desc);
  void setLevel(String level) => state = state.copyWith(level: level);

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

  void reorderExercise(int oldIndex, int newIndex) {
    final list = [...state.exercises];
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = list.removeAt(oldIndex);
    list.insert(newIndex, item);
    state = state.copyWith(exercises: list);
  }

  Future<void> save() async {
    if (!state.isFormValid || state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final program = WorkoutProgramModel(
        name: state.name,
        description: state.description,
        level: state.level,
        exercises: state.exercises,
      );

      await _repository.saveProgram(program);
      state = state.copyWith(isLoading: false, isSaved: true);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}

final programBuilderProvider =
    StateNotifierProvider<ProgramBuilderViewModel, ProgramBuilderState>((ref) {

  final repository = ref.watch(programRepositoryProvider);
  return ProgramBuilderViewModel(repository);
});
