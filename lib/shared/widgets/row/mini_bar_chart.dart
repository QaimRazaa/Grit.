import 'package:flutter/material.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/device/responsive_size.dart';

/// A mini vertical bar chart row. Used in strength trend, etc.
class MiniBarChart extends StatelessWidget {
  final List<double> heights;
  final int highlightIndex;
  final Color barColor;
  final Color highlightColor;

  const MiniBarChart({
    super.key,
    required this.heights,
    this.highlightIndex = -1,
    this.barColor = AppColors.borderFilled,
    this.highlightColor = AppColors.amber,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: heights.asMap().entries.map((entry) {
        final isHighlighted = highlightIndex == -1
            ? entry.key == heights.length - 1
            : entry.key == highlightIndex;
        return Padding(
          padding: EdgeInsets.only(
            left: entry.key == 0 ? 0 : AppSizes.width(4),
          ),
          child: Container(
            width: AppSizes.width(8),
            height: AppSizes.height(entry.value),
            decoration: BoxDecoration(
              color: isHighlighted ? highlightColor : barColor,
              borderRadius: BorderRadius.circular(AppSizes.radius(3)),
            ),
          ),
        );
      }).toList(),
    );
  }
}
