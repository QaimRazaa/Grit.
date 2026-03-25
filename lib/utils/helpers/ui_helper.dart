import 'package:flutter/material.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/text_styles.dart';

class UIHelper {
  static void showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.surface2,
        content: Text(
          '$feature coming soon!',
          style: AppTextStyles.font14Regular.copyWith(color: AppColors.white),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  UIHelper._();
}
