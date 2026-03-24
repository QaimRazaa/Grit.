import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grit/core/routes/app_routes.dart';
import 'package:grit/features/client/view/goal/widgets/goal_layout_wrapper.dart';
import 'package:grit/features/client/viewmodel/goal/goal_viewmodel.dart';
import 'package:grit/shared/widgets/chip/selectable_chip.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/sizes.dart';
import 'package:grit/utils/constants/text_styles.dart';
import 'package:grit/utils/constants/texts.dart';
import 'package:grit/utils/device/responsive_size.dart';

class GoalStep3Screen extends ConsumerWidget {
  const GoalStep3Screen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(goalViewModelProvider);

    return GoalLayoutWrapper(
      step: 3,
      progress: 0.75,
      showBackArrow: true,
      buttonText: AppTexts.buttonContinue,
      isButtonActive: state.isStep3Valid,
      isButtonLoading: state.isLoading,
      onButtonPressed: () {
        ref.read(goalViewModelProvider.notifier).submitStep3(
          onSuccess: () async {
            if (context.mounted) context.push(AppRoutes.goalStep4);
          },
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: AppSizes.height(GritSizes.gap24)),
          Text(
            AppTexts.goalStep3Question,
            style: AppTextStyles.font24Bold.copyWith(
              fontSize: AppSizes.font(22.0),
              color: AppColors.white,
            ),
          ),
          SizedBox(height: AppSizes.height(GritSizes.gap24)),
          
          // Section 1: EXPERIENCE LEVEL
          _buildSectionLabel(AppTexts.goalStep3ExpLabel),
          SizedBox(height: AppSizes.height(10.0)),
          Wrap(
            spacing: AppSizes.width(8.0),
            runSpacing: AppSizes.height(8.0),
            children: ExperienceLevel.values.map((exp) {
              return SelectableChip(
                label: exp.label,
                isSelected: state.experienceLevel == exp,
                onTap: () => ref.read(goalViewModelProvider.notifier).setExperienceLevel(exp),
              );
            }).toList(),
          ),
          
          SizedBox(height: AppSizes.height(GritSizes.gap24)),

          // Section 2: DAYS PER WEEK
          _buildSectionLabel(AppTexts.goalStep3DaysLabel),
          SizedBox(height: AppSizes.height(10.0)),
          Wrap(
            spacing: AppSizes.width(8.0),
            runSpacing: AppSizes.height(8.0),
            children: DaysPerWeek.values.map((days) {
              return SelectableChip(
                label: days.label,
                isSelected: state.daysPerWeek == days,
                width: 48.0, // Narrow number chips
                onTap: () => ref.read(goalViewModelProvider.notifier).setDaysPerWeek(days),
              );
            }).toList(),
          ),

          SizedBox(height: AppSizes.height(GritSizes.gap24)),

          // Section 3: GYM ACCESS
          _buildSectionLabel(AppTexts.goalStep3AccessLabel),
          SizedBox(height: AppSizes.height(10.0)),
          Wrap(
            spacing: AppSizes.width(8.0),
            runSpacing: AppSizes.height(8.0),
            children: GymAccess.values.map((access) {
              return SelectableChip(
                label: access.label,
                isSelected: state.gymAccess == access,
                onTap: () => ref.read(goalViewModelProvider.notifier).setGymAccess(access),
              );
            }).toList(),
          ),

          SizedBox(height: AppSizes.height(GritSizes.gap24)),

          // Section 4: PREFERRED TRAINING TIME
          _buildSectionLabel(AppTexts.goalStep3TimeLabel),
          SizedBox(height: AppSizes.height(10.0)),
          Wrap(
            spacing: AppSizes.width(8.0),
            runSpacing: AppSizes.height(8.0),
            children: TrainingTime.values.map((time) {
              return SelectableChip(
                label: time.label,
                isSelected: state.trainingTime == time,
                onTap: () => ref.read(goalViewModelProvider.notifier).setTrainingTime(time),
              );
            }).toList(),
          ),
          
          SizedBox(height: AppSizes.height(40)), // Bottom padding above pinned button area
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: AppTextStyles.font11RegularDim.copyWith(
        color: AppColors.muted,
        letterSpacing: 11.0 * 0.08,
      ),
    );
  }
}
