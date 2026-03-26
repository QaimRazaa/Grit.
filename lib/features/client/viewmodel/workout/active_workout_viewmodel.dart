import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/client_repository.dart';
import '../home/home_viewmodel.dart';

class WorkoutExercise {
  final String name;
  final int totalSets;
  final int targetReps;
  final int restSeconds;
  final bool toFailure;

  const WorkoutExercise({
    required this.name,
    required this.totalSets,
    required this.targetReps,
    this.restSeconds = 60,
    this.toFailure = false,
  });
}

class ActiveWorkoutState {
  final String? assignmentId;
  final List<WorkoutExercise> exercises;
  final int currentExerciseIndex;
  final int currentSet; // 1-indexed
  final int currentReps;
  final double currentWeight;
  final bool isResting;
  final bool isLoggingSet;
  final int restSecondsRemaining;
  final double totalVolumeLifted;
  final bool isWorkoutComplete;
  // Format: "exerciseIndex_setIndex"
  final Set<String> loggedSets;

  const ActiveWorkoutState({
    this.assignmentId,
    this.exercises = const [],
    this.currentExerciseIndex = 0,
    this.currentSet = 1,
    this.currentReps = 0,
    this.currentWeight = 0.0,
    this.isResting = false,
    this.isLoggingSet = false,
    this.restSecondsRemaining = 60,
    this.totalVolumeLifted = 0.0,
    this.isWorkoutComplete = false,
    this.loggedSets = const {},
  });

  ActiveWorkoutState copyWith({
    String? assignmentId,
    List<WorkoutExercise>? exercises,
    int? currentExerciseIndex,
    int? currentSet,
    int? currentReps,
    double? currentWeight,
    bool? isResting,
    bool? isLoggingSet,
    int? restSecondsRemaining,
    double? totalVolumeLifted,
    bool? isWorkoutComplete,
    Set<String>? loggedSets,
  }) {
    return ActiveWorkoutState(
      assignmentId: assignmentId ?? this.assignmentId,
      exercises: exercises ?? this.exercises,
      currentExerciseIndex: currentExerciseIndex ?? this.currentExerciseIndex,
      currentSet: currentSet ?? this.currentSet,
      currentReps: currentReps ?? this.currentReps,
      currentWeight: currentWeight ?? this.currentWeight,
      isResting: isResting ?? this.isResting,
      isLoggingSet: isLoggingSet ?? this.isLoggingSet,
      restSecondsRemaining: restSecondsRemaining ?? this.restSecondsRemaining,
      totalVolumeLifted: totalVolumeLifted ?? this.totalVolumeLifted,
      isWorkoutComplete: isWorkoutComplete ?? this.isWorkoutComplete,
      loggedSets: loggedSets ?? this.loggedSets,
    );
  }
}

class ActiveWorkoutViewModel extends StateNotifier<ActiveWorkoutState> {
  final ClientRepository _repository;
  Timer? _restTimer;

  ActiveWorkoutViewModel(this._repository, ActiveWorkoutState initialState) : super(initialState) {
    if (state.exercises.isNotEmpty) {
      state = state.copyWith(currentReps: state.exercises[0].targetReps);
    }
  }

  void incrementReps() {
    state = state.copyWith(currentReps: state.currentReps + 1);
  }

  void decrementReps() {
    if (state.currentReps > 1) {
      state = state.copyWith(currentReps: state.currentReps - 1);
    }
  }

  void incrementWeight() {
    state = state.copyWith(currentWeight: state.currentWeight + 2.5);
  }

  void decrementWeight() {
    if (state.currentWeight >= 2.5) {
      state = state.copyWith(currentWeight: state.currentWeight - 2.5);
    }
  }

  Future<void> logSet() async {
    if (state.isLoggingSet || state.assignmentId == null) {
      return;
    }
    
    state = state.copyWith(isLoggingSet: true);
    
    try {
      final currentEx = state.exercises[state.currentExerciseIndex];
      
      // Log to Supabase
      await _repository.logExercise(
        assignmentId: state.assignmentId!,
        exerciseName: currentEx.name,
        setNumber: state.currentSet,
        reps: currentEx.toFailure ? 0 : state.currentReps,
        weight: state.currentWeight,
      );

      final newLoggedSets = Set<String>.from(state.loggedSets);
      newLoggedSets.add('${state.currentExerciseIndex}_${state.currentSet}');
      final newVolume = state.totalVolumeLifted + (state.currentReps * state.currentWeight);
      
      if (state.currentSet >= currentEx.totalSets) {
        if (state.currentExerciseIndex < state.exercises.length - 1) {
          if (!mounted) return;
          state = state.copyWith(
            loggedSets: newLoggedSets,
            totalVolumeLifted: newVolume,
            currentExerciseIndex: state.currentExerciseIndex + 1,
            currentSet: 1,
            currentReps: state.exercises[state.currentExerciseIndex + 1].targetReps,
            isResting: false,
            isLoggingSet: false,
          );
        } else {
          try {
            await _repository.updateStreak();
          } catch (e) {
            // Non-fatal error
          }
          if (!mounted) return;
          state = state.copyWith(
            loggedSets: newLoggedSets,
            totalVolumeLifted: newVolume,
            isLoggingSet: false,
            isWorkoutComplete: true,
          );
        }
      } else {
        if (!mounted) return;
        state = state.copyWith(
          loggedSets: newLoggedSets,
          totalVolumeLifted: newVolume,
          isResting: true,
          restSecondsRemaining: currentEx.restSeconds,
          isLoggingSet: false,
        );
        _startRestTimer();
      }
    } catch (e) {
      if (mounted) {
        state = state.copyWith(isLoggingSet: false);
      }
    }
  }

  void _startRestTimer() {
    _restTimer?.cancel();
    _restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.restSecondsRemaining > 1) {
        state = state.copyWith(restSecondsRemaining: state.restSecondsRemaining - 1);
      } else {
        skipRest();
      }
    });
  }

  void skipRest() {
    _restTimer?.cancel();
    final currentEx = state.exercises[state.currentExerciseIndex];
    if (state.currentSet < currentEx.totalSets) {
      state = state.copyWith(
        isResting: false,
        currentSet: state.currentSet + 1,
        currentReps: currentEx.targetReps,
      );
    }
  }

  void previousExercise() {
    if (state.currentExerciseIndex > 0) {
      final prevIndex = state.currentExerciseIndex - 1;
      _restTimer?.cancel();
      
      int newSetNum = 1;
      final prevEx = state.exercises[prevIndex];
      for (int i = 1; i <= prevEx.totalSets; i++) {
        if (!state.loggedSets.contains('${prevIndex}_$i')) {
          newSetNum = i;
          break;
        }
        newSetNum = prevEx.totalSets;
      }

      state = state.copyWith(
        currentExerciseIndex: prevIndex,
        currentSet: newSetNum,
        currentReps: prevEx.targetReps,
        isResting: false,
      );
    }
  }

  void nextExercise() {
    if (state.currentExerciseIndex < state.exercises.length - 1) {
      final nextIndex = state.currentExerciseIndex + 1;
      _restTimer?.cancel();
      
      int newSetNum = 1;
      final nextEx = state.exercises[nextIndex];
      for (int i = 1; i <= nextEx.totalSets; i++) {
        if (!state.loggedSets.contains('${nextIndex}_$i')) {
          newSetNum = i;
          break;
        }
        newSetNum = nextEx.totalSets;
      }

      state = state.copyWith(
        currentExerciseIndex: nextIndex,
        currentSet: newSetNum,
        currentReps: nextEx.targetReps,
        isResting: false,
      );
    }
  }

  @override
  void dispose() {
    _restTimer?.cancel();
    super.dispose();
  }
}

final activeWorkoutProvider = StateNotifierProvider<ActiveWorkoutViewModel, ActiveWorkoutState>((ref) {
  final repository = ref.watch(clientRepositoryProvider);
  final homeState = ref.watch(homeViewModelProvider);
  
  final exercises = homeState.activeProgram?.exercises.map((e) => WorkoutExercise(
    name: e.name,
    totalSets: e.sets,
    targetReps: e.reps,
    restSeconds: e.restSeconds ?? 60,
    toFailure: e.toFailure,
  )).toList() ?? [];

  final initialState = ActiveWorkoutState(
    assignmentId: homeState.activeAssignment?['id'],
    exercises: exercises,
  );

  return ActiveWorkoutViewModel(repository, initialState);
});
