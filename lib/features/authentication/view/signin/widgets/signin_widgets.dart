import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grit/core/routes/app_routes.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/sizes.dart';
import 'package:grit/utils/constants/text_styles.dart';
import 'package:grit/utils/constants/texts.dart';
import 'package:grit/utils/device/responsive_size.dart';
import 'package:grit/utils/helpers/ui_helper.dart';

class SigninForgotPasswordLink extends ConsumerWidget {
  const SigninForgotPasswordLink({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () => UIHelper.showComingSoon(context, AppTexts.forgotPassword),
        child: Text(
          AppTexts.forgotPassword,
          style: AppTextStyles.font13RegularAmber.copyWith(
            fontSize: AppSizes.font(GritSizes.fontSize13),
          ),
        ),
      ),
    );
  }
}

class SigninSignupLink extends ConsumerWidget {
  const SigninSignupLink({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: GestureDetector(
        onTap: () => context.go(AppRoutes.signup),
        child: RichText(
          text: TextSpan(
            text: '${AppTexts.signupPromptText} ',
            style: AppTextStyles.font13RegularAmber.copyWith(
              color: AppColors.muted,
              fontSize: AppSizes.font(GritSizes.fontSize13),
            ),
            children: [
              TextSpan(
                text: AppTexts.signupLinkText,
                style: AppTextStyles.font13RegularAmber.copyWith(
                  color: AppColors.amber,
                  fontSize: AppSizes.font(GritSizes.fontSize13),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
