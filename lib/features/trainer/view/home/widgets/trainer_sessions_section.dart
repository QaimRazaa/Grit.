import 'package:flutter/material.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/texts.dart';
import 'package:grit/utils/constants/text_styles.dart';
import 'package:grit/utils/device/responsive_size.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grit/core/routes/app_routes.dart';
import 'package:grit/features/trainer/data/models/program_assignment_model.dart';
import 'package:grit/features/trainer/viewmodel/trainer_home_viewmodel.dart';

class TrainerSessionsSection extends ConsumerWidget {
  const TrainerSessionsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(trainerHomeProvider);
    final sessions = state.todaysSessions;

    if (sessions.isEmpty) return const SizedBox();

    // Group logs by client
    final Map<String, List<Map<String, dynamic>>> groupedSessions = {};
    for (var session in sessions) {
      final clientId = session['client_id']?.toString() ?? 'Unknown';
      groupedSessions.putIfAbsent(clientId, () => []).add(session);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppTexts.trainerTodaysSessions,
              style: AppTextStyles.font16Bold,
            ),
            GestureDetector(
              onTap: () => context.push(AppRoutes.trainerLogs),
              child: Text(
                AppTexts.viewAll,
                style: AppTextStyles.font12Regular.copyWith(
                  color: AppColors.amber,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: AppSizes.height(14)),
        // Session cards (One per client)
        ...groupedSessions.entries.map((entry) {
          final clientId = entry.key;
          final logs = entry.value;
          final clientName = logs.first['client_name'] ?? 'Client';
          final uniqueExercises = logs.map((l) => l['exercise_name']?.toString() ?? 'Exercise').toSet().toList();
          
          // Find assignment for this client
          final assignment = state.activeAssignments.firstWhere(
            (a) => a.clientId == clientId,
            orElse: () => ProgramAssignmentModel(
              id: '', programId: '', clientId: clientId, startDate: DateTime.now()
            ),
          );

          final currentProgramDay = (assignment.currentDay - 1) % 7 + 1;
          final todaysExercises = assignment.exercises?.where((e) => e.day == currentProgramDay).toList() ?? [];
          final totalExercises = todaysExercises.length;
          final completedExercises = uniqueExercises.length;
          
          String progressText = "$completedExercises of $totalExercises exercises";
          if (totalExercises == 0) {
            progressText = "$completedExercises exercises logged";
          }
          
          final bool isAllDone = totalExercises > 0 && completedExercises >= totalExercises;

          return GestureDetector(
            onTap: () => context.push('${AppRoutes.clientProfile}/$clientId'),
            child: _SessionCard(
              name: clientName,
              workout: progressText,
              time: 'Today',
              status: isAllDone ? 'done' : 'inProgress',
            ),
          );
        }),
      ],
    );
  }
}

class _SessionCard extends StatelessWidget {
  final String name;
  final String workout;
  final String time;
  final String status;

  const _SessionCard({
    required this.name,
    required this.workout,
    required this.time,
    required this.status,
  });

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSizes.height(10)),
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.width(16),
        vertical: AppSizes.height(14),
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radius(16)),
        border: Border.all(color: AppColors.borderDefault, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar
          Container(
            width: AppSizes.width(44),
            height: AppSizes.width(44),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: status == 'inProgress'
                  ? AppColors.green.withValues(alpha: 0.1)
                  : AppColors.surface2,
              border: Border.all(
                color: status == 'inProgress'
                    ? AppColors.green.withValues(alpha: 0.3)
                    : AppColors.borderDefault,
                width: 1.5,
              ),
            ),
            child: Center(
              child: Text(
                _getInitials(name),
                style: AppTextStyles.font13SemiBold.copyWith(
                  color: status == 'inProgress' ? AppColors.green : AppColors.muted,
                ),
              ),
            ),
          ),

          SizedBox(width: AppSizes.width(12)),

          // Center info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.font14Regular,
                ),
                SizedBox(height: AppSizes.height(3)),
                Text(
                  workout,
                  style: AppTextStyles.font12RegularMuted,
                ),
                SizedBox(height: AppSizes.height(6)),
                // Time chip
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.width(8),
                    vertical: AppSizes.height(4),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface2,
                    borderRadius: BorderRadius.circular(AppSizes.radius(20)),
                    border: Border.all(color: AppColors.borderFilled, width: 1),
                  ),
                  child: Text(
                    time,
                    style: AppTextStyles.font10SemiBold.copyWith(
                      color: AppColors.amber,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Status chip + chevron
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _StatusChip(status: status),
              SizedBox(width: AppSizes.width(8)),
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.dim,
                size: AppSizes.font(18),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color borderColor;
    String label;
    Color textColor;

    switch (status) {
      case 'inProgress':
        borderColor = AppColors.green.withValues(alpha: 0.5);
        label = 'Live';
        textColor = AppColors.green;
        break;
      case 'done':
        borderColor = AppColors.borderDefault;
        label = 'Done';
        textColor = AppColors.dim;
        break;
      default:
        borderColor = AppColors.amber.withValues(alpha: 0.5);
        label = 'Soon';
        textColor = AppColors.amber;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.width(10),
        vertical: AppSizes.height(5),
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppSizes.radius(20)),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Text(
        label,
        style: AppTextStyles.font10SemiBold.copyWith(color: textColor),
      ),
    );
  }
}
