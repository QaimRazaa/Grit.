import 'package:flutter/material.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/sizes.dart';
import 'package:grit/utils/constants/text_styles.dart';
import 'package:grit/utils/device/responsive_size.dart';

class OnboardingSlide extends StatelessWidget {
  final Widget abstractShape;
  final String title;
  final String subTitle;

  const OnboardingSlide({
    super.key,
    required this.abstractShape,
    required this.title,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.width(GritSizes.gap20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Abstract Shape
          SizedBox(
            width: AppSizes.width(GritSizes.size120),
            height: AppSizes.height(GritSizes.size120),
            child: abstractShape,
          ),

          SizedBox(height: AppSizes.height(GritSizes.gap32)),

          // Title
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.font24Bold.copyWith(
              fontSize: AppSizes.font(28.0), // Specific for onboarding
              color: AppColors.white,
            ),
          ),

          SizedBox(height: AppSizes.height(GritSizes.gap12)),

          // Subtitle
          Text(
            subTitle,
            textAlign: TextAlign.center,
            style: AppTextStyles.font14Regular.copyWith(
              fontSize: AppSizes.font(15.0), // Specific for onboarding
              color: AppColors.muted,
            ),
          ),
        ],
      ),
    );
  }
}
