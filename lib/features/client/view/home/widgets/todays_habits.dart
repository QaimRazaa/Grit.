import 'package:flutter/material.dart';
import 'package:grit/shared/widgets/progress/progress_ring_painter.dart';
import 'package:grit/shared/widgets/section/section_header.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/texts.dart';
import 'package:grit/utils/constants/text_styles.dart';
import 'package:grit/utils/device/responsive_size.dart';

class TodaysHabits extends StatelessWidget {
  const TodaysHabits({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: AppTexts.todaysHabits,
          titleStyle: AppTextStyles.font16SemiBold,
        ),
        SizedBox(height: AppSizes.height(16)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            _HabitCircle(
              icon: Icons.water_drop_outlined,
              value: '6/8',
              label: AppTexts.habitGlasses,
              progress: 0.75,
            ),
            _HabitCircle(
              icon: Icons.bedtime_outlined,
              value: '7.5h',
              label: AppTexts.habitSleep,
              progress: 0.94,
            ),
            _HabitCircle(
              icon: Icons.restaurant_outlined,
              value: '1,800/\n2.4k',
              label: AppTexts.habitKcal,
              progress: 0.75,
            ),
          ],
        ),
      ],
    );
  }
}

class _HabitCircle extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final double progress;

  const _HabitCircle({
    required this.icon,
    required this.value,
    required this.label,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSizes.width(80),
      height: AppSizes.width(80),
      child: CustomPaint(
        painter: ProgressRingPainter(progress: progress, strokeWidth: 5),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: AppSizes.font(14), color: AppColors.amber),
              SizedBox(height: AppSizes.height(2)),
              Text(
                value,
                textAlign: TextAlign.center,
                style: AppTextStyles.font12Regular.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                ),
              ),
              Text(
                label,
                style: AppTextStyles.font10Regular.copyWith(
                  color: AppColors.muted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
