import 'package:flutter/material.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/device/responsive_size.dart';

/// A reusable amber-tinted icon container used across the app.
/// Used in CoachInsight, ExerciseCard active/done states, etc.
class AmberIconBox extends StatelessWidget {
  final IconData icon;
  final double size;
  final double iconSize;
  final double borderRadius;

  const AmberIconBox({
    super.key,
    required this.icon,
    this.size = 36,
    this.iconSize = 18,
    this.borderRadius = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.width(size),
      height: AppSizes.width(size),
      decoration: BoxDecoration(
        color: AppColors.amber.withOpacity(0.12),
        borderRadius: BorderRadius.circular(AppSizes.radius(borderRadius)),
        border: Border.all(
          color: AppColors.amber.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Center(
        child: Icon(
          icon,
          color: AppColors.amber,
          size: AppSizes.font(iconSize),
        ),
      ),
    );
  }
}
