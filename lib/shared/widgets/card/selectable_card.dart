import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/sizes.dart';
import 'package:grit/utils/constants/text_styles.dart';
import 'package:grit/utils/device/responsive_size.dart';

class SelectableCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectableCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppSizes.height(68.0),
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.width(GritSizes.gap16),
        ),
        decoration: BoxDecoration(
          color: AppColors.surface, // #141414
          borderRadius: BorderRadius.circular(AppSizes.radius(GritSizes.radius12)),
          border: Border.all(
            color: isSelected ? AppColors.amber : AppColors.borderDefault,
            width: GritSizes.borderWidth1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.font15Medium.copyWith(
                      color: AppColors.white,
                      fontSize: AppSizes.font(GritSizes.fontSize15),
                    ),
                  ),
                  SizedBox(height: AppSizes.height(4.0)),
                  Text(
                    subtitle,
                    style: AppTextStyles.font12RegularMuted.copyWith(
                      fontSize: AppSizes.font(GritSizes.fontSize12),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: AppSizes.height(GritSizes.size20),
              height: AppSizes.height(GritSizes.size20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.amber : Colors.transparent,
                border: isSelected
                    ? null
                    : Border.all(
                        color: AppColors.borderDefault,
                        width: GritSizes.borderWidth1,
                      ),
              ),
              child: isSelected
                  ? Icon(
                      CupertinoIcons.checkmark_alt,
                      color: AppColors.white,
                      size: AppSizes.icon(14.0),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
