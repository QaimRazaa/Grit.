import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grit/features/client/viewmodel/home/home_viewmodel.dart';
import 'package:grit/shared/widgets/card/surface_card.dart';
import 'package:grit/shared/widgets/row/dot_progress_row.dart';
import 'package:grit/shared/widgets/row/mini_bar_chart.dart';
import 'package:grit/shared/widgets/section/section_header.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/texts.dart';
import 'package:grit/utils/constants/text_styles.dart';
import 'package:grit/utils/device/responsive_size.dart';

class YourProgress extends ConsumerWidget {
  const YourProgress({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeViewModelProvider);
    
    // Generate last 7 days data points
    final today = DateTime.now();
    final List<double> dataPoints = [];
    for (int i = 6; i >= 0; i--) {
      final date = today.subtract(Duration(days: i)).toIso8601String().split('T')[0];
      dataPoints.add(state.weeklyExerciseCounts[date]?.toDouble() ?? 0.0);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: AppTexts.yourProgress,
          actionText: AppTexts.viewAll,
          onAction: () {},
        ),
        SizedBox(height: AppSizes.height(16)),

        // A) Strength Trend card
        SurfaceCard(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppTexts.strengthTrend,
                    style: AppTextStyles.font10SemiBold.copyWith(
                      color: AppColors.muted,
                      letterSpacing: 0.8,
                    ),
                  ),
                  SizedBox(height: AppSizes.height(6)),
                  Row(
                    children: [
                      Text(
                        '${state.strengthTrend > 0 ? '+' : ''}${state.strengthTrend.toStringAsFixed(0)}%',
                        style: AppTextStyles.font18SemiBold.copyWith(
                          color: state.strengthTrend > 0 ? AppColors.amber : (state.strengthTrend < 0 ? AppColors.red : AppColors.muted),
                        ),
                      ),
                      if (state.strengthTrend.abs() >= 0.5) ...[
                        SizedBox(width: AppSizes.width(6)),
                        Icon(
                          state.strengthTrend > 0 ? Icons.trending_up : Icons.trending_down,
                          color: state.strengthTrend > 0 ? AppColors.green : AppColors.red,
                          size: AppSizes.font(18),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
              // Shared mini bar chart
              MiniBarChart(
                dataPoints: dataPoints,
              ),
            ],
          ),
        ),

        SizedBox(height: AppSizes.height(10)),

        // B) 2-column row
        Row(
          children: [
            Expanded(
              child: _SmallStatCard(
                title: AppTexts.bodyWeight,
                value: state.weight,
                filledDots: state.weeklyWorkouts.clamp(0, 3),
              ),
            ),
            SizedBox(width: AppSizes.width(10)),
            Expanded(
              child: _SmallStatCard(
                title: AppTexts.bodyFat,
                value: state.bodyFat,
                filledDots: (state.streak?.currentStreak ?? 0).clamp(0, 3),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Small stat card with title, value, and dot progress.
class _SmallStatCard extends StatelessWidget {
  final String title;
  final String value;
  final int filledDots;

  const _SmallStatCard({
    required this.title,
    required this.value,
    this.filledDots = 0,
  });

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.width(14),
        vertical: AppSizes.height(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.font10SemiBold.copyWith(
              color: AppColors.muted,
            ),
          ),
          SizedBox(height: AppSizes.height(6)),
          Text(value, style: AppTextStyles.font18Bold),
          SizedBox(height: AppSizes.height(8)),
          DotProgressRow(
            totalDots: 3,
            filledDots: filledDots,
          ),
        ],
      ),
    );
  }
}
