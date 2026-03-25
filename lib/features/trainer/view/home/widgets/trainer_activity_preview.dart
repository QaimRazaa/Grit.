import 'package:flutter/material.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/texts.dart';
import 'package:grit/utils/constants/text_styles.dart';
import 'package:grit/utils/device/responsive_size.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:go_router/go_router.dart';
import 'package:grit/core/routes/app_routes.dart';

class TrainerActivityPreview extends StatelessWidget {
  final List<Map<String, dynamic>> activity;

  const TrainerActivityPreview({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    if (activity.isEmpty) return const SizedBox.shrink();

    // Show only 3 most recent
    final displayActivity = activity.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Activity',
              style: AppTextStyles.font16Bold,
            ),
            GestureDetector(
              onTap: () => context.push(AppRoutes.trainerLogs),
              child: Text(
                AppTexts.viewAll,
                style: AppTextStyles.font12Regular.copyWith(
                  color: AppColors.amber,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: AppSizes.height(14)),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.width(16),
            vertical: AppSizes.height(8),
          ),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSizes.radius(16)),
            border: Border.all(color: AppColors.borderDefault, width: 1),
          ),
          child: Column(
            children: displayActivity.asMap().entries.map((entry) {
              final idx = entry.key;
              final log = entry.value;
              final clientName = log['client_name'] ?? 'Client';
              final exerciseName = log['exercise_name'] ?? 'Exercise';
              final timestamp = log['created_at'] != null 
                  ? DateTime.parse(log['created_at'] as String)
                  : DateTime.now();

              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSizes.height(8)),
                    child: Row(
                      children: [
                        Container(
                          width: AppSizes.width(36),
                          height: AppSizes.width(36),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.surface2,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.fitness_center_rounded,
                              color: AppColors.amber,
                              size: AppSizes.font(16),
                            ),
                          ),
                        ),
                        SizedBox(width: AppSizes.width(12)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  style: AppTextStyles.font13Regular.copyWith(
                                    color: AppColors.white,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: clientName,
                                      style: const TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                    const TextSpan(text: ' logged '),
                                    TextSpan(
                                      text: exerciseName,
                                      style: const TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: AppSizes.height(2)),
                              Text(
                                timeago.format(timestamp),
                                style: AppTextStyles.font10Regular.copyWith(
                                  color: AppColors.muted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (idx < displayActivity.length - 1)
                    Divider(color: AppColors.borderDefault, height: 1),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
