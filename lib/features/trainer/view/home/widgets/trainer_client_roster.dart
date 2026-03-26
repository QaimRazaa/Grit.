import 'package:flutter/material.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/texts.dart';
import 'package:grit/utils/constants/text_styles.dart';
import 'package:grit/utils/device/responsive_size.dart';
import 'package:grit/utils/helpers/ui_helper.dart';
import 'package:go_router/go_router.dart';
import 'package:grit/core/routes/app_routes.dart';


import 'package:grit/features/trainer/data/models/client_profile_model.dart';
import 'package:grit/features/trainer/data/models/program_assignment_model.dart';

class TrainerClientRoster extends StatelessWidget {
  final List<ClientProfileModel> clients;
  final List<ProgramAssignmentModel> assignments;

  const TrainerClientRoster({
    super.key,
    required this.clients,
    required this.assignments,
  });

  @override
  Widget build(BuildContext context) {
    if (clients.isEmpty) return const SizedBox.shrink();

    final today = DateTime.now();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppTexts.trainerMyClients,
              style: AppTextStyles.font16Bold,
            ),
            GestureDetector(
              onTap: () => UIHelper.showComingSoon(context, AppTexts.trainerAddClient),
              child: Row(
                children: [
                  Icon(Icons.add, color: AppColors.amber, size: AppSizes.font(14)),
                  SizedBox(width: AppSizes.width(4)),
                  Text(
                    AppTexts.trainerAddClient,
                    style: AppTextStyles.font12Regular.copyWith(
                      color: AppColors.amber,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: AppSizes.height(14)),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: clients.asMap().entries.map((entry) {
              final client = entry.value;
              final streak = client.streak;
              final isActiveToday = streak?.lastLoggedDate != null &&
                  streak!.lastLoggedDate!.year == today.year &&
                  streak.lastLoggedDate!.month == today.month &&
                  streak.lastLoggedDate!.day == today.day;

              final assignment = assignments.firstWhere(
                (a) => a.clientId == client.id && a.active,
                orElse: () => ProgramAssignmentModel(
                  id: '',
                  clientId: '',
                  programId: '',
                  startDate: today,
                  durationWeeks: 0,
                ),
              );
              final displayProgram = assignment.programName ?? client.primaryGoal ?? 'No Program';

              return Padding(
                padding: EdgeInsets.only(
                  right: entry.key == clients.length - 1 ? 0 : AppSizes.width(10),
                ),
                child: GestureDetector(
                  onTap: () => context.push('${AppRoutes.clientProfile}/${client.id}'),
                  child: _ClientCard(
                    name: client.fullName,
                    initials: client.initials,
                    program: displayProgram,
                    streak: streak?.currentStreak ?? 0,
                    last7Days: client.last7Days ?? List.generate(7, (_) => false),
                    activeToday: isActiveToday,
                  ),
                ),
              );
            }).toList(),

          ),
        ),
      ],
    );
  }
}


class _ClientCard extends StatelessWidget {
  final String name;
  final String initials;
  final String program;
  final int streak;
  final List<bool> last7Days;
  final bool activeToday;

  const _ClientCard({
    required this.name,
    required this.initials,
    required this.program,
    required this.streak,
    required this.last7Days,
    required this.activeToday,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.width(134),
      padding: EdgeInsets.all(AppSizes.width(16)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radius(20)),
        border: Border.all(
          color: activeToday
              ? AppColors.amber.withValues(alpha: 0.4)
              : AppColors.borderDefault,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: activeToday 
                ? AppColors.amber.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar
          Container(
            width: AppSizes.width(48),
            height: AppSizes.width(48),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surface2,
              border: Border.all(
                color: activeToday ? AppColors.amber : AppColors.borderDefault,
                width: AppSizes.width(2),
              ),
            ),
            child: Center(
              child: Text(
                initials,
                style: AppTextStyles.font15Medium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          SizedBox(height: AppSizes.height(10)),
          // Name
          Text(
            name,
            style: AppTextStyles.font13Regular.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: AppSizes.height(3)),
          // Program
          Text(
            program,
            style: AppTextStyles.font10Regular.copyWith(
              color: AppColors.muted,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: AppSizes.height(10)),
          // 7-day activity dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(7, (i) {
              return Container(
                width: AppSizes.width(7),
                height: AppSizes.width(7),
                margin: EdgeInsets.only(
                  right: i == 6 ? 0 : AppSizes.width(4),
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: last7Days[i]
                      ? AppColors.amber.withValues(alpha: 0.5 + 0.5 * (i / 6))
                      : AppColors.borderDefault,
                ),
              );
            }),
          ),
          SizedBox(height: AppSizes.height(10)),
          // Streak chip
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.width(10),
              vertical: AppSizes.height(5),
            ),
            decoration: BoxDecoration(
              color: AppColors.surface2,
              borderRadius: BorderRadius.circular(AppSizes.radius(10)),
              border: Border.all(color: AppColors.borderDefault, width: 1),
            ),
            child: Text(
              '🔥 $streak ${AppTexts.homePersonalBestSuffix}',
              style: AppTextStyles.font10Regular.copyWith(
                color: AppColors.amber,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
