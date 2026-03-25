import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkoutExercise {
  final String name;
  final int totalSets;
  final int targetReps;

  const WorkoutExercise({
    required this.name,
    required this.totalSets,
    required this.targetReps,
  });
}

class ActiveWorkoutState {
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
    required this.exercises,
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
  Timer? _restTimer;

  ActiveWorkoutViewModel() : super(const ActiveWorkoutState(
    exercises: [
      WorkoutExercise(name: 'Bench Press', totalSets: 4, targetReps: 10),
      WorkoutExercise(name: 'Incline DB Press', totalSets: 3, targetReps: 12),
      WorkoutExercise(name: 'Cable Flyes', totalSets: 3, targetReps: 15),
      WorkoutExercise(name: 'Tricep Pushdown', totalSets: 3, targetReps: 12),
    ],
    currentExerciseIndex: 0,
    currentSet: 2,
    loggedSets: {"0_1"}, // Fake data: On exercise 1, set 2 of 4 (set 1 done)
  )) {
    state = state.copyWith(currentReps: state.exercises[0].targetReps);
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
    if (state.isLoggingSet) return;
    
    state = state.copyWith(isLoggingSet: true);
    await Future.delayed(const Duration(milliseconds: 200));

    final newLoggedSets = Set<String>.from(state.loggedSets);
    newLoggedSets.add('${state.currentExerciseIndex}_${state.currentSet}');
    final newVolume = state.totalVolumeLifted + (state.currentReps * state.currentWeight);
    
    final currentEx = state.exercises[state.currentExerciseIndex];
    
    if (state.currentSet >= currentEx.totalSets) {
      if (state.currentExerciseIndex < state.exercises.length - 1) {
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
        state = state.copyWith(
          loggedSets: newLoggedSets,
          totalVolumeLifted: newVolume,
          isLoggingSet: false,
          isWorkoutComplete: true,
        );
      }
    } else {
      state = state.copyWith(
        loggedSets: newLoggedSets,
        totalVolumeLifted: newVolume,
        isResting: true,
        restSecondsRemaining: 60,
        isLoggingSet: false,
      );
      _startRestTimer();
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
      // Determine what set to show (the earliest unlogged one or the max one)
      int newSetNum = 1;
      final prevEx = state.exercises[prevIndex];
      for (int i = 1; i <= prevEx.totalSets; i++) {
        if (!state.loggedSets.contains('${prevIndex}_$i')) {
          newSetNum = i;
          break;
        }
        newSetNum = prevEx.totalSets; // If all logged, point to last
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
  return ActiveWorkoutViewModel();
});
