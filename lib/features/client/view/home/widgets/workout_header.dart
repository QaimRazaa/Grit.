import 'package:flutter/material.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/text_styles.dart';

class WorkoutHeader extends StatelessWidget {
  final String workoutName;
  final int dayNumber;
  
  const WorkoutHeader({
    super.key,
    required this.workoutName,
    required this.dayNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'TODAY — DAY $dayNumber',
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
