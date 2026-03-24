import 'package:flutter/material.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/device/responsive_size.dart';

class AppProgressBar extends StatelessWidget {
  /// Progress value between 0.0 and 1.0
  final double progress;

  const AppProgressBar({
    super.key,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: AppSizes.height(3.0),
      color: AppColors.surface2, // #1F1F1F track
      alignment: Alignment.centerLeft,
      child: FractionallySizedBox(
        widthFactor: progress.clamp(0.0, 1.0),
        child: Container(
          color: AppColors.amber, // #F59E0B fill
        ),
      ),
    );
  }
}
