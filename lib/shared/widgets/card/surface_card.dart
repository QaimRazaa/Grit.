import 'package:flutter/material.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/device/responsive_size.dart';

/// A reusable dark surface card container used throughout the app.
/// Standard #141414 background with #2A2A2A border, configurable radius/padding.
class SurfaceCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final List<BoxShadow>? boxShadow;

  const SurfaceCard({
    super.key,
    required this.child,
    this.borderRadius = 16,
    this.padding,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ??
          EdgeInsets.symmetric(
            horizontal: AppSizes.width(16),
            vertical: AppSizes.height(14),
          ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radius(borderRadius)),
        border: Border.all(color: AppColors.borderDefault, width: 1),
        boxShadow: boxShadow,
      ),
      child: child,
    );
  }
}
