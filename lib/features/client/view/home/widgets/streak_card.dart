import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/texts.dart';
import 'package:grit/utils/constants/text_styles.dart';
import 'package:grit/utils/device/responsive_size.dart';

class StreakCard extends StatelessWidget {
  final int streakCount;
  final List<bool> last7DaysLogged;
  final int personalBest;

  const StreakCard({
    super.key,
    this.streakCount = 0,
    this.last7DaysLogged = const [false, false, false, false, false, false, false],
    this.personalBest = 0,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> fullDays = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];

    return Container(
      clipBehavior: Clip.hardEdge,
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.width(16),
        vertical: AppSizes.height(16),
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radius(20)),
        border: Border.all(
          color: AppColors.borderDefault,
          width: 1.0,
        ),
      ),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Section: Streak Number + Bars (lines)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        streakCount.toString(),
                        style: AppTextStyles.font48ExtraBold.copyWith(
                          color: AppColors.amber,
                          letterSpacing: -2.0,
                          height: 1.0,
                        ),
                      ),
                      SizedBox(width: AppSizes.width(8)),
                      Text(
                        AppTexts.homeDayStreak,
                        style: AppTextStyles.font12RegularMuted,
                      ),
                    ],
                  ),
                  SizedBox(height: AppSizes.height(16)),
                  
                  // Mini Lines Chart using fl_chart
                  SizedBox(
                    height: AppSizes.height(45),
                    width: AppSizes.width(160),
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceBetween,
                        maxY: 1.0,
                        barTouchData: BarTouchData(enabled: false),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    fullDays[value.toInt()][0], // First letter
                                    style: AppTextStyles.font10Regular.copyWith(
                                      color: AppColors.dim,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        gridData: const FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                        barGroups: List.generate(7, (index) {
                          final isLogged = index < last7DaysLogged.length ? last7DaysLogged[index] : false;
                          return BarChartGroupData(
                            x: index,
                            barRods: [
                              BarChartRodData(
                                toY: isLogged ? 0.8 : 0.2, // "Height" of the line
                                color: isLogged ? AppColors.amber : AppColors.borderDefault,
                                width: 4.0, // Thin "line" look
                                borderRadius: BorderRadius.circular(2),
                                backDrawRodData: BackgroundBarChartRodData(
                                  show: true,
                                  toY: 1.0,
                                  color: AppColors.surface,
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),
              
              // Right Section: Personal Best
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.width(12),
                      vertical: AppSizes.height(8),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.amber.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppSizes.radius(12)),
                      border: Border.all(
                        color: AppColors.amber.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          AppTexts.homePersonalBestLabel,
                          style: AppTextStyles.font10SemiBold.copyWith(
                            color: AppColors.muted,
                          ),
                        ),
                        SizedBox(height: AppSizes.height(2)),
                        Text(
                          '$personalBest ${AppTexts.homePersonalBestSuffix}',
                          style: AppTextStyles.font18Bold.copyWith(
                            color: AppColors.amber,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSizes.height(6)),
                  Text(
                    AppTexts.homeKeepGoing,
                    style: AppTextStyles.font11RegularDim,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
