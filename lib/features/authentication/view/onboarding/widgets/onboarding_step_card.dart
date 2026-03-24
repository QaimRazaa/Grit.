import 'package:flutter/material.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/sizes.dart';
import 'package:grit/utils/constants/text_styles.dart';
import 'package:grit/utils/device/responsive_size.dart';

class OnboardingStepCard extends StatelessWidget {
  final String stepNumber;
  final String stepText;

  const OnboardingStepCard({
    super.key,
    required this.stepNumber,
    required this.stepText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: AppSizes.height(GritSizes.size52),
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.width(GritSizes.gap16),
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(
          AppSizes.radius(GritSizes.radius12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Step Number
          Text(
            stepNumber,
            style: AppTextStyles.font18Bold.copyWith(
              color: AppColors.amber,
              fontSize: AppSizes.font(GritSizes.fontSize18),
            ),
          ),
          SizedBox(width: AppSizes.width(GritSizes.gap8)),

          // Step Text
          Text(
            stepText,
            style: AppTextStyles.font15Medium.copyWith(
              color: AppColors.white,
              fontSize: AppSizes.font(GritSizes.fontSize15),
            ),
          ),
        ],
      ),
    );
  }
}
