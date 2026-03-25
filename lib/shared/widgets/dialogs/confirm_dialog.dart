import 'package:flutter/material.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/text_styles.dart';
import 'package:grit/utils/device/responsive_size.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final Color? confirmColor;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    required this.onConfirm,
    this.confirmColor,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radius(24)),
        side: BorderSide(color: AppColors.borderDefault),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.width(24),
          vertical: AppSizes.height(28),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon or Illustration (optional)
            // Container(
            //   padding: EdgeInsets.all(AppSizes.width(16)),
            //   decoration: BoxDecoration(
            //     color: (confirmColor ?? AppColors.amber).withValues(alpha: 0.1),
            //     shape: BoxShape.circle,
            //   ),
            //   child: Icon(
            //     Icons.help_outline_rounded,
            //     color: confirmColor ?? AppColors.amber,
            //     size: AppSizes.font(32),
            //   ),
            // ),
            // SizedBox(height: AppSizes.height(20)),
            Text(
              title,
              style: AppTextStyles.font18Bold,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSizes.height(12)),
            Text(
              message,
              style: AppTextStyles.font14RegularMuted,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSizes.height(20)),

            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: AppSizes.height(14),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppSizes.radius(12),
                        ),
                        side: BorderSide(color: AppColors.borderDefault),
                      ),
                    ),
                    child: Text(
                      cancelText,
                      style: AppTextStyles.font14Regular.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: AppSizes.width(12)),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onConfirm();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: confirmColor ?? AppColors.amber,
                      padding: EdgeInsets.symmetric(
                        vertical: AppSizes.height(14),
                      ),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppSizes.radius(12),
                        ),
                      ),
                    ),
                    child: Text(
                      confirmText,
                      style: AppTextStyles.font14Regular.copyWith(
                        color:
                            (confirmColor ?? AppColors.amber) == AppColors.amber
                            ? AppColors.background
                            : AppColors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    required VoidCallback onConfirm,
    Color? confirmColor,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierColor: AppColors.background.withValues(alpha: 0.8),
      builder: (context) => ConfirmDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        confirmColor: confirmColor,
      ),
    );
  }
}
