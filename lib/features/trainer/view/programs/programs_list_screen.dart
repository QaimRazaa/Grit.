import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grit/core/routes/app_routes.dart';
import 'package:grit/features/trainer/view/programs/widgets/program_card.dart';
import 'package:grit/features/trainer/view/programs/widgets/client_program_card.dart';
import 'package:grit/features/trainer/viewmodel/programs_list_viewmodel.dart';
import 'package:grit/shared/widgets/navbar/trainer_bottom_nav_bar.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/text_styles.dart';
import 'package:grit/utils/constants/texts.dart';
import 'package:grit/utils/device/responsive_size.dart';
import '../../data/models/workout_program_model.dart';

class ProgramsListScreen extends ConsumerStatefulWidget {
  const ProgramsListScreen({super.key});

  @override
  ConsumerState<ProgramsListScreen> createState() => _ProgramsListScreenState();
}

class _ProgramsListScreenState extends ConsumerState<ProgramsListScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(programsListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const TrainerBottomNavBar(selectedIndex: 2),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.only(
                left: AppSizes.width(20),
                right: AppSizes.width(20),
                top: AppSizes.height(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppTexts.trainerProgramsTitle,
                    style: AppTextStyles.font22Bold,
                  ),
                  GestureDetector(
                    onTap: () => context.push(AppRoutes.programBuilder),
                    child: Row(
                      children: [
                        Icon(
                          Icons.add,
                          color: AppColors.amber,
                          size: AppSizes.font(18),
                        ),
                        SizedBox(width: AppSizes.width(6)),
                        Text(
                          AppTexts.trainerNewProgram,
                          style: AppTextStyles.font13Regular.copyWith(
                            color: AppColors.amber,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: AppSizes.height(16)),

            // Tab toggle
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.width(20)),
              child: _TabToggle(
                tabs: const [AppTexts.trainerTemplates, AppTexts.trainerClientPrograms],
                selectedIndex: state.selectedTab,
                onChanged: (i) => ref.read(programsListProvider.notifier).setTab(i),
              ),
            ),

            SizedBox(height: AppSizes.height(20)),

            // Content
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => ref.read(programsListProvider.notifier).refresh(),
                color: AppColors.amber,
                child: state.isLoading && state.programs.isEmpty && state.assignments.isEmpty
                    ? const Center(child: CircularProgressIndicator(color: AppColors.amber))
                    : SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: AppSizes.width(20)),
                        child: state.selectedTab == 0 
                            ? _TemplatesTab(programs: state.programs) 
                            : _ClientProgramsTab(assignments: state.assignments),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _TabToggle extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const _TabToggle({
    required this.tabs,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.width(4)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radius(12)),
        border: Border.all(color: AppColors.borderDefault, width: 1),
      ),
      child: Row(
        children: tabs.asMap().entries.map((e) {
          final bool selected = e.key == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(e.key),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: AppSizes.height(10)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSizes.radius(10)),
                  color: selected ? AppColors.amber : Colors.transparent,
                ),
                child: Text(
                  e.value,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.font13Regular.copyWith(
                    color: selected ? AppColors.background : AppColors.muted,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _TemplatesTab extends ConsumerWidget {
  final List<WorkoutProgramModel> programs;
  const _TemplatesTab({required this.programs});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppTexts.trainerYourTemplates,
          style: AppTextStyles.font11RegularDim.copyWith(letterSpacing: 0.8),
        ),
        SizedBox(height: AppSizes.height(12)),
        if (programs.isEmpty)
           Padding(
            padding: EdgeInsets.symmetric(vertical: AppSizes.height(40)),
            child: Center(
              child: Text(
                'No templates found. Create your first one!',
                style: AppTextStyles.font14RegularMuted,
                textAlign: TextAlign.center,
              ),
            ),
          )
        else
          ...programs.map((template) {
            final days = template.exercises
                .map((e) => e.day)
                .fold(0, (max, day) => day > max ? day : max);
            
            return Dismissible(
              key: Key(template.id ?? template.name),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: AppSizes.width(20)),
                margin: EdgeInsets.only(bottom: AppSizes.height(10)),
                decoration: BoxDecoration(
                  color: AppColors.red,
                  borderRadius: BorderRadius.circular(AppSizes.radius(16)),
                ),
                child: const Icon(Icons.delete_outline, color: AppColors.white),
              ),
              onDismissed: (_) {
                if (template.id != null) {
                  ref.read(programsListProvider.notifier).deleteProgram(template.id!);
                }
              },
              child: ProgramCard(
                id: template.id,
                name: template.name,
                days: days == 0 ? 1 : days,
                level: template.level,
                workoutCount: 1, 
                exerciseCount: template.exercises.length,
              ),
            );
          }),
        SizedBox(height: AppSizes.height(10)),
        // Create template card
        GestureDetector(
          onTap: () => context.push(AppRoutes.programBuilder),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: AppSizes.height(20)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSizes.radius(16)),
              border: Border.all(
                color: AppColors.amber.withOpacity(0.4),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_circle_outline_rounded,
                  color: AppColors.amber,
                  size: AppSizes.font(24),
                ),
                SizedBox(height: AppSizes.height(8)),
                Text(
                  AppTexts.trainerCreateTemplate,
                  style: AppTextStyles.font14Regular.copyWith(color: AppColors.amber),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: AppSizes.height(20)),
      ],
    );
  }
}

class _ClientProgramsTab extends StatelessWidget {
  final List<dynamic> assignments;
  const _ClientProgramsTab({required this.assignments});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppTexts.trainerAssignedPrograms,
          style: AppTextStyles.font11RegularDim.copyWith(letterSpacing: 0.8),
        ),
        SizedBox(height: AppSizes.height(12)),
        if (assignments.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: AppSizes.height(40)),
            child: Center(
              child: Text(
                'No programs assigned yet.',
                style: AppTextStyles.font14RegularMuted,
                textAlign: TextAlign.center,
              ),
            ),
          )
        else
          ...assignments.map((a) => ClientProgramCard(
                clientName: a.clientName ?? 'Unknown',
                clientInitials: a.clientInitials,
                programName: a.programName ?? 'Unknown',
                status: a.active ? 'active' : 'pending',
                currentDay: a.currentDay,
                totalDays: a.totalDays,
              )),
        SizedBox(height: AppSizes.height(20)),
      ],
    );
  }
}
