import 'package:flutter/material.dart';
import 'package:grit/shared/widgets/icon/amber_icon_box.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/texts.dart';
import 'package:grit/utils/constants/text_styles.dart';
import 'package:grit/utils/device/responsive_size.dart';

class CoachInsight extends StatelessWidget {
  const CoachInsight({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radius(16)),
        border: Border.all(color: AppColors.borderDefault, width: 1),
      ),
      child: Stack(
        children: [
          // Left accent bar
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: AppSizes.width(3),
              color: AppColors.amber,
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.only(
              left: AppSizes.width(3) + AppSizes.width(16),
              right: AppSizes.width(16),
              top: AppSizes.height(16),
              bottom: AppSizes.height(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Shared amber icon box
                const AmberIconBox(icon: Icons.psychology_outlined),
                SizedBox(width: AppSizes.width(12)),

                // Text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppTexts.coachInsightLabel,
                        style: AppTextStyles.font10SemiBold.copyWith(
                          color: AppColors.amber,
                          letterSpacing: 0.8,
                        ),
                      ),
                      SizedBox(height: AppSizes.height(6)),
                      Text(
                        AppTexts.coachInsightMessage,
                        style: AppTextStyles.font13Regular.copyWith(
                          color: AppColors.muted,
                        ),
                        maxLines: 4,
                      ),
                      SizedBox(height: AppSizes.height(10)),
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          AppTexts.coachInsightDismiss,
                          style: AppTextStyles.font13Regular.copyWith(
                            color: AppColors.amber,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
