import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grit/shared/widgets/button/elevated_button.dart';
import 'package:grit/shared/widgets/progress/app_progress_bar.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/sizes.dart';
import 'package:grit/utils/constants/text_styles.dart';
import 'package:grit/utils/device/responsive_size.dart';

class GoalLayoutWrapper extends StatelessWidget {
  final int step;
  final double progress;
  final bool showBackArrow;
  final Widget child;
  final String buttonText;
  final bool isButtonActive;
  final bool isButtonLoading;
  final VoidCallback? onButtonPressed;

  const GoalLayoutWrapper({
    super.key,
    required this.step,
    required this.progress,
    this.showBackArrow = true,
    required this.child,
    required this.buttonText,
    required this.isButtonActive,
    this.isButtonLoading = false,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Progress Bar
            AppProgressBar(progress: progress),

            // Header Row (Back Arrow & Step Label)
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.width(GritSizes.gap20),
              ).copyWith(top: AppSizes.height(GritSizes.gap16)),
              child: Row(
                children: [
                  if (showBackArrow)
                    GestureDetector(
                      onTap: () {
                        if (context.canPop()) {
                          context.pop();
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: AppSizes.width(GritSizes.gap16),
                        ),
                        child: Icon(
                          Icons.arrow_back,
                          color: AppColors.muted,
                          size: AppSizes.icon(GritSizes.size20),
                        ),
                      ),
                    ),
                  Text(
                    'STEP $step OF 4',
                    style: AppTextStyles.font11RegularDim.copyWith(
                      color: AppColors.muted,
                      letterSpacing: 11.0 * 0.08, // 0.08em -> pixels
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.width(GritSizes.gap20),
                ),
                child: child,
              ),
            ),

            // Pinned Bottom Button
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSizes.width(GritSizes.gap20),
                AppSizes.height(GritSizes.gap16),
                AppSizes.width(GritSizes.gap20),
                AppSizes.height(GritSizes.gap20),
              ),
              child: CustomElevatedButton(
                text: buttonText,
                textColor: isButtonActive
                    ? AppColors.background
                    : AppColors.dim,
                backgroundColor: isButtonActive
                    ? AppColors.amber
                    : AppColors.surface2,
                onPressed: (isButtonActive && !isButtonLoading)
                    ? onButtonPressed
                    : null,
                width: double.infinity,
                height: GritSizes.size52,
                borderRadius: GritSizes.radius12,
                fontSize: AppSizes.font(GritSizes.fontSize15),
                child: isButtonLoading
                    ? SizedBox(
                        height: AppSizes.height(20.0),
                        width: AppSizes.width(20.0),
                        child: const CircularProgressIndicator(
                          color: AppColors.white,
                          strokeWidth: 2.0,
                        ),
                      )
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
