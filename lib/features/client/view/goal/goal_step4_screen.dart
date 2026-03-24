import 'package:flutter/material.dart';
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

final _successAnimationProvider = StateProvider.autoDispose<bool>((ref) => false);

class GoalStep4Screen extends ConsumerStatefulWidget {
  const GoalStep4Screen({super.key});

  @override
  ConsumerState<GoalStep4Screen> createState() => _GoalStep4ScreenState();
}

class _GoalStep4ScreenState extends ConsumerState<GoalStep4Screen> {
  late TextEditingController _injuriesController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(goalViewModelProvider);
    _injuriesController = TextEditingController(text: state.injuries);
  }

  @override
  void dispose() {
    _injuriesController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    ref.read(goalViewModelProvider.notifier).submitFinalForm(
      onSuccess: () async {
        ref.read(_successAnimationProvider.notifier).state = true;
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) {
          context.go(AppRoutes.waiting);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(goalViewModelProvider);
    final showSuccess = ref.watch(_successAnimationProvider);

    return Stack(
      children: [
        GoalLayoutWrapper(
          step: 4,
          progress: 1.0,
          showBackArrow: !state.isLoading,
          buttonText: AppTexts.buttonSubmitProfile,
          isButtonActive: state.isStep4Valid,
          isButtonLoading: state.isLoading,
          onButtonPressed: _handleSubmit,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppSizes.height(GritSizes.gap24)),
              Text(
                AppTexts.goalStep4Question,
                style: AppTextStyles.font24Bold.copyWith(
                  fontSize: AppSizes.font(22.0),
                  color: AppColors.white,
                ),
              ),
              SizedBox(height: AppSizes.height(GritSizes.gap24)),

              // Section 1: Injuries
              Text(
                AppTexts.goalStep4InjuriesLabel,
                style: AppTextStyles.font11RegularDim.copyWith(
                  color: AppColors.muted,
                  letterSpacing: 11.0 * 0.08,
                ),
              ),
              SizedBox(height: AppSizes.height(10.0)),
              CustomTextField(
                controller: _injuriesController,
                hintText: AppTexts.goalStep4InjuriesHint,
                minLines: 3,
                maxLines: 5,
                contentPadding: EdgeInsets.all(AppSizes.width(16.0)),
                onChanged: (v) => ref.read(goalViewModelProvider.notifier).setInjuries(v),
              ),
              
              SizedBox(height: AppSizes.height(GritSizes.gap24)),

              // Section 2: Source
              Text(
                AppTexts.goalStep4SourceLabel,
                style: AppTextStyles.font11RegularDim.copyWith(
                  color: AppColors.muted,
                  letterSpacing: 11.0 * 0.08,
                ),
              ),
              SizedBox(height: AppSizes.height(10.0)),
              Wrap(
                spacing: AppSizes.width(8.0),
                runSpacing: AppSizes.height(8.0),
                children: GoalSource.values.map((source) {
                  return SelectableChip(
                    label: source.label,
                    isSelected: state.source == source,
                    onTap: () => ref.read(goalViewModelProvider.notifier).setSource(source),
                  );
                }).toList(),
              ),

              if (state.error != null) ...[
                SizedBox(height: AppSizes.height(GritSizes.gap16)),
                Center(
                  child: Text(
                    state.error!,
                    style: AppTextStyles.font12RegularRed,
                  ),
                ),
              ],
              
              SizedBox(height: AppSizes.height(40)),
            ],
          ),
        ),
        if (showSuccess)
          Positioned.fill(
            child: Container(
              color: AppColors.background.withValues(alpha: 0.8),
              child: Center(
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 500),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: const Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.amber,
                        size: 100,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
      ],
    );
  }
}
