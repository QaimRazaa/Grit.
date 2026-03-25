import 'package:flutter/material.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/texts.dart';
import 'package:grit/utils/constants/text_styles.dart';
import 'package:grit/utils/device/responsive_size.dart';

class ProgramCompleteView extends StatelessWidget {
  const ProgramCompleteView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: AppSizes.height(40)),
          Text(
            AppTexts.homeProgramCompleteMessage,
            style: AppTextStyles.font15Regular.copyWith(
              color: AppColors.muted,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSizes.height(16)),
          GestureDetector(
            onTap: () {},
            child: Text(
              AppTexts.homeMessageQaim,
              style: AppTextStyles.font14Regular.copyWith(
                color: AppColors.amber,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
