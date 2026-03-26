import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grit/features/client/view/home/widgets/exercise_card.dart';
import 'package:grit/features/client/view/home/widgets/streak_card.dart';
import 'package:grit/features/client/view/home/widgets/workout_header.dart';
import 'package:grit/features/client/view/home/widgets/pinned_workout_button.dart';
import 'package:grit/features/client/view/home/widgets/hero_progress_card.dart';
import 'package:grit/features/client/view/home/widgets/muscle_chips_and_progress.dart';
import 'package:grit/features/client/view/home/widgets/your_progress.dart';
import 'package:grit/features/client/view/home/widgets/coach_insight.dart';
import 'package:grit/features/client/view/home/widgets/next_up.dart';
import 'package:grit/features/client/viewmodel/home/home_viewmodel.dart';
import 'package:grit/shared/widgets/navbar/bottom_navigation_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:grit/core/routes/app_routes.dart';
import 'package:grit/shared/widgets/dialogs/confirm_dialog.dart';

import 'package:grit/shared/widgets/appbar/shared_top_bar.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/text_styles.dart';
import 'package:grit/utils/device/responsive_size.dart';

enum HomeWorkoutState { notStarted, partiallyLogged, allDone, programComplete, restDay }

class ClientHomeScreen extends ConsumerWidget {
  const ClientHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeViewModelProvider);

    if (state.isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator(color: AppColors.amber)),
      );
    }

    final program = state.activeProgram;
    final exercises = program?.exercises ?? [];
    final completedCount = exercises.where((ex) => state.todaysLoggedExercises.contains(ex.name)).length;
    
    HomeWorkoutState workoutState = HomeWorkoutState.notStarted;
    if (state.isRestDay) {
      workoutState = HomeWorkoutState.restDay;
    } else if (program == null) {
      workoutState = HomeWorkoutState.programComplete;
    } else if (completedCount == exercises.length && exercises.isNotEmpty) {
      workoutState = HomeWorkoutState.allDone;
    } else if (completedCount > 0) {
      workoutState = HomeWorkoutState.partiallyLogged;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const SharedBottomNavBar(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => ref.read(homeViewModelProvider.notifier).refresh(),
          color: AppColors.amber,
          child: Stack(
            children: [
              // Scrollable Content
              SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: AppSizes.width(20.0)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. SharedTopBar
                    SharedTopBar(
                      firstName: state.userName,
                      initials: state.userInitials,
                      onLogout: () {
                        ConfirmDialog.show(
                          context,
                          title: 'Sign Out',
                          message: 'Are you sure you want to sign out?',
                          confirmText: 'Sign Out',
                          confirmColor: AppColors.red,
                          onConfirm: () async {
                            await ref.read(homeViewModelProvider.notifier).signOut();
                            ref.invalidate(homeViewModelProvider);
                            if (context.mounted) {
                              context.go(AppRoutes.signin);
                            }
                          },
                        );
                      },
                    ),

                    SizedBox(height: AppSizes.height(16)),

                    // 2. Hero Progress Card
                    HeroProgressCard(
                      calories: state.weeklyCalories,
                      workouts: state.weeklyWorkouts,
                      totalTime: state.weeklyTime,
                      progress: state.weeklyGoal > 0 
                        ? (state.weeklyWorkouts / state.weeklyGoal).clamp(0.0, 1.0)
                        : 0.0,
                    ),
                    SizedBox(height: AppSizes.height(24)),

                    // 3. StreakCard
                    StreakCard(
                      streakCount: state.streak?.currentStreak ?? 0,
                      personalBest: state.streak?.longestStreak ?? 0,
                      last7DaysLogged: state.last7DaysLogStatus,
                    ),
                    SizedBox(height: AppSizes.height(24)),

                    // 4. Workout Section
                    if (program == null)
                      _buildNoProgramView()
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (state.missedDays > 0)
                            _buildMissedDaysBanner(state.missedDays),
                          
                          WorkoutHeader(
                            workoutName: state.todayWorkoutName,
                            dayNumber: state.currentDayNumber,
                          ),
                          SizedBox(height: AppSizes.height(12)),

                          if (state.isWorkoutDoneToday)
                            _buildLockedDayView(state.currentDayNumber)
                          else ...[
                            // Muscle Chips & Session Progress
                            MuscleChipsAndProgress(
                              completedCount: completedCount,
                              totalCount: exercises.length,
                              calories: state.todaysCalories,
                              muscleGroups: state.todaysMuscleGroups,
                            ),
                            SizedBox(height: AppSizes.height(16)),

                             // Exercise Cards
                            if (exercises.isEmpty)
                              Container(
                                padding: EdgeInsets.symmetric(vertical: AppSizes.height(32), horizontal: AppSizes.width(24)),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: AppColors.white.withOpacity(0.05)),
                                ),
                                child: Column(
                                  children: [
                                    const Icon(Icons.hotel_class_outlined, color: AppColors.amber, size: 48),
                                    SizedBox(height: AppSizes.height(16)),
                                    const Text('Rest Day', style: AppTextStyles.font20Bold),
                                    SizedBox(height: AppSizes.height(8)),
                                    Text(
                                      'No exercises scheduled for Day ${state.currentDayNumber}. Enjoy your recovery!',
                                      textAlign: TextAlign.center,
                                      style: AppTextStyles.font14RegularMuted,
                                    ),
                                  ],
                                ),
                              )
                            else
                              ...exercises.map((ex) {
                                final isDone = state.todaysLoggedExercises.contains(ex.name);
                                return Padding(
                                  padding: EdgeInsets.only(bottom: AppSizes.height(10)),
                                  child: ExerciseCard(
                                    name: ex.name,
                                    details: ex.toFailure ? "${ex.sets} sets x Failure" : "${ex.sets} sets x ${ex.reps} reps",
                                    totalSets: ex.sets,
                                    completedSets: isDone ? ex.sets : 0,
                                    state: isDone ? ExerciseCardState.done : ExerciseCardState.notStarted,
                                  ),
                                );
                              }),
                          ],
                        ],
                      ),

                    SizedBox(height: AppSizes.height(24)),

                    // 5. Your Progress
                    const YourProgress(),
                    SizedBox(height: AppSizes.height(24)),

                    // 7. Coach Insight
                    const CoachInsight(),
                    SizedBox(height: AppSizes.height(24)),

                    // 8. Next Up
                    const NextUp(),

                    // Bottom spacer for pinned button
                    SizedBox(height: AppSizes.height(120)),
                  ],
                ),
              ),

              if (!state.isWorkoutDoneToday)
                PinnedWorkoutButton(
                  state: workoutState,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLockedDayView(int currentDay) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: AppSizes.height(32), horizontal: AppSizes.width(24)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          const Icon(Icons.lock_clock_rounded, color: AppColors.amber, size: 48),
          SizedBox(height: AppSizes.height(16)),
          const Text('Session Complete', style: AppTextStyles.font20Bold),
          SizedBox(height: AppSizes.height(8)),
          Text(
            'Keep up the momentum! Day ${currentDay + 1} will unlock tomorrow.',
            textAlign: TextAlign.center,
            style: AppTextStyles.font14RegularMuted,
          ),
        ],
      ),
    );
  }

  Widget _buildMissedDaysBanner(int missedCount) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: AppSizes.height(12), horizontal: AppSizes.width(16)),
      margin: EdgeInsets.only(bottom: AppSizes.height(16)),
      decoration: BoxDecoration(
        color: AppColors.amber.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.amber.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded, color: AppColors.amber, size: 20),
          SizedBox(width: AppSizes.width(12)),
          Expanded(
            child: Text(
              'You missed $missedCount session(s). Pick up where you left off.',
              style: AppTextStyles.font12SemiBold.copyWith(color: AppColors.amber),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoProgramView() {
    return Container(
      width: double.infinity,
      padding: AppSizes.paddingAll(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radius(20)),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Column(
        children: [
          Icon(Icons.fitness_center_rounded, color: AppColors.amber, size: AppSizes.font(48)),
          SizedBox(height: AppSizes.height(16)),
          Text(
            'No Active Program',
            style: AppTextStyles.font18Bold,
          ),
          SizedBox(height: AppSizes.height(8)),
          Text(
            'Ask your trainer to assign you a program to get started!',
            textAlign: TextAlign.center,
            style: AppTextStyles.font14RegularMuted,
          ),
        ],
      ),
    );
  }
}
