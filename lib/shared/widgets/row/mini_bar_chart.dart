import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/device/responsive_size.dart';

class MiniBarChart extends StatelessWidget {
  final List<double> dataPoints;
  final double width;
  final double height;

  const MiniBarChart({
    super.key,
    required this.dataPoints,
    this.width = 80,
    this.height = 36,
  });

  @override
  Widget build(BuildContext context) {
    if (dataPoints.isEmpty) return SizedBox(width: AppSizes.width(width), height: AppSizes.height(height));

    final double maxVal = dataPoints.reduce((a, b) => a > b ? a : b);
    final double maxY = maxVal == 0 ? 5 : maxVal + 1;

    return SizedBox(
      width: AppSizes.width(width),
      height: AppSizes.height(height),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceEvenly,
          maxY: maxY,
          barTouchData: BarTouchData(enabled: false),
          titlesData: const FlTitlesData(show: false),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: dataPoints.asMap().entries.map((entry) {
            return BarChartGroupData(
              x: entry.key,
              barRods: [
                BarChartRodData(
                  toY: entry.value,
                  color: AppColors.amber,
                  width: AppSizes.width(4),
                  borderRadius: BorderRadius.circular(AppSizes.radius(2)),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: maxY,
                    color: AppColors.surface,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
