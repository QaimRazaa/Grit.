import 'package:flutter/material.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/texts.dart';
import 'package:grit/utils/constants/text_styles.dart';
import 'package:grit/utils/device/responsive_size.dart';
import 'package:grit/core/routes/app_routes.dart';
import 'package:go_router/go_router.dart';

class TrainerQuickActionsGrid extends StatelessWidget {
  const TrainerQuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppTexts.trainerQuickActions,
          style: AppTextStyles.font11RegularDim.copyWith(letterSpacing: 0.8),
        ),
        SizedBox(height: AppSizes.height(12)),
        // 2x2 grid
        Column(
          children: [
            _ActionTile(
              label: AppTexts.trainerAssignWorkout,
              icon: Icons.edit_calendar_outlined,
              isPrimary: true,
              onTap: () => context.push(AppRoutes.programBuilder),
            ),
            SizedBox(height: AppSizes.height(10)),
            _ActionTile(
              label: AppTexts.trainerViewLogs,
              icon: Icons.bar_chart_rounded,
              isPrimary: false,
              onTap: () => context.push(AppRoutes.trainerLogs),
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isPrimary;
  final VoidCallback onTap;

  const _ActionTile({
    required this.label,
    required this.icon,
    required this.isPrimary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppSizes.height(88),
        width: double.infinity,
        padding: EdgeInsets.all(AppSizes.width(14)),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radius(16)),
          border: Border.all(
            color: isPrimary
                ? AppColors.amber.withValues(alpha: 0.25)
                : AppColors.borderDefault,
            width: 1,
          ),
          boxShadow: isPrimary
              ? [
                  BoxShadow(
                    color: AppColors.amber.withValues(alpha: 0.08),
                    blurRadius: AppSizes.width(16),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              icon,
              color: isPrimary ? AppColors.amber : AppColors.muted,
              size: AppSizes.font(22),
            ),
            Text(
              label, // TODO: move to AppTexts
              style: AppTextStyles.font13Regular.copyWith(
                color: isPrimary ? AppColors.white : AppColors.muted,
              ),
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
