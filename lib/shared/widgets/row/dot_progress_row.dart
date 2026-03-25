import 'package:flutter/material.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/device/responsive_size.dart';

/// A row of small dot/pill indicators showing progress steps.
/// Used in body weight/fat cards, etc.
class DotProgressRow extends StatelessWidget {
  final int totalDots;
  final int filledDots;
  final Color activeColor;
  final Color inactiveColor;

  const DotProgressRow({
    super.key,
    required this.totalDots,
    required this.filledDots,
    this.activeColor = AppColors.amber,
    this.inactiveColor = AppColors.borderDefault,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalDots, (index) {
        return Padding(
          padding: EdgeInsets.only(
            left: index == 0 ? 0 : AppSizes.width(4),
          ),
          child: Container(
            width: AppSizes.width(20),
            height: AppSizes.height(4),
            decoration: BoxDecoration(
              color: index < filledDots ? activeColor : inactiveColor,
              borderRadius: BorderRadius.circular(AppSizes.radius(2)),
            ),
          ),
        );
      }),
    );
  }
}
