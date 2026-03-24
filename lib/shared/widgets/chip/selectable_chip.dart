import 'package:flutter/material.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/sizes.dart';
import 'package:grit/utils/constants/text_styles.dart';
import 'package:grit/utils/device/responsive_size.dart';

class SelectableChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final double? width;

  const SelectableChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppSizes.height(36.0),
        width: width != null ? AppSizes.width(width!) : null,
        padding: EdgeInsets.symmetric(
          horizontal: width == null ? AppSizes.width(GritSizes.gap16) : 0,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface, // #141414
          borderRadius: BorderRadius.circular(
            AppSizes.radius(GritSizes.radius12),
          ),
          border: Border.all(
            color: isSelected ? AppColors.amber : AppColors.borderDefault, // #F59E0B / #2A2A2A
            width: GritSizes.borderWidth1,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTextStyles.font13Regular.copyWith(
            color: isSelected ? AppColors.amber : AppColors.muted, // #F59E0B / #A3A3A3
          ),
        ),
      ),
    );
  }
}
