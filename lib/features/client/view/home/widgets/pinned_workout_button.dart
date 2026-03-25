import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grit/core/routes/app_routes.dart';
import 'package:grit/features/client/view/home/home_screen.dart'; // For the enum
import 'package:grit/shared/widgets/button/elevated_button.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/texts.dart';
import 'package:grit/utils/constants/text_styles.dart';
import 'package:grit/utils/device/responsive_size.dart';

class PinnedWorkoutButton extends StatelessWidget {
  final HomeWorkoutState state;

  const PinnedWorkoutButton({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    String titleText;
    Color bgColor;
    VoidCallback? onPressed;
    Color? borderColor;

    switch (state) {
      case HomeWorkoutState.programComplete:
        titleText = AppTexts.homeMessageQaim;
        bgColor = Colors.transparent;
        borderColor = AppColors.amber;
        onPressed = () {};
        return Positioned(
          left: AppSizes.width(20),
          right: AppSizes.width(20),
          bottom: AppSizes.height(12),
          child: CustomElevatedButton(
            text: titleText,
            backgroundColor: bgColor,
            textColor: AppColors.amber,
            borderColor: borderColor,
            borderRadius: 16,
            padding: EdgeInsets.symmetric(vertical: AppSizes.height(18)),
            fontSize: AppSizes.font(14),
            onPressed: onPressed,
          ),
        );
      case HomeWorkoutState.allDone:
        titleText = AppTexts.buttonWorkoutComplete;
        bgColor = AppColors.surface2; // #1F1F1F
        onPressed = null; // not tappable
        return Positioned(
          left: AppSizes.width(20),
          right: AppSizes.width(20),
          bottom: AppSizes.height(12),
          child: CustomElevatedButton(
            text: titleText,
            backgroundColor: bgColor,
            textColor: AppColors.dim, // #555555
            borderRadius: 16,
            padding: EdgeInsets.symmetric(vertical: AppSizes.height(18)),
            fontSize: AppSizes.font(15),
            onPressed: onPressed,
          ),
        );
      case HomeWorkoutState.partiallyLogged:
        titleText = AppTexts.buttonContinueWorkout;
        bgColor = AppColors.amber;
        onPressed = () => context.push(AppRoutes.activeWorkout);
        break;
      case HomeWorkoutState.notStarted:
        titleText = AppTexts.buttonStartWorkout;
        bgColor = AppColors.amber;
        onPressed = () => context.push(AppRoutes.activeWorkout);
        break;
    }

    return Positioned(
      left: AppSizes.width(20),
      right: AppSizes.width(20),
      bottom: AppSizes.height(12),
      child: CustomElevatedButton(
        text: titleText,
        backgroundColor: bgColor,
        textColor: AppColors.background,
        borderRadius: 16,
        padding: EdgeInsets.symmetric(
          vertical: AppSizes.height(18), 
          horizontal: AppSizes.width(16),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  titleText,
                  style: AppTextStyles.font16Bold.copyWith(
                    color: AppColors.background, // #0A0A0A
                    letterSpacing: -0.3,
                  ),
                ),
                SizedBox(height: AppSizes.height(2)),
                Text(
                  AppTexts.homeWorkoutEstimatedTime,
                  style: AppTextStyles.font12Regular.copyWith(
                    color: AppColors.background.withValues(alpha: 0.6), // 60% opacity
                  ),
                ),
              ],
            ),
            Container(
              width: AppSizes.width(40),
              height: AppSizes.width(40),
              decoration: BoxDecoration(
                color: const Color(0x220A0A0A), // 13% opacity black
                borderRadius: BorderRadius.circular(AppSizes.radius(12)),
              ),
              child: Center(
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: AppColors.background,
                  size: AppSizes.font(18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
