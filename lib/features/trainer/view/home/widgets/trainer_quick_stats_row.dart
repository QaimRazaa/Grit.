import 'package:flutter/material.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/texts.dart';
import 'package:grit/utils/constants/text_styles.dart';
import 'package:grit/utils/device/responsive_size.dart';

class TrainerQuickStatsRow extends StatelessWidget {
  final int totalClients;
  final int activeToday;
  final int alertsCount;

  const TrainerQuickStatsRow({
    super.key,
    required this.totalClients,
    required this.activeToday,
    required this.alertsCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: AppTexts.trainerActiveClients,
            value: totalClients.toString(),
            icon: Icons.people_outline_rounded,
            color: AppColors.amber,
          ),
        ),
        SizedBox(width: AppSizes.width(10)),
        Expanded(
          child: _StatCard(
            label: AppTexts.trainerSessionsToday,
            value: activeToday.toString(),
            icon: Icons.fitness_center_rounded,
            color: AppColors.green,
          ),
        ),
        SizedBox(width: AppSizes.width(10)),
        Expanded(
          child: _StatCard(
            label: AppTexts.trainerNeedAttention,
            value: alertsCount.toString(),
            icon: Icons.warning_amber_rounded,
            color: AppColors.red,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.width(14)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radius(16)),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(AppSizes.width(6)),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSizes.radius(8)),
            ),
            child: Icon(
              icon,
              color: color,
              size: AppSizes.font(16),
            ),
          ),
          SizedBox(height: AppSizes.height(12)),
          Text(
            value,
            style: AppTextStyles.font22Bold.copyWith(
              color: AppColors.white,
              height: 1,
            ),
          ),
          SizedBox(height: AppSizes.height(4)),
          Text(
            label,
            style: AppTextStyles.font10Regular.copyWith(
              color: AppColors.muted,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
