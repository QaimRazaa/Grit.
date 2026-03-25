import 'package:flutter/material.dart';
import 'package:grit/shared/widgets/chip/amber_chip.dart';
import 'package:grit/shared/widgets/row/label_pair_row.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/texts.dart';
import 'package:grit/utils/device/responsive_size.dart';

class MuscleChipsAndProgress extends StatelessWidget {
  const MuscleChipsAndProgress({super.key});

  @override
  Widget build(BuildContext context) {
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

        // B) Session progress label pair
        const LabelPairRow(
          leftLabel: AppTexts.sessionProgress,
          rightLabel: AppTexts.sessionExercisesDone,
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
                widthFactor: 0.33,
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
