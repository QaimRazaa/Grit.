import 'package:flutter/material.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/texts.dart';
import 'package:grit/utils/constants/text_styles.dart';
import 'package:grit/utils/device/responsive_size.dart';

class ExerciseHeader extends StatelessWidget {
  final String exerciseName;
  final int currentSet;
  final int totalSets;
  final int currentExerciseIndex;
  final int totalExercises;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const ExerciseHeader({
    super.key,
    required this.exerciseName,
    required this.currentSet,
    required this.totalSets,
    required this.currentExerciseIndex,
    required this.totalExercises,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: AppSizes.height(32)),
        // Exercise Name
        Text(
          exerciseName,
          style: AppTextStyles.font28Bold.copyWith(
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppSizes.height(12)),
        // Set counter badge
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.width(16),
            vertical: AppSizes.height(6),
          ),
          decoration: BoxDecoration(
            color: AppColors.surface, // #141414
            border: Border.all(
              color: AppColors.borderDefault, // #2A2A2A
              width: AppSizes.width(1),
            ),
            borderRadius: BorderRadius.circular(AppSizes.radius(20)),
          ),
          child: Text(
            '${AppTexts.workoutSet} $currentSet ${AppTexts.workoutOf} $totalSets',
            style: AppTextStyles.font13Regular.copyWith(
              color: AppColors.muted, // #A3A3A3
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: AppSizes.height(10)),
      ],
    );
  }
}
