import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grit/core/routes/app_routes.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/device/responsive_size.dart';
import 'package:grit/features/client/viewmodel/workout/active_workout_viewmodel.dart';
import 'package:grit/features/client/viewmodel/home/home_viewmodel.dart';
import 'package:grit/features/client/view/workout/widgets/workout_top_bar.dart';
import 'package:grit/features/client/view/workout/widgets/workout_progress_bar.dart';
import 'package:grit/features/client/view/workout/widgets/exercise_header.dart';
import 'package:grit/features/client/view/workout/widgets/set_progress_tracker.dart';
import 'package:grit/features/client/view/workout/widgets/workout_input_card.dart';
import 'package:grit/features/client/view/workout/widgets/log_set_button.dart';
import 'package:grit/features/client/view/workout/widgets/rest_timer_view.dart';
import 'package:grit/features/client/view/workout/widgets/exit_workout_bottom_sheet.dart';
import 'package:grit/utils/constants/texts.dart';
import 'package:grit/utils/constants/text_styles.dart';

class ActiveWorkoutScreen extends ConsumerWidget {
  const ActiveWorkoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeViewModelProvider);
    final state = ref.watch(activeWorkoutProvider);

    ref.listen(activeWorkoutProvider, (previous, next) {
      if ((previous?.isWorkoutComplete == false || previous == null) && next.isWorkoutComplete == true) {
        Future.microtask(() {
          if (context.mounted) {
            context.go(AppRoutes.workoutComplete, extra: {
              'streakDays': (homeState.streak?.currentStreak ?? 0) + 1,
              'exercisesDone': next.exercises.length,
              'totalSets': next.loggedSets.length,
              'totalVolume': next.totalVolumeLifted,
            });
            
            // Refresh home data to update streak/logs
            ref.read(homeViewModelProvider.notifier).refresh();
          }
        });
      }
    });

    if (state.exercises.isEmpty) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator(color: AppColors.amber)),
      );
    }
    
    final currentExercise = state.exercises[state.currentExerciseIndex];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // 1. Top bar
            WorkoutTopBar(
              onExit: () {
                ExitWorkoutBottomSheet.show(
                  context,
                  onEndWorkout: () {
                    context.pop(); 
                  },
                );
              },
            ),
            
            // 2. Progress bar + labels
            WorkoutProgressBar(
              currentExerciseIndex: state.currentExerciseIndex,
              totalExercises: state.exercises.length,
              programName: homeState.activeProgram?.name ?? "Workout",
            ),
            
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // 3. Exercise header
                    ExerciseHeader(
                      exerciseName: currentExercise.name,
                      currentSet: state.currentSet,
                      totalSets: currentExercise.totalSets,
                      currentExerciseIndex: state.currentExerciseIndex,
                      totalExercises: state.exercises.length,
                      onPrevious: () => ref.read(activeWorkoutProvider.notifier).previousExercise(),
                      onNext: () => ref.read(activeWorkoutProvider.notifier).nextExercise(),
                    ),
                    
                    // 4. Sets tracker pills row
                    SetProgressTracker(
                      totalSets: currentExercise.totalSets,
                      currentSet: state.currentSet,
                      loggedSets: state.loggedSets,
                      currentExerciseIndex: state.currentExerciseIndex,
                    ),
                    
                    SizedBox(height: AppSizes.height(20)),
                    
                    // 5. Input cards
                    WorkoutInputCard(
                      label: AppTexts.workoutRepsDone,
                      displayValue: state.currentReps.toString(),
                      onMinus: () => ref.read(activeWorkoutProvider.notifier).decrementReps(),
                      onPlus: () => ref.read(activeWorkoutProvider.notifier).incrementReps(),
                    ),
                    SizedBox(height: AppSizes.height(12)),
                    WorkoutInputCard(
                      label: AppTexts.workoutWeightKg,
                      displayValue: state.currentWeight == 0.0 
                          ? AppTexts.workoutBodyweight 
                          : state.currentWeight.toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), ''),
                      onMinus: () => ref.read(activeWorkoutProvider.notifier).decrementWeight(),
                      onPlus: () => ref.read(activeWorkoutProvider.notifier).incrementWeight(),
                    ),
                    
                    SizedBox(height: AppSizes.height(24)),
                    
                    // 6. Log Set Button OR Rest Timer
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                      child: state.isResting
                          ? RestTimerView(
                              key: const ValueKey('RestTimer'),
                              secondsRemaining: state.restSecondsRemaining,
                              totalRestSeconds: currentExercise.restSeconds,
                              onSkip: () => ref.read(activeWorkoutProvider.notifier).skipRest(),
                            )
                          : LogSetButton(
                              key: const ValueKey('LogSet'),
                              currentSet: state.currentSet,
                              totalSets: currentExercise.totalSets,
                              exerciseName: currentExercise.name,
                              isLoggingSet: state.isLoggingSet,
                              onLogSet: () => ref.read(activeWorkoutProvider.notifier).logSet(),
                            ),
                    ),
                    
                    SizedBox(height: AppSizes.height(40)),
                  ],
                ),
              ),
            ),
            
            // 7. Bottom Navigation
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.width(24), vertical: AppSizes.height(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: state.currentExerciseIndex > 0 ? () => ref.read(activeWorkoutProvider.notifier).previousExercise() : null,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: state.currentExerciseIndex > 0 ? 1.0 : 0.0,
                      child: Row(
                        children: [
                          Icon(Icons.arrow_back_ios_rounded, color: AppColors.muted, size: AppSizes.font(16)),
                        ],
                      ),
                    ),
                  ),
                  
                  GestureDetector(
                    onTap: state.currentExerciseIndex < state.exercises.length - 1 ? () => ref.read(activeWorkoutProvider.notifier).nextExercise() : null,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: state.currentExerciseIndex < state.exercises.length - 1 ? 1.0 : 0.0,
                      child: Row(
                        children: [
                          Text(
                            state.currentExerciseIndex < state.exercises.length - 1 
                                ? "Next: ${state.exercises[state.currentExerciseIndex + 1].name}"
                                : "",
                            style: AppTextStyles.font13Medium.copyWith(color: AppColors.muted),
                          ),
                          SizedBox(width: AppSizes.width(8)),
                          Icon(Icons.arrow_forward_ios_rounded, color: AppColors.muted, size: AppSizes.font(16)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
