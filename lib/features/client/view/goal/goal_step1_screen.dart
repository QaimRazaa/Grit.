import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grit/core/routes/app_routes.dart';
import 'package:grit/features/client/view/goal/widgets/goal_layout_wrapper.dart';
import 'package:grit/features/client/viewmodel/goal/goal_viewmodel.dart';
import 'package:grit/shared/widgets/card/selectable_card.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/sizes.dart';
import 'package:grit/utils/constants/text_styles.dart';
import 'package:grit/utils/constants/texts.dart';
import 'package:grit/utils/device/responsive_size.dart';

class GoalStep1Screen extends ConsumerWidget {
  const GoalStep1Screen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(goalViewModelProvider);

    return GoalLayoutWrapper(
      step: 1,
      progress: 0.25,
      showBackArrow: false, // Step 1 has NO back arrow
      buttonText: AppTexts.buttonContinue,
      isButtonActive: state.isStep1Valid,
      isButtonLoading: state.isLoading,
      onButtonPressed: () {
        ref.read(goalViewModelProvider.notifier).submitStep1(
          onSuccess: () async {
             if (context.mounted) context.push(AppRoutes.goalStep2);
          },
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: AppSizes.height(GritSizes.gap24)),
          Text(
            AppTexts.goalStep1Question,
            style: AppTextStyles.font24Bold.copyWith( // Overriding to 22px as spec'd
              fontSize: AppSizes.font(22.0),
              color: AppColors.white,
            ),
          ),
          SizedBox(height: AppSizes.height(GritSizes.gap20)),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: PrimaryGoal.values.length,
            separatorBuilder: (context, index) => SizedBox(height: AppSizes.height(8.0)), // 8px Gap
            itemBuilder: (context, index) {
              final goal = PrimaryGoal.values[index];
              return SelectableCard(
                title: goal.title,
                subtitle: goal.description,
                isSelected: state.selectedGoal == goal,
                onTap: () => ref.read(goalViewModelProvider.notifier).setGoal(goal),
              );
            },
          ),
          SizedBox(height: AppSizes.height(40)), // Bottom padding above pinned button area
        ],
      ),
    );
  }
}
