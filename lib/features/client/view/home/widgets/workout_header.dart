import 'package:flutter/material.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/texts.dart';
import 'package:grit/utils/constants/text_styles.dart';

class WorkoutHeader extends StatelessWidget {
  final String workoutName;
  const WorkoutHeader({super.key, required this.workoutName});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          AppTexts.homeTodayLabel,
          style: AppTextStyles.font11RegularDim.copyWith(
            color: AppColors.muted,
            letterSpacing: 11 * 0.08,
          ),
        ),
        Text(
          workoutName,
          style: AppTextStyles.font16SemiBold,
        ),
      ],
    );
  }
}
