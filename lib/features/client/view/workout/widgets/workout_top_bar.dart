import 'package:flutter/material.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/texts.dart';
import 'package:grit/utils/constants/text_styles.dart';
import 'package:grit/utils/device/responsive_size.dart';

class WorkoutTopBar extends StatelessWidget {
  final VoidCallback onExit;

  const WorkoutTopBar({super.key, required this.onExit});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: onExit,
          child: Container(
            color: Colors.transparent,
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.width(20),
              vertical: AppSizes.height(8),
            ),
            child: Icon(
              Icons.arrow_back_rounded,
              color: AppColors.muted,
              size: AppSizes.font(22),
            ),
          ),
        ),
        Text(
          AppTexts.workoutTitle,
          style: AppTextStyles.font18Bold.copyWith(
            fontWeight: FontWeight.w600, // SemiBold
          ),
        ),
        GestureDetector(
          onTap: onExit,
          child: Container(
            color: Colors.transparent,
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.width(20),
              vertical: AppSizes.height(8),
            ),
            child: Icon(
              Icons.close_rounded,
              color: AppColors.muted,
              size: AppSizes.font(22),
            ),
          ),
        ),
      ],
    );
  }
}
