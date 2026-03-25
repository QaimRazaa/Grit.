import 'package:flutter/material.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/text_styles.dart';
import 'package:grit/utils/device/responsive_size.dart';
import 'package:grit/shared/widgets/button/elevated_button.dart';

class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? buttonText;
  final VoidCallback? onButtonPressed;

  const EmptyStateWidget({
    super.key,
    this.icon = Icons.hourglass_empty_rounded,
    required this.title,
    required this.message,
    this.buttonText,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSizes.width(40)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon with subtle glow
            Container(
              padding: EdgeInsets.all(AppSizes.width(20)),
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.borderDefault,
                  width: 1.5,
                ),
              ),
              child: Icon(
                icon,
                size: AppSizes.font(48),
                color: AppColors.dim,
              ),
            ),
            SizedBox(height: AppSizes.height(24)),
            
            // Title
            Text(
              title,
              style: AppTextStyles.font18SemiBold.copyWith(
                color: AppColors.white,
                letterSpacing: -0.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSizes.height(12)),
            
            // Message
            Text(
              message,
              style: AppTextStyles.font14Regular.copyWith(
                color: AppColors.muted,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            
            if (buttonText != null && onButtonPressed != null) ...[
              SizedBox(height: AppSizes.height(32)),
              CustomElevatedButton(
                text: buttonText!,
                onPressed: onButtonPressed!,
                backgroundColor: AppColors.amber,
                textColor: AppColors.background,
                borderRadius: 12,
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.width(24),
                  vertical: AppSizes.height(14),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
