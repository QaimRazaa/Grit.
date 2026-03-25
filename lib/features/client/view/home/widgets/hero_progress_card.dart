import 'package:flutter/material.dart';
import 'package:grit/shared/widgets/card/surface_card.dart';
import 'package:grit/shared/widgets/progress/progress_ring_painter.dart';
import 'package:grit/shared/widgets/row/icon_stat_row.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/texts.dart';
import 'package:grit/utils/constants/text_styles.dart';
import 'package:grit/utils/device/responsive_size.dart';

class HeroProgressCard extends StatelessWidget {
  final int calories;
  final int workouts;
  final String totalTime;
  final double progress;

  const HeroProgressCard({
    super.key,
    this.calories = 0,
    this.workouts = 0,
    this.totalTime = '0H 0M',
    this.progress = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    final int progressPercent = (progress * 100).round();
    
    return SurfaceCard(
      borderRadius: 20,
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.width(16),
        vertical: AppSizes.height(16),
      ),
      boxShadow: [
        BoxShadow(
          color: AppColors.amber.withValues(alpha: 0.06),
          blurRadius: AppSizes.width(20),
          spreadRadius: 0,
        ),
      ],
      child: Row(
        children: [
          // LEFT — Circular progress ring
          Container(
            width: AppSizes.width(90),
            height: AppSizes.width(90),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.amber.withValues(alpha: 0.15),
                  blurRadius: AppSizes.width(20),
                ),
              ],
            ),
            child: CustomPaint(
              painter: ProgressRingPainter(progress: progress, strokeWidth: 8),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$progressPercent%',
                      style: AppTextStyles.font18Bold.copyWith(
                        color: AppColors.amber,
                      ),
                    ),
                    Text(
                      AppTexts.heroWeeklyGoal,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.font10Regular.copyWith(
                        color: AppColors.muted,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: AppSizes.width(20)),

          // RIGHT — 3 stat rows using shared IconStatRow
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconStatRow(
                  icon: Icons.local_fire_department_rounded,
                  value: calories.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                  label: AppTexts.heroKcalBurned,
                  valueColor: AppColors.amber,
                ),
                SizedBox(height: AppSizes.height(12)),
                IconStatRow(
                  icon: Icons.fitness_center,
                  value: workouts.toString(),
                  label: AppTexts.heroWorkouts,
                  valueColor: AppColors.amber,
                ),
                SizedBox(height: AppSizes.height(12)),
                IconStatRow(
                  icon: Icons.timer_outlined,
                  value: totalTime,
                  label: AppTexts.heroTotalTime,
                  valueColor: AppColors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
