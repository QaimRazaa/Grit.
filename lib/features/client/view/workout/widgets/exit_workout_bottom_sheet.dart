import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/texts.dart';
import 'package:grit/utils/constants/text_styles.dart';
import 'package:grit/utils/device/responsive_size.dart';

class ExitWorkoutBottomSheet extends StatelessWidget {
  final VoidCallback onEndWorkout;

  const ExitWorkoutBottomSheet({
    super.key,
    required this.onEndWorkout,
  });

  static Future<void> show(BuildContext context, {required VoidCallback onEndWorkout}) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.6), // 60% opacity backdrop
      builder: (ctx) => ExitWorkoutBottomSheet(onEndWorkout: onEndWorkout),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface, // #141414
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        AppSizes.width(24),
        AppSizes.height(8),
        AppSizes.width(24),
        AppSizes.height(24) + MediaQuery.of(context).padding.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: AppSizes.width(40),
            height: AppSizes.height(4),
            decoration: BoxDecoration(
              color: const Color(0xFF3A3A3A),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: AppSizes.height(24)),
          
          Text(
            AppTexts.workoutEndTitle,
            style: AppTextStyles.font20Bold, // 20px Bold
          ),
          SizedBox(height: AppSizes.height(8)),
          Text(
            AppTexts.workoutEndSubtitle,
            style: AppTextStyles.font14Regular.copyWith(
              color: AppColors.muted, // #A3A3A3
            ),
          ),
          SizedBox(height: AppSizes.height(24)),
          
          // Keep Going Button
          GestureDetector(
            onTap: () => context.pop(), // dismiss sheet
            child: Container(
              width: double.infinity,
              height: AppSizes.height(52),
              decoration: BoxDecoration(
                color: AppColors.amber, // #F59E0B
                borderRadius: BorderRadius.circular(AppSizes.radius(14)),
              ),
              child: Center(
                child: Text(
                  AppTexts.workoutKeepGoing,
                  style: AppTextStyles.font15Medium.copyWith(
                    fontWeight: FontWeight.w700, // Bold
                    color: AppColors.background, // #0A0A0A
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: AppSizes.height(10)),
          
          // End Workout Button
          GestureDetector(
            onTap: () {
              context.pop();
              onEndWorkout();
            },
            child: Container(
              width: double.infinity,
              height: AppSizes.height(52),
              decoration: BoxDecoration(
                color: AppColors.surface, // #141414
                borderRadius: BorderRadius.circular(AppSizes.radius(14)),
                border: Border.all(
                  color: AppColors.red, // #EF4444
                  width: AppSizes.width(1),
                ),
              ),
              child: Center(
                child: Text(
                  AppTexts.workoutEndButton,
                  style: AppTextStyles.font15Medium.copyWith(
                    color: AppColors.red,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
