import 'package:flutter/material.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/text_styles.dart';
import 'package:grit/utils/device/responsive_size.dart';

/// Icon + Value + Label row — used in hero progress stats, etc.
class IconStatRow extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color valueColor;
  final Color iconColor;

  const IconStatRow({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    this.valueColor = AppColors.amber,
    this.iconColor = AppColors.amber,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: AppSizes.font(14)),
        SizedBox(width: AppSizes.width(8)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: AppTextStyles.font18Bold.copyWith(color: valueColor),
              ),
              Text(
                label,
                style: AppTextStyles.font10Regular.copyWith(
                  color: AppColors.muted,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
