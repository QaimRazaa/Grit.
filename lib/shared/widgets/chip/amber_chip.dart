import 'package:flutter/material.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/text_styles.dart';
import 'package:grit/utils/device/responsive_size.dart';

/// A reusable amber-tinted chip used across the app.
/// Works for muscle group tags, status badges, etc.
class AmberChip extends StatelessWidget {
  final String label;
  final double letterSpacing;
  final EdgeInsetsGeometry? padding;

  const AmberChip({
    super.key,
    required this.label,
    this.letterSpacing = 0.8,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ??
          EdgeInsets.symmetric(
            horizontal: AppSizes.width(12),
            vertical: AppSizes.height(6),
          ),
      decoration: BoxDecoration(
        color: AppColors.amber.withOpacity(0.12),
        borderRadius: BorderRadius.circular(AppSizes.radius(20)),
        border: Border.all(
          color: AppColors.amber.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: AppTextStyles.font10SemiBold.copyWith(
          color: AppColors.amber,
          letterSpacing: letterSpacing,
        ),
      ),
    );
  }
}
