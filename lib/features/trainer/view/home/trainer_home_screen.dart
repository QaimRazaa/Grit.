import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grit/core/routes/app_routes.dart';
import 'package:grit/features/trainer/view/home/widgets/trainer_activity_preview.dart';
import 'package:grit/features/trainer/view/home/widgets/trainer_alerts_section.dart';
import 'package:grit/features/trainer/view/home/widgets/trainer_client_roster.dart';
import 'package:grit/features/trainer/view/home/widgets/trainer_quick_actions_grid.dart';
import 'package:grit/features/trainer/view/home/widgets/trainer_quick_stats_row.dart';
import 'package:grit/features/trainer/view/home/widgets/trainer_sessions_section.dart';
import 'package:grit/features/trainer/view/home/widgets/trainer_top_bar.dart';
import 'package:grit/shared/widgets/navbar/trainer_bottom_nav_bar.dart';
import 'package:grit/shared/widgets/state/empty_state.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/device/responsive_size.dart';
import 'package:grit/features/trainer/viewmodel/trainer_home_viewmodel.dart';

class TrainerHomeScreen extends ConsumerWidget {
  const TrainerHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(trainerHomeProvider);
    final notifier = ref.read(trainerHomeProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const TrainerBottomNavBar(),
      body: SafeArea(
        child: state.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.amber),
              )
            : RefreshIndicator(
                onRefresh: () => notifier.refresh(),
                color: AppColors.amber,
                backgroundColor: AppColors.surface,
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: AppSizes.width(20)),
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TrainerTopBar(),
                      if (state.clientRoster.isEmpty && !state.isLoading) ...[
                        SizedBox(height: AppSizes.height(50)),
                        EmptyStateWidget(
                          icon: Icons.people_outline_rounded,
                          title: 'Ready for your first client?',
                          message:
                              'Once you assign a workout to a client, their progress and activity will show up here.',
                          buttonText: 'Assign Workout',
                          onButtonPressed: () =>
                              context.push(AppRoutes.assignProgram),
                        ),
                        SizedBox(height: AppSizes.height(100)),
                      ] else ...[
                        SizedBox(height: AppSizes.height(20)),
                        TrainerQuickStatsRow(
                          totalClients: state.totalClients,
                          activeToday: state.activeToday,
                          alertsCount: state.skipAlerts.length,
                        ),
                        SizedBox(height: AppSizes.height(28)),
                        TrainerActivityPreview(activity: state.globalActivity),
                        SizedBox(height: AppSizes.height(28)),
                        const TrainerSessionsSection(),
                        if (state.skipAlerts.isNotEmpty) ...[
                          SizedBox(height: AppSizes.height(28)),
                          TrainerAlertsSection(clients: state.skipAlerts),
                        ],
                        SizedBox(height: AppSizes.height(28)),
                        TrainerClientRoster(clients: state.clientRoster),
                        SizedBox(height: AppSizes.height(28)),
                        const TrainerQuickActionsGrid(),
                        SizedBox(height: AppSizes.height(40)),
                      ],
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
