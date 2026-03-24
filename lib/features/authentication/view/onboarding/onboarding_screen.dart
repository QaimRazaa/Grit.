import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grit/core/routes/app_routes.dart';
import 'package:grit/features/authentication/view/onboarding/widgets/onboarding_dot_indicator.dart';
import 'package:grit/features/authentication/view/onboarding/widgets/onboarding_slide.dart';
import 'package:grit/features/authentication/view/onboarding/widgets/onboarding_step_card.dart';
import 'package:grit/features/authentication/viewmodel/onboarding/onboarding_viewmodel.dart';
import 'package:grit/shared/widgets/button/elevated_button.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/sizes.dart';
import 'package:grit/utils/constants/text_styles.dart';
import 'package:grit/utils/constants/texts.dart';
import 'package:grit/utils/device/responsive_size.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingViewModelProvider);
    final viewModel = ref.read(onboardingViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          PageView(
            controller: viewModel.pageController,
            onPageChanged: viewModel.updatePageIndicator,
            children: [
              const OnboardingSlide(
                abstractShape: _AbstractShape(isCircle: true),
                title: AppTexts.onboardingTitle1,
                subTitle: AppTexts.onboardingSubTitle1,
              ),
              const OnboardingSlide(
                abstractShape: _AbstractShape(isCircle: false),
                title: AppTexts.onboardingTitle2,
                subTitle: AppTexts.onboardingSubTitle2,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.width(GritSizes.gap20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppTexts.onboardingTitle3,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.font24Bold.copyWith(
                        fontSize: AppSizes.font(28.0),
                        color: AppColors.white,
                      ),
                    ),
                    SizedBox(height: AppSizes.height(32.0)),
                    const OnboardingStepCard(
                      stepNumber: '1',
                      stepText: AppTexts.onboardingStep1,
                    ),
                    SizedBox(height: AppSizes.height(8.0)),
                    const OnboardingStepCard(
                      stepNumber: '2',
                      stepText: AppTexts.onboardingStep2,
                    ),
                    SizedBox(height: AppSizes.height(8.0)),
                    const OnboardingStepCard(
                      stepNumber: '3',
                      stepText: AppTexts.onboardingStep3,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + AppSizes.height(10.0),
            right: AppSizes.width(GritSizes.gap20),
            child: TextButton(
              onPressed: () => viewModel.skip(
                onSuccess: () {
                  if (context.mounted) context.go(AppRoutes.signup);
                },
              ),
              child: Text(
                AppTexts.skip,
                style: AppTextStyles.font13RegularAmber.copyWith(
                  color: AppColors.muted,
                  fontSize: AppSizes.font(13.0),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: AppSizes.height(50.0),
            left: AppSizes.width(GritSizes.gap20),
            right: AppSizes.width(GritSizes.gap20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: AppSizes.width(GritSizes.size44),
                ),
                OnboardingDotIndicator(currentPage: state.currentPage),
                if (!state.isLastPage)
                  GestureDetector(
                    onTap: () => viewModel.nextPage(
                      onSuccess: () {
                        if (context.mounted) context.go(AppRoutes.signup);
                      },
                    ),
                    child: Container(
                      width: AppSizes.width(GritSizes.size44),
                      height: AppSizes.width(GritSizes.size44),
                      decoration: const BoxDecoration(
                        color: AppColors.amber,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.background,
                        size: AppSizes.icon(GritSizes.size20),
                      ),
                    ),
                  )
                else
                  SizedBox(
                    width: AppSizes.width(GritSizes.size44),
                  ),
              ],
            ),
          ),
          if (state.isLastPage)
            Positioned(
              bottom: AppSizes.height(20.0),
              left: AppSizes.width(GritSizes.gap20),
              right: AppSizes.width(GritSizes.gap20),
              child: CustomElevatedButton(
                text: AppTexts.getStarted,
                textColor: AppColors.background,
                backgroundColor: AppColors.amber,
                onPressed: () => viewModel.finishOnboarding(
                  onSuccess: () {
                    if (context.mounted) context.go(AppRoutes.signup);
                  },
                ),
                width: double.infinity,
                height: GritSizes.size52,
                borderRadius: GritSizes.radius12,
                fontSize: AppSizes.font(15.0),
              ),
            ),
        ],
      ),
    );
  }
}

class _AbstractShape extends StatelessWidget {
  final bool isCircle;

  const _AbstractShape({required this.isCircle});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        border: Border.all(
          color: AppColors.amber,
          width: GritSizes.borderWidth1,
        ),
        borderRadius: isCircle
            ? null
            : BorderRadius.circular(AppSizes.radius(20.0)),
      ),
    );
  }
}
