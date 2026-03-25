import 'package:flutter/material.dart';
import 'package:grit/shared/widgets/card/surface_card.dart';
import 'package:grit/shared/widgets/row/dot_progress_row.dart';
import 'package:grit/shared/widgets/row/mini_bar_chart.dart';
import 'package:grit/shared/widgets/section/section_header.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/texts.dart';
import 'package:grit/utils/constants/text_styles.dart';
import 'package:grit/utils/device/responsive_size.dart';

class YourProgress extends StatelessWidget {
  const YourProgress({super.key});

  @override
  Widget build(BuildContext context) {
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
                        '+12%',
                        style: AppTextStyles.font20Bold.copyWith(
                          color: AppColors.amber,
                        ),
                      ),
                      SizedBox(width: AppSizes.width(6)),
                      Icon(
                        Icons.trending_up,
                        color: AppColors.green,
                        size: AppSizes.font(18),
                      ),
                    ],
                  ),
                ],
              ),
              // Shared mini bar chart
              const MiniBarChart(
                heights: [12, 16, 20, 18, 24],
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
                value: '184.2 lbs',
              ),
            ),
            SizedBox(width: AppSizes.width(10)),
            Expanded(
              child: _SmallStatCard(
                title: AppTexts.bodyFat,
                value: '14.2%',
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
  final int totalDots;
  final int filledDots;

  const _SmallStatCard({
    required this.title,
    required this.value,
    this.totalDots = 3,
    this.filledDots = 2,
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
            totalDots: totalDots,
            filledDots: filledDots,
          ),
        ],
      ),
    );
  }
}
