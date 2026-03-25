import 'package:flutter/material.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/texts.dart';
import 'package:grit/utils/constants/text_styles.dart';
import 'package:grit/utils/device/responsive_size.dart';

class RestTimerView extends StatelessWidget {
  final int secondsRemaining;
  final int totalRestSeconds;
  final VoidCallback onSkip;

  const RestTimerView({
    super.key,
    required this.secondsRemaining,
    required this.totalRestSeconds,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          AppTexts.workoutRest,
          style: AppTextStyles.font14Regular.copyWith(
            color: AppColors.muted, // #A3A3A3
            letterSpacing: 14 * 0.1, // 0.1em
          ),
        ),
        SizedBox(height: AppSizes.height(32)),
        SizedBox(
          width: AppSizes.width(180),
          height: AppSizes.width(180),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: 1.0,
                strokeWidth: AppSizes.width(8),
                color: AppColors.surface2, // #1F1F1F
              ),
              CircularProgressIndicator(
                value: totalRestSeconds == 0 ? 0 : secondsRemaining / totalRestSeconds,
                strokeWidth: AppSizes.width(8),
                strokeCap: StrokeCap.round,
                color: AppColors.amber, // #F59E0B
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      secondsRemaining.toString(),
                      style: AppTextStyles.font48ExtraBold.copyWith(
                        letterSpacing: -1.0,
                        height: 1.0,
                      ),
                    ),
                    SizedBox(height: AppSizes.height(4)),
                    Text(
                      AppTexts.workoutSeconds,
                      style: AppTextStyles.font12RegularMuted,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: AppSizes.height(40)),
        GestureDetector(
          onTap: onSkip,
          child: Text(
            AppTexts.workoutSkipRest,
            style: AppTextStyles.font13Medium.copyWith(
              color: AppColors.muted, // #A3A3A3
            ),
          ),
        ),
      ],
    );
  }
}
