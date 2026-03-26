import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grit/features/trainer/viewmodel/client_profile_viewmodel.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/text_styles.dart';
import 'package:grit/utils/device/responsive_size.dart';

class ClientProfileScreen extends ConsumerWidget {
  final String clientId;

  const ClientProfileScreen({super.key, required this.clientId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(clientProfileProvider(clientId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          state.client?.fullName ?? 'Client Profile',
          style: AppTextStyles.font18SemiBold,
        ),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.amber))
          : state.error != null
              ? Center(child: Text(state.error!, style: AppTextStyles.font14Regular))
              : SingleChildScrollView(
                  padding: EdgeInsets.all(AppSizes.width(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ProfileHeader(client: state.client!),
                      SizedBox(height: AppSizes.height(28)),
                      _CurrentProgramSection(assignment: state.activeAssignment),
                      SizedBox(height: AppSizes.height(28)),
                      _GoalInformationSection(goals: state.goals),
                      SizedBox(height: AppSizes.height(28)),
                      _Last7DaysSection(activity: state.last7DaysActivity),
                      SizedBox(height: AppSizes.height(28)),
                      _WorkoutHistorySection(workoutLogs: state.workoutLogs),
                      SizedBox(height: AppSizes.height(40)),
                    ],
                  ),
                ),
    );
  }
}

class _Last7DaysSection extends StatelessWidget {
  final List<bool> activity;
  const _Last7DaysSection({required this.activity});

  @override
  Widget build(BuildContext context) {
    const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Weekly Activity', style: AppTextStyles.font16SemiBold),
        SizedBox(height: AppSizes.height(14)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(7, (i) {
            final active = activity[i];
            return Column(
              children: [
                Text(days[i], style: AppTextStyles.font11RegularDim),
                SizedBox(height: AppSizes.height(8)),
                Container(
                  width: AppSizes.width(36),
                  height: AppSizes.width(36),
                  decoration: BoxDecoration(
                    color: active ? AppColors.amber : AppColors.surface,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: active ? AppColors.amber : AppColors.borderDefault,
                      width: 1.5,
                    ),
                  ),
                  child: active 
                      ? const Icon(Icons.check, color: AppColors.background, size: 20)
                      : null,
                ),
              ],
            );
          }),
        ),
      ],
    );
  }
}

class _WorkoutHistorySection extends StatelessWidget {
  final List<Map<String, dynamic>> workoutLogs;
  const _WorkoutHistorySection({required this.workoutLogs});

  @override
  Widget build(BuildContext context) {
    if (workoutLogs.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Workout History', style: AppTextStyles.font16SemiBold),
          SizedBox(height: AppSizes.height(14)),
          const Text('No workout history yet.', style: AppTextStyles.font14RegularDim),
        ],
      );
    }

    final Map<String, List<Map<String, dynamic>>> groupedLogs = {};
    for (var log in workoutLogs) {
      final date = log['date']?.toString() ?? 'Unknown Date';
      groupedLogs.putIfAbsent(date, () => []).add(log);
    }

    final sortedDates = groupedLogs.keys.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Workout History', style: AppTextStyles.font16SemiBold),
        SizedBox(height: AppSizes.height(14)),
        ...sortedDates.map((date) {
          final logs = groupedLogs[date]!;
          return Container(
            margin: EdgeInsets.only(bottom: AppSizes.height(16)),
            padding: EdgeInsets.all(AppSizes.width(16)),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSizes.radius(16)),
              border: Border.all(color: AppColors.borderDefault),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_formatDateString(date), style: AppTextStyles.font13SemiBold.copyWith(color: AppColors.amber)),
                    Text('${logs.length} sets', style: AppTextStyles.font11RegularDim),
                  ],
                ),
                SizedBox(height: AppSizes.height(12)),
                ...logs.map((log) => Padding(
                  padding: EdgeInsets.only(bottom: AppSizes.height(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          log['exercise_name']?.toString() ?? 'Exercise',
                          style: AppTextStyles.font13Regular,
                        ),
                      ),
                      Text(
                        log['reps'] == 0 
                            ? 'Failure x ${log['weight']} kg' 
                            : '${log['reps']} reps x ${log['weight']} kg',
                        style: AppTextStyles.font12Medium,
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
  }

  String _formatDateString(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    } catch (e) {
      return dateStr;
    }
  }
}

class _ProfileHeader extends StatelessWidget {
  final dynamic client;

  const _ProfileHeader({required this.client});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: AppSizes.width(70),
          height: AppSizes.width(70),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surface,
            border: Border.all(color: AppColors.amber, width: 2),
          ),
          child: Center(
            child: Text(
              client.initials,
              style: AppTextStyles.font24Bold.copyWith(color: AppColors.white),
            ),
          ),
        ),
        SizedBox(width: AppSizes.width(16)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                client.fullName,
                style: AppTextStyles.font20Bold,
              ),
              SizedBox(height: AppSizes.height(4)),
              Text(
                client.primaryGoal ?? 'No Goal Set',
                style: AppTextStyles.font14Regular.copyWith(color: AppColors.muted),
              ),
              SizedBox(height: AppSizes.height(8)),
              Container(
                padding: EdgeInsets.symmetric(horizontal: AppSizes.width(10), vertical: AppSizes.height(4)),
                decoration: BoxDecoration(
                  color: AppColors.amber.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radius(12)),
                ),
                child: Text(
                  '🔥 ${client.streak?.currentStreak ?? 0} Day Streak',
                  style: AppTextStyles.font12Medium.copyWith(color: AppColors.amber),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CurrentProgramSection extends StatelessWidget {
  final dynamic assignment;

  const _CurrentProgramSection({this.assignment});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Current Program', style: AppTextStyles.font16SemiBold),
        SizedBox(height: AppSizes.height(14)),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(AppSizes.width(16)),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSizes.radius(16)),
            border: Border.all(color: AppColors.borderDefault),
          ),
          child: assignment == null
              ? const Text('No active program assigned', style: AppTextStyles.font14RegularDim)
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(assignment.programName ?? 'Custom Plan', style: AppTextStyles.font15Medium),
                    SizedBox(height: AppSizes.height(8)),
                    LinearProgressIndicator(
                      value: assignment.progressPercentage,
                      backgroundColor: AppColors.surface2,
                      color: AppColors.amber,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    SizedBox(height: AppSizes.height(8)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Day ${assignment.currentDay} of ${assignment.totalDays}',
                            style: AppTextStyles.font12RegularMuted),
                        Text('${(assignment.progressPercentage * 100).toInt()}%',
                            style: AppTextStyles.font12SemiBold.copyWith(color: AppColors.amber)),
                      ],
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}

class _GoalInformationSection extends StatelessWidget {
  final dynamic goals;

  const _GoalInformationSection({this.goals});

  @override
  Widget build(BuildContext context) {
    if (goals == null) return const SizedBox.shrink();

    final details = [
      {'label': 'Experience', 'value': goals.experienceLevel ?? '-'},
      {'label': 'Days/Week', 'value': goals.daysPerWeek ?? '-'},
      {'label': 'Gym Access', 'value': goals.gymAccess ?? '-'},
      {'label': 'Training Time', 'value': goals.trainingTime ?? '-'},
      {'label': 'Age', 'value': goals.age?.toString() ?? '-'},
      {'label': 'Weight', 'value': '${goals.weight ?? '-'} kg'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Goal Form Details', style: AppTextStyles.font16SemiBold),
        SizedBox(height: AppSizes.height(14)),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppSizes.width(12),
            mainAxisSpacing: AppSizes.height(12),
            childAspectRatio: 2.2,
          ),
          itemCount: details.length,
          itemBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.all(AppSizes.width(10)),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSizes.radius(12)),
                border: Border.all(color: AppColors.borderDefault),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(details[index]['label']!, style: AppTextStyles.font10RegularMuted),
                  SizedBox(height: AppSizes.height(2)),
                  Text(details[index]['value']!, style: AppTextStyles.font13SemiBold),
                ],
              ),
            );
          },
        ),
        if (goals.injuries != null && goals.injuries!.isNotEmpty) ...[
          SizedBox(height: AppSizes.height(20)),
          Text('Injuries/Notes', style: AppTextStyles.font12SemiBold),
          SizedBox(height: AppSizes.height(6)),
          Text(goals.injuries!, style: AppTextStyles.font13Regular.copyWith(color: AppColors.red)),
        ],
      ],
    );
  }
}
