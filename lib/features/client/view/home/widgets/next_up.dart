import 'package:flutter/material.dart';
import 'package:grit/shared/widgets/chip/amber_chip.dart';
import 'package:grit/shared/widgets/section/section_header.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/texts.dart';
import 'package:grit/utils/constants/text_styles.dart';
import 'package:grit/utils/device/responsive_size.dart';

class NextUp extends StatelessWidget {
  const NextUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: AppTexts.nextUp),
        SizedBox(height: AppSizes.height(12)),
        Container(
          height: AppSizes.height(90),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSizes.radius(16)),
            border: Border.all(color: AppColors.borderDefault, width: 1),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.width(16),
              vertical: AppSizes.height(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Left content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AmberChip(
                        label: AppTexts.tomorrow,
                        letterSpacing: 0.6,
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSizes.width(8),
                          vertical: AppSizes.height(4),
                        ),
                      ),
                      SizedBox(height: AppSizes.height(8)),
                      Text(
                        AppTexts.nextWorkoutName,
                        style: AppTextStyles.font16Bold,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                SizedBox(width: AppSizes.width(12)),

                // Right — Calendar mini
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.width(10),
                    vertical: AppSizes.height(8),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface2,
                    borderRadius: BorderRadius.circular(AppSizes.radius(10)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        color: AppColors.muted,
                        size: AppSizes.font(12),
                      ),
                      SizedBox(height: AppSizes.height(2)),
                      Text(
                        'MAY',
                        style: AppTextStyles.font10Regular.copyWith(
                          color: AppColors.muted,
                        ),
                      ),
                      Text(
                        '24',
                        style: AppTextStyles.font12Regular.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
