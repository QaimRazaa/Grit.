import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grit/features/authentication/data/repository/auth_repository.dart';
import 'package:grit/utils/constants/enums.dart';
import 'package:grit/utils/constants/texts.dart';

export 'package:grit/utils/constants/enums.dart';

class GoalState {
  // Step 1 State
  final PrimaryGoal? selectedGoal;
  
  // Step 2 State
  final String weight;
  final String height;
  final String age;
  final Gender? gender;

  // Step 3 State
  final ExperienceLevel? experienceLevel;
  final DaysPerWeek? daysPerWeek;
  final GymAccess? gymAccess;
  final TrainingTime? trainingTime;

  // Step 4 State
  final String injuries;
  final GoalSource? source;

  // Global State
  final bool isLoading;
  final String? error;

  GoalState({
    this.selectedGoal,
    this.weight = '',
    this.height = '',
    this.age = '',
    this.gender,
    this.experienceLevel,
    this.daysPerWeek,
    this.gymAccess,
    this.trainingTime,
    this.injuries = '',
    this.source,
    this.isLoading = false,
    this.error,
  });

  bool get isStep1Valid => selectedGoal != null;
  bool get isStep2Valid => weight.isNotEmpty && height.isNotEmpty && age.isNotEmpty;
  bool get isStep3Valid => experienceLevel != null && daysPerWeek != null && gymAccess != null && trainingTime != null;
  bool get isStep4Valid => true; // Both fields are optional

  static const _unset = Object();

  GoalState copyWith({
    Object? selectedGoal = _unset,
    String? weight,
    String? height,
    String? age,
    Object? gender = _unset,
    Object? experienceLevel = _unset,
    Object? daysPerWeek = _unset,
    Object? gymAccess = _unset,
    Object? trainingTime = _unset,
    String? injuries,
    Object? source = _unset,
    bool? isLoading,
    Object? error = _unset,
  }) {
    return GoalState(
      selectedGoal: selectedGoal == _unset ? this.selectedGoal : selectedGoal as PrimaryGoal?,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      age: age ?? this.age,
      gender: gender == _unset ? this.gender : gender as Gender?,
      experienceLevel: experienceLevel == _unset ? this.experienceLevel : experienceLevel as ExperienceLevel?,
      daysPerWeek: daysPerWeek == _unset ? this.daysPerWeek : daysPerWeek as DaysPerWeek?,
      gymAccess: gymAccess == _unset ? this.gymAccess : gymAccess as GymAccess?,
      trainingTime: trainingTime == _unset ? this.trainingTime : trainingTime as TrainingTime?,
      injuries: injuries ?? this.injuries,
      source: source == _unset ? this.source : source as GoalSource?,
      isLoading: isLoading ?? this.isLoading,
      error: error == _unset ? this.error : error as String?,
    );
  }
}

class GoalViewModel extends StateNotifier<GoalState> {
  final AuthRepository _authRepository;

  GoalViewModel(this._authRepository) : super(GoalState());

  // Step 1 Actions
  void setGoal(PrimaryGoal goal) {
    state = state.copyWith(selectedGoal: goal);
  }

  // Step 2 Actions
  void setWeight(String w) => state = state.copyWith(weight: w);
  void setHeight(String h) => state = state.copyWith(height: h);
  void setAge(String a) => state = state.copyWith(age: a);
  void setGender(Gender g) => state = state.copyWith(gender: g);

  // Step 3 Actions
  void setExperienceLevel(ExperienceLevel el) => state = state.copyWith(experienceLevel: el);
  void setDaysPerWeek(DaysPerWeek dpw) => state = state.copyWith(daysPerWeek: dpw);
  void setGymAccess(GymAccess ga) => state = state.copyWith(gymAccess: ga);
  void setTrainingTime(TrainingTime tt) => state = state.copyWith(trainingTime: tt);

  // Step 4 Actions
  void setInjuries(String i) => state = state.copyWith(injuries: i);
  void setSource(GoalSource s) => state = state.copyWith(source: s);

  // General Step Transition Logic
  Future<void> submitStep1({required Future<void> Function() onSuccess}) async {
    if (state.isLoading || !state.isStep1Valid) return;
    await onSuccess(); // Step 1 is just local state saving, immediate transition
  }

  Future<void> submitStep2({required Future<void> Function() onSuccess}) async {
    if (state.isLoading || !state.isStep2Valid) return;
    await onSuccess(); // Step 2 is just local state saving, immediate transition
  }

  Future<void> submitStep3({required Future<void> Function() onSuccess}) async {
    if (state.isLoading || !state.isStep3Valid) return;
    await onSuccess(); // Step 3 is just local state saving, immediate transition
  }

  // Final Form Submit (Step 4)
  Future<void> submitFinalForm({required Future<void> Function() onSuccess}) async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true, error: null);

    try {
      final userId = _authRepository.currentUser?.id;
      if (userId == null) throw Exception('User not found');

      await _authRepository.updateUserProfile(
        userId: userId,
        data: {'profile_completed': true},
      );

      await _authRepository.upsertGoalForm(
        userId: userId,
        data: {
          'user_id': userId,
          'primary_goal': state.selectedGoal?.title,
          'weight': state.weight,
          'height': state.height,
          'age': state.age,
          'gender': state.gender?.label,
          'experience_level': state.experienceLevel?.label,
          'days_per_week': state.daysPerWeek?.label,
          'gym_access': state.gymAccess?.label,
          'training_time': state.trainingTime?.label,
          'injuries': state.injuries,
          'source': state.source?.label,
        },
      );



      state = state.copyWith(isLoading: false);
      await onSuccess();
    } catch (e, st) {
      debugPrint('$e\n$st');
      state = state.copyWith(
        isLoading: false,
        error: AppTexts.errorGoalFormSubmit,
      );
    }
  }
}

// Global provider for all Goal steps - NOT autoDispose, keeps state alive during the entire flow
final goalViewModelProvider =
    StateNotifierProvider<GoalViewModel, GoalState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return GoalViewModel(authRepository);
});
