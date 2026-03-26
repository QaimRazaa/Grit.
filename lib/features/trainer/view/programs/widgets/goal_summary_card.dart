import 'package:flutter/material.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/text_styles.dart';
import 'package:grit/utils/device/responsive_size.dart';

class GoalSummaryCard extends StatelessWidget {
  final int goalDays;
  final String goal;
  final String level;
  final int duration;
  final String? injuries;

  const GoalSummaryCard({
    super.key,
    required this.goalDays,
    required this.goal,
    required this.level,
    required this.duration,
    this.injuries,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSizes.paddingAll(14),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSizes.radius(12)),
        border: Border.all(color: AppColors.borderDefault, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'GOAL SUMMARY',
            style: AppTextStyles.font10SemiBold.copyWith(
              color: AppColors.dim,
              letterSpacing: 0.8,
            ),
          ),
          SizedBox(height: AppSizes.height(12)),
          // 2x2 grid of stat chips
          Column(
            children: [
              Row(
                children: [
                  Expanded(child: _GoalChip(label: 'Days/Week', value: '$goalDays')),
                  SizedBox(width: AppSizes.width(8)),
                  Expanded(child: _GoalChip(label: 'Goal', value: goal)),
                ],
              ),
              SizedBox(height: AppSizes.height(8)),
              Row(
                children: [
                   Expanded(child: _GoalChip(label: 'Level', value: level)),
                   SizedBox(width: AppSizes.width(8)),
                   Expanded(child: _GoalChip(label: 'Duration', value: '${duration} Weeks')),
                ],
              ),
              if (injuries != null && injuries!.isNotEmpty) ...[
                SizedBox(height: AppSizes.height(12)),
                Container(
                  padding: AppSizes.paddingAll(10),
                  decoration: BoxDecoration(
                    color: AppColors.red.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(AppSizes.radius(8)),
                    border: Border.all(color: AppColors.red.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_rounded, color: AppColors.amber, size: 16),
                      SizedBox(width: AppSizes.width(8)),
                      Expanded(
                        child: Text(
                          injuries!,
                          style: AppTextStyles.font12Regular.copyWith(color: AppColors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _GoalChip extends StatelessWidget {
  final String label;
  final String value;

  const _GoalChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.width(12),
        vertical: AppSizes.height(10),
      ),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.circular(AppSizes.radius(8)),
        border: Border.all(color: AppColors.borderDefault, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.font10Regular.copyWith(color: AppColors.muted),
          ),
          SizedBox(height: AppSizes.height(4)),
          Text(
            value,
            style: AppTextStyles.font13Regular.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.amber,
            ),
          ),
        ],
      ),
    );
  }
}
