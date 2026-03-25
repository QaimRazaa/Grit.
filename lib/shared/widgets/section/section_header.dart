import 'package:flutter/material.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/text_styles.dart';

/// A reusable section header row with a title and an optional right action.
/// Used for "YOUR PROGRESS", "TODAY'S HABITS", "NEXT UP", etc.
class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onAction;
  final TextStyle? titleStyle;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionText,
    this.onAction,
    this.titleStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: titleStyle ?? AppTextStyles.font16Bold),
        if (actionText != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              actionText!,
              style: AppTextStyles.font12Regular.copyWith(
                color: AppColors.amber,
              ),
            ),
          ),
      ],
    );
  }
}
