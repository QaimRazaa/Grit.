import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grit/core/routes/app_routes.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/text_styles.dart';
import 'package:grit/utils/device/responsive_size.dart';
import '../../viewmodel/logs/trainer_logs_viewmodel.dart';

class TrainerLogsScreen extends ConsumerWidget {
  const TrainerLogsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(trainerLogsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Workout Activity Feed',
          style: AppTextStyles.font18SemiBold,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.amber),
            onPressed: () => ref.read(trainerLogsProvider.notifier).refresh(),
          ),
        ],
      ),
      body: state.isLoading && state.logs.isEmpty
          ? const Center(child: CircularProgressIndicator(color: AppColors.amber))
          : state.error != null
              ? Center(child: Text('Error: ${state.error}', style: TextStyle(color: AppColors.red)))
              : RefreshIndicator(
                  onRefresh: () => ref.read(trainerLogsProvider.notifier).refresh(),
                  color: AppColors.amber,
                  child: state.logs.isEmpty
                      ? ListView(
                          children: [
                            SizedBox(height: AppSizes.height(100)),
                            Center(child: Text('No activity logs found yet.', style: AppTextStyles.font14RegularMuted)),
                          ],
                        )
                      : ListView.builder(
                          padding: EdgeInsets.all(AppSizes.width(20)),
                          itemCount: state.logs.length,
                          itemBuilder: (context, index) {
                            final log = state.logs[index];
                            return _LogActivityCard(log: log);
                          },
                        ),
                ),
    );
  }
}

class _LogActivityCard extends StatelessWidget {
  final Map<String, dynamic> log;

  const _LogActivityCard({required this.log});

  String _getTimeAgo(String? createdAt) {
    if (createdAt == null) return 'Unknown';
    final date = DateTime.parse(createdAt);
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return createdAt.split('T')[0];
  }

  @override
  Widget build(BuildContext context) {
    final clientName = log['client_name'] ?? 'Unknown Client';
    final exerciseName = log['exercise_name'] ?? 'Workout';
    final weight = log['weight']?.toString() ?? '0';
    final reps = log['reps']?.toString() ?? '0';
    final setNumber = log['set_number']?.toString() ?? '1';
    final createdAt = log['created_at']?.toString();
    final clientId = log['client_id']?.toString();

    return GestureDetector(
      onTap: () {
        if (clientId != null) {
          context.push('${AppRoutes.clientProfile}/$clientId');
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: AppSizes.height(12)),
        padding: EdgeInsets.all(AppSizes.width(16)),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radius(16)),
          border: Border.all(color: AppColors.borderDefault, width: 1),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: AppSizes.width(40),
              height: AppSizes.width(40),
              decoration: BoxDecoration(
                color: AppColors.surface2,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.fitness_center_rounded, color: AppColors.amber, size: 20),
            ),
            SizedBox(width: AppSizes.width(12)),
            
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        clientName,
                        style: AppTextStyles.font14RegularMuted.copyWith(color: AppColors.white),
                      ),
                      Text(
                        _getTimeAgo(createdAt),
                        style: AppTextStyles.font11RegularDim,
                      ),
                    ],
                  ),
                  SizedBox(height: AppSizes.height(4)),
                  Text(
                    '$exerciseName • Set $setNumber',
                    style: AppTextStyles.font13Regular.copyWith(color: AppColors.amber),
                  ),
                  SizedBox(height: AppSizes.height(2)),
                  Text(
                    '$weight kg x $reps reps',
                    style: AppTextStyles.font12RegularMuted,
                  ),
                ],
              ),
            ),
            
            Icon(Icons.chevron_right_rounded, color: AppColors.dim, size: 20),
          ],
        ),
      ),
    );
  }
}
