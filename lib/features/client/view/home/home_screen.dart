import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grit/features/client/view/home/widgets/exercise_card.dart';
import 'package:grit/features/client/view/home/widgets/streak_card.dart';
import 'package:grit/features/client/view/home/widgets/workout_header.dart';
import 'package:grit/features/client/view/home/widgets/program_complete_view.dart';
import 'package:grit/features/client/view/home/widgets/pinned_workout_button.dart';
import 'package:grit/features/client/view/home/widgets/hero_progress_card.dart';
import 'package:grit/features/client/view/home/widgets/muscle_chips_and_progress.dart';
import 'package:grit/features/client/view/home/widgets/todays_habits.dart';
import 'package:grit/features/client/view/home/widgets/your_progress.dart';
import 'package:grit/features/client/view/home/widgets/coach_insight.dart';
import 'package:grit/features/client/view/home/widgets/next_up.dart';
import 'package:grit/shared/widgets/navbar/bottom_navigation_bar.dart';
import 'package:grit/shared/widgets/appbar/shared_top_bar.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/device/responsive_size.dart';

enum HomeWorkoutState { notStarted, partiallyLogged, allDone, programComplete }

class ClientHomeScreen extends ConsumerWidget {
  const ClientHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const currentState =
        HomeWorkoutState.partiallyLogged; // Default fake state for testing

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const SharedBottomNavBar(),
      body: SafeArea(
        child: Stack(
          children: [
            // Scrollable Content
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.width(20.0)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. SharedTopBar
                  const SharedTopBar(),
                  SizedBox(height: AppSizes.height(16)),

                  // 2. Hero Progress Card (NEW)
                  const HeroProgressCard(),
                  SizedBox(height: AppSizes.height(24)),

                  // 3. StreakCard
                  const StreakCard(),
                  SizedBox(height: AppSizes.height(24)),

                  // 4. Workout Section or Program Complete
                  if (currentState == HomeWorkoutState.programComplete)
                    const ProgramCompleteView()
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const WorkoutHeader(),
                        SizedBox(height: AppSizes.height(12)),

                        // Muscle Chips & Session Progress (NEW)
                        const MuscleChipsAndProgress(),
                        SizedBox(height: AppSizes.height(16)),

                        // Exercise Cards
                        ExerciseCard(
                          name: "Bench Press",
                          details: "4 sets x 10 reps",
                          completedSets: 4,
                          totalSets: 4,
                          state: currentState == HomeWorkoutState.allDone
                              ? ExerciseCardState.done
                              : (currentState == HomeWorkoutState.notStarted
                                    ? ExerciseCardState.notStarted
                                    : ExerciseCardState.done),
                        ),
                        SizedBox(height: AppSizes.height(10)),
                        ExerciseCard(
                          name: "Incline Dumbbell Press",
                          details: "3 sets x 12 reps",
                          completedSets: 0,
                          totalSets: 3,
                          state: currentState == HomeWorkoutState.allDone
                              ? ExerciseCardState.done
                              : (currentState == HomeWorkoutState.notStarted
                                    ? ExerciseCardState.notStarted
                                    : ExerciseCardState.active),
                        ),
                        SizedBox(height: AppSizes.height(10)),
                        ExerciseCard(
                          name: "Cable Flyes",
                          details: "3 sets x 15 reps",
                          totalSets: 3,
                          state: currentState == HomeWorkoutState.allDone
                              ? ExerciseCardState.done
                              : ExerciseCardState.notStarted,
                        ),
                        SizedBox(height: AppSizes.height(10)),
                        ExerciseCard(
                          name: "Tricep Pushdown",
                          details: "3 sets x 12 reps",
                          totalSets: 3,
                          state: currentState == HomeWorkoutState.allDone
                              ? ExerciseCardState.done
                              : ExerciseCardState.notStarted,
                        ),
                      ],
                    ),

                  SizedBox(height: AppSizes.height(24)),

                  // 5. Today's Habits (NEW)
                  const TodaysHabits(),
                  SizedBox(height: AppSizes.height(24)),

                  // 6. Your Progress (NEW)
                  const YourProgress(),
                  SizedBox(height: AppSizes.height(24)),

                  // 7. Coach Insight (NEW)
                  const CoachInsight(),
                  SizedBox(height: AppSizes.height(24)),

                  // 8. Next Up (NEW)
                  const NextUp(),

                  // Bottom spacer for pinned button
                  SizedBox(height: AppSizes.height(120)),
                ],
              ),
            ),

            const PinnedWorkoutButton(state: currentState),
          ],
        ),
      ),
    );
  }
}
