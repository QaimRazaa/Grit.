import 'package:flutter/material.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/texts.dart';
import 'package:grit/utils/constants/text_styles.dart';
import 'package:grit/utils/device/responsive_size.dart';

class LogSetButton extends StatelessWidget {
  final int currentSet;
  final int totalSets;
  final String exerciseName;
  final bool isLoggingSet;
  final VoidCallback onLogSet;

  const LogSetButton({
    super.key,
    required this.currentSet,
    required this.totalSets,
    required this.exerciseName,
    required this.isLoggingSet,
    required this.onLogSet,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoggingSet ? null : onLogSet,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: AppSizes.width(24)),
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.width(20),
          vertical: AppSizes.height(20),
        ),
        decoration: BoxDecoration(
          color: AppColors.amber, // #F59E0B
          borderRadius: BorderRadius.circular(AppSizes.radius(16)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Log Set $currentSet',
                  style: AppTextStyles.font16Bold.copyWith(
                    color: AppColors.background, // #0A0A0A
                    letterSpacing: -0.3,
                  ),
                ),
                SizedBox(height: AppSizes.height(2)),
                Text(
                  '${AppTexts.workoutSet} $currentSet ${AppTexts.workoutOf} $totalSets — $exerciseName',
                  style: AppTextStyles.font12Regular.copyWith(
                    color: AppColors.background.withOpacity(0.6), // 60% opacity
                  ),
                ),
              ],
            ),
            Container(
              width: AppSizes.width(40),
              height: AppSizes.width(40),
              decoration: BoxDecoration(
                color: const Color(0x220A0A0A), // #0A0A0A at 13% capacity
                borderRadius: BorderRadius.circular(AppSizes.radius(12)),
              ),
              child: Center(
                child: isLoggingSet 
                    ? SizedBox(
                        width: AppSizes.width(18),
                        height: AppSizes.width(18),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.background,
                        ),
                      )
                    : Icon(
                        Icons.check_rounded,
                        color: AppColors.background,
                        size: AppSizes.font(18),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
