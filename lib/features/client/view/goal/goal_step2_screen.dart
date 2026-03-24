import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grit/core/routes/app_routes.dart';
import 'package:grit/features/client/view/goal/widgets/goal_layout_wrapper.dart';
import 'package:grit/features/client/viewmodel/goal/goal_viewmodel.dart';
import 'package:grit/shared/widgets/chip/selectable_chip.dart';
import 'package:grit/shared/widgets/textfield/custom_text_field.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/sizes.dart';
import 'package:grit/utils/constants/text_styles.dart';
import 'package:grit/utils/constants/texts.dart';
import 'package:grit/utils/device/responsive_size.dart';

class GoalStep2Screen extends ConsumerStatefulWidget {
  const GoalStep2Screen({super.key});

  @override
  ConsumerState<GoalStep2Screen> createState() => _GoalStep2ScreenState();
}

class _GoalStep2ScreenState extends ConsumerState<GoalStep2Screen> {
  late TextEditingController _weightController;
  late TextEditingController _heightController;
  late TextEditingController _ageController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing state if any (handles back navigation gracefully without wiping UI)
    final state = ref.read(goalViewModelProvider);
    _weightController = TextEditingController(text: state.weight);
    _heightController = TextEditingController(text: state.height);
    _ageController = TextEditingController(text: state.age);
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(goalViewModelProvider);

    return GoalLayoutWrapper(
      step: 2,
      progress: 0.50,
      showBackArrow: true,
      buttonText: AppTexts.buttonContinue,
      isButtonActive: state.isStep2Valid,
      isButtonLoading: state.isLoading,
      onButtonPressed: () {
        ref.read(goalViewModelProvider.notifier).submitStep2(
          onSuccess: () async {
            if (context.mounted) context.push(AppRoutes.goalStep3);
          },
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: AppSizes.height(GritSizes.gap24)),
          Text(
            AppTexts.goalStep2Question,
            style: AppTextStyles.font24Bold.copyWith(
              fontSize: AppSizes.font(22.0),
              color: AppColors.white,
            ),
          ),
          SizedBox(height: AppSizes.height(GritSizes.gap20)),
          
          // Current Weight Field
          CustomTextField(
            controller: _weightController,
            height: AppSizes.height(52.0),
            labelText: AppTexts.goalStep2WeightLabel,
            hintText: AppTexts.goalStep2WeightHint,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (v) => ref.read(goalViewModelProvider.notifier).setWeight(v),
            suffixIcon: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppTexts.goalStep2WeightSuffix,
                  style: AppTextStyles.font13RegularMuted,
                ),
              ],
            ),
          ),
          SizedBox(height: AppSizes.height(GritSizes.gap16)),

          // Height Field
          CustomTextField(
            controller: _heightController,
            height: AppSizes.height(52.0),
            labelText: AppTexts.goalStep2HeightLabel,
            hintText: AppTexts.goalStep2HeightHint,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (v) => ref.read(goalViewModelProvider.notifier).setHeight(v),
            suffixIcon: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppTexts.goalStep2HeightSuffix,
                  style: AppTextStyles.font13RegularMuted,
                ),
              ],
            ),
          ),
          SizedBox(height: AppSizes.height(GritSizes.gap16)),

          // Age Field
          CustomTextField(
            controller: _ageController,
            height: AppSizes.height(52.0),
            labelText: AppTexts.goalStep2AgeLabel,
            hintText: AppTexts.goalStep2AgeHint,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (v) => ref.read(goalViewModelProvider.notifier).setAge(v),
          ),
          SizedBox(height: AppSizes.height(GritSizes.gap24)),

          // Gender Section
          Text(
            AppTexts.goalStep2GenderLabel,
            style: AppTextStyles.font11RegularDim.copyWith(
              color: AppColors.muted,
              letterSpacing: 11.0 * 0.08,
            ),
          ),
          SizedBox(height: AppSizes.height(10.0)),
          
          // Horizontal scrolling or wrapping chips
          Wrap(
            spacing: AppSizes.width(8.0),
            runSpacing: AppSizes.height(8.0),
            children: Gender.values.map((gender) {
              return SelectableChip(
                label: gender.label,
                isSelected: state.gender == gender,
                onTap: () => ref.read(goalViewModelProvider.notifier).setGender(gender),
              );
            }).toList(),
          ),
          SizedBox(height: AppSizes.height(40)), // Bottom padding above pinned button area
        ],
      ),
    );
  }
}
