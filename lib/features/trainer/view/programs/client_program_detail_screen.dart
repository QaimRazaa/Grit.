import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grit/features/trainer/viewmodel/programs_list_viewmodel.dart';
import 'package:grit/features/trainer/data/models/program_assignment_model.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/text_styles.dart';
import 'package:grit/utils/device/responsive_size.dart';

String _formatDate(DateTime date) {
  final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  return '${date.day} ${months[date.month - 1]} ${date.year}';
}

class ClientProgramDetailScreen extends ConsumerWidget {
  final String assignmentId;
  const ClientProgramDetailScreen({super.key, required this.assignmentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(programsListProvider);
    
    // Find assignment by ID
    final assignment = state.assignments.cast<ProgramAssignmentModel?>().firstWhere(
      (a) => a?.id == assignmentId,
      orElse: () => null,
    );

    if (assignment == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.white),
            onPressed: () => context.pop(),
          ),
        ),
        body: const Center(
          child: Text('Program assignment not found', style: AppTextStyles.font14RegularMuted),
        ),
      );
    }

    final daysPerWeek = assignment.exercises?.fold<int>(0, (m, e) => e.day > m ? e.day : m) ?? 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context, assignment.programName ?? 'Program Details'),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.width(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: AppSizes.height(16)),
                  _buildClientProgressCard(assignment),
                  SizedBox(height: AppSizes.height(32)),
                  Text(
                    'PROGRAM CONTENT',
                    style: AppTextStyles.font11SemiBold.copyWith(
                      color: AppColors.muted,
                      letterSpacing: 0.8,
                    ),
                  ),
                  SizedBox(height: AppSizes.height(16)),
                  _buildWeekByWeekList(assignment, daysPerWeek),
                  SizedBox(height: AppSizes.height(100)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, String title) {
    return SliverAppBar(
      backgroundColor: AppColors.background,
      pinned: true,
      elevation: 0,
      centerTitle: false,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.white),
        onPressed: () => context.pop(),
      ),
      title: Text(title, style: AppTextStyles.font18Bold),
    );
  }

  Widget _buildClientProgressCard(ProgramAssignmentModel assignment) {
    return Container(
      padding: AppSizes.paddingAll(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radius(20)),
        border: Border.all(color: AppColors.borderDefault, width: 1),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: AppSizes.width(44),
                height: AppSizes.width(44),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surface2,
                  border: Border.all(color: AppColors.amber, width: 1.5),
                ),
                alignment: Alignment.center,
                child: Text(
                  assignment.clientInitials,
                  style: AppTextStyles.font15Medium.copyWith(color: AppColors.amber, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(width: AppSizes.width(12)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(assignment.clientName ?? 'Client', style: AppTextStyles.font16Bold),
                  SizedBox(height: AppSizes.height(2)),
                  Text(
                    'Assigned on ${_formatDate(assignment.startDate)}',
                    style: AppTextStyles.font12RegularMuted,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: AppSizes.height(20)),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.radius(4)),
            child: LinearProgressIndicator(
              value: assignment.progressPercentage,
              backgroundColor: AppColors.surface2,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.amber),
              minHeight: AppSizes.height(6),
            ),
          ),
          SizedBox(height: AppSizes.height(10)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Day ${assignment.currentDay} of ${assignment.totalDays}',
                style: AppTextStyles.font12Medium,
              ),
              Text(
                '${(assignment.progressPercentage * 100).toInt()}% Complete',
                style: AppTextStyles.font12Medium.copyWith(color: AppColors.amber),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeekByWeekList(ProgramAssignmentModel assignment, int daysPerWeek) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: assignment.durationWeeks,
      itemBuilder: (context, index) {
        final week = index + 1;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: AppSizes.height(12), top: index == 0 ? 0 : AppSizes.height(24)),
              child: Text(
                'WEEK $week',
                style: AppTextStyles.font13SemiBold.copyWith(color: AppColors.amber),
              ),
            ),
            ...List.generate(daysPerWeek, (dIndex) {
              final day = dIndex + 1;
              final slotExercises = assignment.exercises?.where((e) => e.week == week && e.day == day).toList() ?? [];
              
              if (slotExercises.isEmpty) return const SizedBox.shrink();

              return Container(
                margin: EdgeInsets.only(bottom: AppSizes.height(10)),
                padding: AppSizes.paddingAll(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSizes.radius(16)),
                  border: Border.all(color: AppColors.borderDefault),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('DAY $day', style: AppTextStyles.font11SemiBold.copyWith(color: AppColors.muted)),
                    SizedBox(height: AppSizes.height(8)),
                    ...slotExercises.map((ex) => Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSizes.height(4)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(ex.name, style: AppTextStyles.font14Regular),
                          ),
                          Text(
                            '${ex.sets} x ${ex.toFailure ? "Failure" : ex.reps}',
                            style: AppTextStyles.font12RegularMuted,
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
              );
            }),
          ],
        );
      },
    );
  }
}
