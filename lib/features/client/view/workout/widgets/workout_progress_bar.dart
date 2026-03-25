import 'package:flutter/material.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/texts.dart';
import 'package:grit/utils/constants/text_styles.dart';
import 'package:grit/utils/device/responsive_size.dart';

class WorkoutProgressBar extends StatelessWidget {
  final int currentExerciseIndex;
  final int totalExercises;
  final String programName;

  const WorkoutProgressBar({
    super.key,
    required this.currentExerciseIndex,
    required this.totalExercises,
    required this.programName,
  });

  @override
  Widget build(BuildContext context) {
    final double progress = totalExercises == 0
        ? 0
        : (currentExerciseIndex + 1) / totalExercises;
    // Note: The progress bar width conceptually requires a dynamic completion ratio based on exercises done

    return Column(
      children: [
        SizedBox(height: AppSizes.height(12)),
        // Progress Bar Line
        Container(
          width: double.infinity,
          height: AppSizes.height(4),
          decoration: BoxDecoration(
            color: AppColors.surface2,
            borderRadius: BorderRadius.circular(AppSizes.radius(2)),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: constraints.maxWidth * progress.clamp(0.0, 1.0),
                    decoration: BoxDecoration(
                      color: AppColors.amber,
                      borderRadius: BorderRadius.circular(AppSizes.radius(2)),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        SizedBox(height: AppSizes.height(8)),
        // Progress Labels
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.width(24)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${AppTexts.workoutExerciseOf} ${currentExerciseIndex + 1} ${AppTexts.workoutOf} $totalExercises',
                style: AppTextStyles.font11RegularDim.copyWith(
                  color: AppColors.muted, // #A3A3A3
                  fontSize: AppSizes.font(11),
                ),
              ),
              Text(
                programName,
                style: AppTextStyles.font11RegularDim.copyWith(
                  color: AppColors.muted,
                  fontSize: AppSizes.font(11),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
