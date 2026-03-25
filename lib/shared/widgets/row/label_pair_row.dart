import 'package:flutter/material.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/text_styles.dart';
import 'package:grit/utils/device/responsive_size.dart';

/// A row with a left label and right label, spaced between.
/// Used for "SESSION PROGRESS" ↔ "2 OF 6 EXERCISES DONE" etc.
class LabelPairRow extends StatelessWidget {
  final String leftLabel;
  final String rightLabel;
  final Color leftColor;
  final Color rightColor;
  final double leftLetterSpacing;
  final double rightLetterSpacing;

  const LabelPairRow({
    super.key,
    required this.leftLabel,
    required this.rightLabel,
    this.leftColor = AppColors.dim,
    this.rightColor = AppColors.amber,
    this.leftLetterSpacing = 0.8,
    this.rightLetterSpacing = 0.5,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          leftLabel,
          style: AppTextStyles.font10SemiBold.copyWith(
            color: leftColor,
            letterSpacing: leftLetterSpacing,
          ),
        ),
        Text(
          rightLabel,
          style: AppTextStyles.font10SemiBold.copyWith(
            color: rightColor,
            letterSpacing: rightLetterSpacing,
          ),
        ),
      ],
    );
  }
}
