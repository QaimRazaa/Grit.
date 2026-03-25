import 'package:flutter/material.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/text_styles.dart';
import 'package:grit/utils/device/responsive_size.dart';
import 'package:grit/core/routes/app_routes.dart';
import 'package:go_router/go_router.dart';

class ProgramCard extends StatelessWidget {
  final String? id;
  final String name;
  final int days;
  final String level;
  final int workoutCount;
  final int exerciseCount;
  final VoidCallback? onDelete;

  const ProgramCard({
    super.key,
    this.id,
    required this.name,
    required this.days,
    required this.level,
    required this.workoutCount,
    required this.exerciseCount,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.programBuilder),
      child: Container(
        margin: EdgeInsets.only(bottom: AppSizes.height(10)),
        padding: AppSizes.paddingAll(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radius(16)),
          border: Border.all(color: AppColors.borderDefault, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: AppTextStyles.font16Bold),
                  SizedBox(height: AppSizes.height(8)),
                  Row(
                    children: [
                      _TagChip(label: '$days Days'),
                      SizedBox(width: AppSizes.width(8)),
                      _TagChip(label: level),
                    ],
                  ),
                  SizedBox(height: AppSizes.height(8)),
                  Text(
                    '$workoutCount workouts · $exerciseCount exercises',
                    style: AppTextStyles.font12RegularMuted,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.dim,
              size: AppSizes.font(20),
            ),
          ],
        ),
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String label;

  const _TagChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.width(10),
        vertical: AppSizes.height(5),
      ),
      decoration: BoxDecoration(
        color: AppColors.amber.withOpacity(0.12),
        borderRadius: BorderRadius.circular(AppSizes.radius(20)),
        border: Border.all(
          color: AppColors.amber.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: AppTextStyles.font10SemiBold.copyWith(color: AppColors.amber),
      ),
    );
  }
}
