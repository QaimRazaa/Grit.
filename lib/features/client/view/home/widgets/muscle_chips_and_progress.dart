import 'package:flutter/material.dart';
import 'package:grit/shared/widgets/chip/amber_chip.dart';
import 'package:grit/shared/widgets/row/label_pair_row.dart';
import 'package:grit/utils/constants/text_styles.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/texts.dart';
import 'package:grit/utils/device/responsive_size.dart';

class MuscleChipsAndProgress extends StatelessWidget {
  final int completedCount;
  final int totalCount;
  final int calories;

  const MuscleChipsAndProgress({
    super.key,
    required this.completedCount,
    required this.totalCount,
    this.calories = 0,
  });

  @override
  Widget build(BuildContext context) {
    final double progress = totalCount > 0 ? completedCount / totalCount : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // A) Horizontal scrollable chip row
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: ['CHEST', 'SHOULDERS', 'TRICEPS']
                .asMap()
                .entries
                .map((entry) {
              return Padding(
                padding: EdgeInsets.only(
                  right: entry.key < 2 ? AppSizes.width(8) : 0,
                ),
                child: AmberChip(label: entry.value),
              );
            }).toList(),
          ),
        ),

        SizedBox(height: AppSizes.height(16)),

        // Calorie burn estimate
        if (calories > 0) ...[
          Row(
            children: [
              Icon(
                Icons.whatshot_rounded,
                color: AppColors.amber,
                size: AppSizes.font(16),
              ),
              SizedBox(width: AppSizes.width(4)),
              Text(
                '$calories KCAL BURNED',
                style: AppTextStyles.font11SemiBold.copyWith(
                  color: AppColors.amber,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.height(12)),
        ],

        // B) Session progress label pair
        LabelPairRow(
          leftLabel: AppTexts.sessionProgress,
          rightLabel: '$completedCount OF $totalCount EXERCISES DONE',
        ),

        SizedBox(height: AppSizes.height(8)),

        // C) Progress bar
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.radius(4)),
          child: Stack(
            children: [
              Container(
                height: AppSizes.height(4),
                width: double.infinity,
                color: AppColors.borderDefault,
              ),
              FractionallySizedBox(
                widthFactor: progress.clamp(0.0, 1.0),
                child: Container(
                  height: AppSizes.height(4),
                  color: AppColors.amber,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
