import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grit/features/trainer/view/programs/widgets/exercise_library_sheet.dart';
import 'package:grit/features/trainer/viewmodel/program_builder_viewmodel.dart';
import 'package:grit/features/trainer/viewmodel/programs_list_viewmodel.dart';
import 'package:grit/utils/constants/colors.dart';

import 'package:grit/utils/device/responsive_size.dart';
import 'package:grit/utils/constants/text_styles.dart';
import 'package:grit/utils/popups/snackbar.dart';

class ProgramBuilderScreen extends ConsumerStatefulWidget {
  const ProgramBuilderScreen({super.key});

  @override
  ConsumerState<ProgramBuilderScreen> createState() => _ProgramBuilderScreenState();
}

class _ProgramBuilderScreenState extends ConsumerState<ProgramBuilderScreen> {
  final TextEditingController _programNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _programNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _showExerciseSheet() {
    final state = ref.read(programBuilderProvider);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ExerciseLibrarySheet(
        initialAdded: state.exercises,
        onDone: (exercises) {
          // Add new exercises that aren't already in the list
          for (final ex in exercises) {
            if (!state.exercises.any((e) => e.name == ex.name)) {
              ref.read(programBuilderProvider.notifier).addExercise(ex);
            }
          }
        },
      ),
    );
  }

  void _handleSave() {
    ref.read(programBuilderProvider.notifier).save();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(programBuilderProvider);
    
    ref.listen(programBuilderProvider.select((s) => s.isSaved), (prev, next) {
      if (next) {
        AppSnackBar.showSuccess(context, 'Program saved successfully!');
        ref.read(programsListProvider.notifier).refresh();
        context.pop();
      }
    });


    ref.listen(programBuilderProvider.select((s) => s.error), (prev, next) {
      if (next != null) {
        AppSnackBar.showError(context, next);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            _BuilderTopBar(
              onBack: () => context.pop(),
              onSave: _handleSave,
              isSaveEnabled: state.name.isNotEmpty && state.exercises.isNotEmpty && !state.isLoading,
            ),

            Expanded(
              child: state.isLoading 
                ? const Center(child: CircularProgressIndicator(color: AppColors.amber))
                : SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: AppSizes.width(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: AppSizes.height(20)),

                    // SECTION 1: Program Details
                    Text(
                      'PROGRAM DETAILS',
                      style: AppTextStyles.font11RegularDim.copyWith(letterSpacing: 0.8),
                    ),
                    SizedBox(height: AppSizes.height(12)),

                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.width(16),
                        vertical: AppSizes.height(20),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppSizes.radius(16)),
                        border: Border.all(color: AppColors.borderDefault, width: 1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Program name field
                          Text(
                            'PROGRAM NAME',
                            style: AppTextStyles.font10SemiBold.copyWith(
                              color: AppColors.muted,
                              letterSpacing: 0.8,
                            ),
                          ),
                          SizedBox(height: AppSizes.height(8)),
                          TextField(
                            controller: _programNameController,
                            onChanged: ref.read(programBuilderProvider.notifier).setName,
                            style: AppTextStyles.font18Bold,
                            decoration: InputDecoration(
                              hintText: 'e.g. Push Pull Legs',
                              hintStyle: AppTextStyles.font18Bold.copyWith(color: AppColors.dim),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: AppSizes.height(8)),
                            ),
                          ),

                          SizedBox(height: AppSizes.height(20)),

                          // Level Selector
                          Text(
                            'EXPERIENCE LEVEL',
                            style: AppTextStyles.font10SemiBold.copyWith(
                              color: AppColors.muted,
                              letterSpacing: 0.8,
                            ),
                          ),
                          SizedBox(height: AppSizes.height(12)),
                          Row(
                            children: ['Beginner', 'Intermediate', 'Advanced'].map((level) {
                              final bool selected = state.level == level;
                              return GestureDetector(
                                onTap: () => ref.read(programBuilderProvider.notifier).setLevel(level),
                                child: Container(
                                  margin: EdgeInsets.only(right: AppSizes.width(8)),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: AppSizes.width(12),
                                    vertical: AppSizes.height(6),
                                  ),
                                  decoration: BoxDecoration(
                                    color: selected ? AppColors.amber : AppColors.surface2,
                                    borderRadius: BorderRadius.circular(AppSizes.radius(20)),
                                    border: Border.all(
                                      color: selected ? AppColors.amber : AppColors.borderDefault,
                                    ),
                                  ),
                                  child: Text(
                                    level,
                                    style: AppTextStyles.font10SemiBold.copyWith(
                                      color: selected ? AppColors.background : AppColors.white,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),

                          SizedBox(height: AppSizes.height(20)),

                          // Description field
                          Text(
                            'DESCRIPTION',
                            style: AppTextStyles.font10SemiBold.copyWith(
                              color: AppColors.muted,
                              letterSpacing: 0.8,
                            ),
                          ),
                          SizedBox(height: AppSizes.height(8)),
                          TextField(
                            controller: _descriptionController,
                            onChanged: ref.read(programBuilderProvider.notifier).setDescription,
                            maxLines: 2,
                            style: AppTextStyles.font14Regular.copyWith(color: AppColors.white),
                            decoration: InputDecoration(
                              hintText: 'Optional description...',
                              hintStyle: AppTextStyles.font14Regular.copyWith(color: AppColors.dim),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: AppSizes.height(28)),

                    // SECTION 2: Exercises
                    Text(
                      'EXERCISES',
                      style: AppTextStyles.font11RegularDim.copyWith(letterSpacing: 0.8),
                    ),
                    SizedBox(height: AppSizes.height(12)),

                    if (state.exercises.isEmpty)
                      // Empty state
                      GestureDetector(
                        onTap: _showExerciseSheet,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: AppSizes.height(32)),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(AppSizes.radius(16)),
                            border: Border.all(color: AppColors.borderDefault, width: 1),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_circle_outline_rounded,
                                color: AppColors.amber,
                                size: AppSizes.font(32),
                              ),
                              SizedBox(height: AppSizes.height(12)),
                              Text(
                                'Add exercises to this program',
                                style: AppTextStyles.font13RegularMuted,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Column(
                        children: [
                          ...state.exercises.asMap().entries.map((entry) {
                            final index = entry.key;
                            final ex = entry.value;
                            return Container(
                              margin: EdgeInsets.only(bottom: AppSizes.height(12)),
                              padding: AppSizes.paddingAll(16),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(AppSizes.radius(16)),
                                border: Border.all(color: AppColors.borderDefault, width: 1),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(ex.name, style: AppTextStyles.font15Medium),
                                      ),
                                      IconButton(
                                        onPressed: () => ref.read(programBuilderProvider.notifier).removeExercise(index),
                                        icon: const Icon(Icons.remove_circle_outline, color: AppColors.red, size: 20),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: AppSizes.height(8)),
                                  Row(
                                    children: [
                                      // Sets
                                      _EditCell(
                                        label: 'SETS',
                                        value: ex.sets.toString(),
                                        onIncrement: () => ref.read(programBuilderProvider.notifier).updateExercise(
                                          index, ex.copyWith(sets: ex.sets + 1),
                                        ),
                                        onDecrement: () => ref.read(programBuilderProvider.notifier).updateExercise(
                                          index, ex.copyWith(sets: (ex.sets - 1).clamp(1, 20)),
                                        ),
                                      ),
                                      SizedBox(width: AppSizes.width(20)),
                                      // Reps
                                      _EditCell(
                                        label: 'REPS',
                                        value: ex.reps.toString(),
                                        onIncrement: () => ref.read(programBuilderProvider.notifier).updateExercise(
                                          index, ex.copyWith(reps: ex.reps + 1),
                                        ),
                                        onDecrement: () => ref.read(programBuilderProvider.notifier).updateExercise(
                                          index, ex.copyWith(reps: (ex.reps - 1).clamp(1, 100)),
                                        ),
                                      ),
                                      const Spacer(),
                                      // Day
                                      _EditCell(
                                        label: 'DAY',
                                        value: 'D${ex.day}',
                                        onIncrement: () => ref.read(programBuilderProvider.notifier).updateExercise(
                                          index, ex.copyWith(day: (ex.day + 1).clamp(1, 7)),
                                        ),
                                        onDecrement: () => ref.read(programBuilderProvider.notifier).updateExercise(
                                          index, ex.copyWith(day: (ex.day - 1).clamp(1, 7)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }),
                          SizedBox(height: AppSizes.height(12)),
                          GestureDetector(
                            onTap: _showExerciseSheet,
                            child: Center(
                              child: Text(
                                '+ Add More',
                                style: AppTextStyles.font14Regular.copyWith(color: AppColors.amber),
                              ),
                            ),
                          ),
                        ],
                      ),
                    SizedBox(height: AppSizes.height(40)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EditCell extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _EditCell({
    required this.label,
    required this.value,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.font10SemiBold.copyWith(color: AppColors.muted),
        ),
        SizedBox(height: AppSizes.height(6)),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _CounterButton(icon: Icons.remove, onTap: onDecrement),
            SizedBox(width: AppSizes.width(10)),
            Text(value, style: AppTextStyles.font14Regular.copyWith(fontWeight: FontWeight.bold)),
            SizedBox(width: AppSizes.width(10)),
            _CounterButton(icon: Icons.add, onTap: onIncrement),
          ],
        ),
      ],
    );
  }
}

class _CounterButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CounterButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppSizes.width(4)),
        decoration: BoxDecoration(
          color: AppColors.surface2,
          borderRadius: BorderRadius.circular(AppSizes.radius(6)),
          border: Border.all(color: AppColors.borderDefault),
        ),
        child: Icon(icon, color: AppColors.amber, size: AppSizes.font(14)),
      ),
    );
  }
}

class _BuilderTopBar extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onSave;
  final bool isSaveEnabled;

  const _BuilderTopBar({
    required this.onBack,
    required this.onSave,
    required this.isSaveEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.width(4),
        vertical: AppSizes.height(4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: onBack,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.width(16),
                vertical: AppSizes.height(12),
              ),
              child: Icon(
                Icons.arrow_back_rounded,
                color: AppColors.muted,
                size: AppSizes.font(22),
              ),
            ),
          ),
          Text(
            'New Program',
            style: AppTextStyles.font16SemiBold,
          ),
          GestureDetector(
            onTap: isSaveEnabled ? onSave : null,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.width(16),
                vertical: AppSizes.height(12),
              ),
              child: Text(
                'Save',
                style: AppTextStyles.font14Regular.copyWith(
                  color: isSaveEnabled ? AppColors.amber : AppColors.dim,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

