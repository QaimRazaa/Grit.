import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grit/features/trainer/data/repository/program_repository.dart';
import 'package:grit/features/trainer/viewmodel/program_builder_viewmodel.dart';
import 'package:grit/features/trainer/viewmodel/programs_list_viewmodel.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/device/responsive_size.dart';
import 'package:grit/utils/constants/text_styles.dart';
import 'package:grit/utils/popups/snackbar.dart';
import 'package:grit/features/trainer/data/models/client_profile_model.dart';
import 'package:grit/features/trainer/data/models/exercise_model.dart';
import 'package:grit/features/trainer/view/programs/widgets/exercise_library_sheet.dart';

String _formatDate(DateTime date) {
  final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  return '${date.day} ${months[date.month - 1]} ${date.year}';
}

class ProgramBuilderScreen extends ConsumerStatefulWidget {
  const ProgramBuilderScreen({super.key});

  @override
  ConsumerState<ProgramBuilderScreen> createState() => _ProgramBuilderScreenState();
}

class _ProgramBuilderScreenState extends ConsumerState<ProgramBuilderScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(programBuilderProvider);
    final notifier = ref.read(programBuilderProvider.notifier);

    // Listeners
    ref.listen(programBuilderProvider.select((s) => s.isSaved), (prev, next) {
      if (next) {
        AppSnackBar.showSuccess(context, 'Program assigned successfully!');
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
            _BuilderTopBar(
              currentStep: state.currentStep,
              onBack: () {
                if (state.currentStep > 0) {
                  notifier.prevStep();
                } else {
                  context.pop();
                }
              },
              onNext: _getNextAction(state, notifier),
              nextLabel: state.currentStep == 3 ? 'Assign' : 'Next',
            ),
            Expanded(
              child: state.isLoading 
                ? const Center(child: CircularProgressIndicator(color: AppColors.amber))
                : _buildCurrentStep(state.currentStep),
            ),
          ],
        ),
      ),
    );
  }

  VoidCallback? _getNextAction(ProgramBuilderState state, ProgramBuilderViewModel notifier) {
    if (state.currentStep == 0) return null; 
    if (state.currentStep == 1) return () => notifier.nextStep();
    if (state.currentStep == 2) return () => notifier.nextStep();
    if (state.currentStep == 3) return () => notifier.saveAndAssign();
    return null;
  }

  Widget _buildCurrentStep(int step) {
    switch (step) {
      case 0: return const _StepPickClient();
      case 1: return const _StepSetup();
      case 2: return const _StepBuild();
      case 3: return const _StepReview();
      default: return const SizedBox.shrink();
    }
  }
}

class _BuilderTopBar extends StatelessWidget {
  final int currentStep;
  final VoidCallback onBack;
  final VoidCallback? onNext;
  final String nextLabel;

  const _BuilderTopBar({
    required this.currentStep,
    required this.onBack,
    this.onNext,
    required this.nextLabel,
  });

  @override
  Widget build(BuildContext context) {
    final titles = ['Pick Client', 'Setup', 'Build Program', 'Review'];
    
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.width(4),
        vertical: AppSizes.height(4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: AppColors.muted),
            onPressed: onBack,
          ),
          Text(
            titles[currentStep],
            style: AppTextStyles.font16SemiBold,
          ),
          if (onNext != null)
            TextButton(
              onPressed: onNext,
              child: Text(
                nextLabel,
                style: AppTextStyles.font14Regular.copyWith(
                  color: AppColors.amber,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          else
            const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class _StepPickClient extends ConsumerWidget {
  const _StepPickClient({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clientsAsync = ref.watch(_clientsForPickerProvider);
    final assignments = ref.watch(programsListProvider.select((s) => s.assignments));
    final notifier = ref.read(programBuilderProvider.notifier);

    return clientsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator(color: AppColors.amber)),
      error: (e, _) => Center(child: Text('Error loading clients: $e', style: AppTextStyles.font14Regular.copyWith(color: AppColors.red))),
      data: (clients) {
        if (clients.isEmpty) {
          return Center(
            child: Text(
              'No clients found. Add some first!',
              style: AppTextStyles.font14RegularMuted,
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(AppSizes.width(20)),
          itemCount: clients.length,
          itemBuilder: (context, index) {
            final client = clients[index];
            final hasActive = assignments.any((a) => a.clientId == client.id && a.active);

            return Padding(
              padding: EdgeInsets.only(bottom: AppSizes.height(12)),
              child: GestureDetector(
                onTap: () async {
                  if (hasActive) {
                    final shouldReplace = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: AppColors.surface,
                        title: const Text('Active Program Exists', style: AppTextStyles.font18Bold),
                        content: const Text(
                          'Client already has an active program. Assigning a new one will replace it.',
                          style: AppTextStyles.font14Regular,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel', style: AppTextStyles.font14RegularMuted),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: Text(
                              'Replace',
                              style: AppTextStyles.font14Regular.copyWith(
                                color: AppColors.amber,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );

                    if (shouldReplace != true) return;
                  }

                  notifier.selectClient(client);
                  notifier.nextStep();
                },
                child: Container(
                  padding: EdgeInsets.all(AppSizes.width(16)),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppSizes.radius(16)),
                    border: Border.all(color: AppColors.borderDefault, width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: AppSizes.radius(20),
                            backgroundColor: AppColors.amber.withValues(alpha: 0.2),
                            child: Text(
                              client.initials,
                              style: AppTextStyles.font15Medium.copyWith(color: AppColors.amber),
                            ),
                          ),
                          SizedBox(width: AppSizes.width(12)),
                          Expanded(
                            child: Text(
                              client.fullName,
                              style: AppTextStyles.font16SemiBold,
                            ),
                          ),
                          const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
                        ],
                      ),
                      SizedBox(height: AppSizes.height(12)),
                      Wrap(
                        spacing: AppSizes.width(8),
                        runSpacing: AppSizes.height(8),
                        children: [
                          _Pill(label: client.primaryGoal ?? 'No Goal'),
                          _Pill(label: client.experienceLevel ?? 'Beginner'),
                          _Pill(label: '${client.daysPerWeek}x/week'),
                        ],
                      ),
                      if (client.injuries != null && client.injuries!.isNotEmpty) ...[
                        SizedBox(height: AppSizes.height(12)),
                        Container(
                          padding: EdgeInsets.all(AppSizes.width(8)),
                          decoration: BoxDecoration(
                            color: AppColors.red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(AppSizes.radius(8)),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.warning_amber_rounded, size: AppSizes.font(16), color: AppColors.red),
                              SizedBox(width: AppSizes.width(8)),
                              Expanded(
                                child: Text(
                                  client.injuries!,
                                  style: AppTextStyles.font12Regular.copyWith(color: AppColors.red),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  const _Pill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.width(10), vertical: AppSizes.height(4)),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.circular(AppSizes.radius(12)),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Text(
        label,
        style: AppTextStyles.font10SemiBold.copyWith(color: AppColors.muted),
      ),
    );
  }
}

final _clientsForPickerProvider = FutureProvider.autoDispose<List<ClientProfileModel>>((ref) {
  return ref.watch(programRepositoryProvider).loadClients();
});

class _StepSetup extends ConsumerStatefulWidget {
  const _StepSetup({super.key});

  @override
  ConsumerState<_StepSetup> createState() => _StepSetupState();
}

class _StepSetupState extends ConsumerState<_StepSetup> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(programBuilderProvider);
    _nameController = TextEditingController(text: state.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(programBuilderProvider);
    final notifier = ref.read(programBuilderProvider.notifier);
    final client = state.selectedClient;

    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSizes.width(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Client Summary Banner
          if (client != null)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(AppSizes.width(12)),
              decoration: BoxDecoration(
                color: AppColors.surface2.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(AppSizes.radius(12)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ASSIGNING TO',
                    style: AppTextStyles.font10SemiBold.copyWith(color: AppColors.muted, letterSpacing: 1),
                  ),
                  SizedBox(height: AppSizes.height(4)),
                  Text(
                    '${client.fullName} • ${client.primaryGoal ?? "No Goal"} • ${client.daysPerWeek}x/week',
                    style: AppTextStyles.font12Regular.copyWith(color: AppColors.white),
                  ),
                ],
              ),
            ),
          
          SizedBox(height: AppSizes.height(24)),

          // SECTION: Basics
          _SectionHeader(title: 'PROGRAM BASICS'),
          SizedBox(height: AppSizes.height(12)),
          
          Container(
            padding: EdgeInsets.all(AppSizes.width(16)),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSizes.radius(16)),
              border: Border.all(color: AppColors.borderDefault),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('PROGRAM NAME', style: AppTextStyles.font10SemiBold.copyWith(color: AppColors.muted)),
                TextField(
                  controller: _nameController,
                  onChanged: notifier.setName,
                  style: AppTextStyles.font16SemiBold,
                  decoration: InputDecoration(
                    hintText: 'e.g. Hypertrophy Phase 1',
                    hintStyle: AppTextStyles.font16SemiBold.copyWith(color: AppColors.dim),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: AppSizes.height(8)),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: AppSizes.height(20)),

          // SECTION: Level
          _SectionHeader(title: 'EXPERIENCE LEVEL'),
          SizedBox(height: AppSizes.height(12)),
          Row(
            children: ['Beginner', 'Intermediate', 'Advanced'].map((level) {
              final selected = state.level == level;
              return Expanded(
                child: GestureDetector(
                  onTap: () => notifier.setLevel(level),
                  child: Container(
                    margin: EdgeInsets.only(right: level == 'Advanced' ? 0 : AppSizes.width(8)),
                    padding: EdgeInsets.symmetric(vertical: AppSizes.height(10)),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.amber : AppColors.surface,
                      borderRadius: BorderRadius.circular(AppSizes.radius(12)),
                      border: Border.all(color: selected ? AppColors.amber : AppColors.borderDefault),
                    ),
                    child: Center(
                      child: Text(
                        level,
                        style: AppTextStyles.font12SemiBold.copyWith(
                          color: selected ? AppColors.background : AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          SizedBox(height: AppSizes.height(28)),

          // SECTION: Schedule
          _SectionHeader(title: 'SCHEDULE'),
          SizedBox(height: AppSizes.height(12)),
          
          Row(
            children: [
              // Weeks Stepper
              Expanded(
                child: _MetricCard(
                  label: 'TOTAL WEEKS',
                  value: '${state.weeks}',
                  onDecrement: () => notifier.setWeeks(state.weeks - 1),
                  onIncrement: () => notifier.setWeeks(state.weeks + 1),
                ),
              ),
              SizedBox(width: AppSizes.width(16)),
              // Days Lock
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(AppSizes.width(12)),
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
                          Text('DAYS/WEEK', style: AppTextStyles.font10SemiBold.copyWith(color: AppColors.muted)),
                          Icon(Icons.lock_outline_rounded, size: AppSizes.font(12), color: AppColors.dim),
                        ],
                      ),
                      SizedBox(height: AppSizes.height(8)),
                      Text('${state.daysPerWeek}', style: AppTextStyles.font18Bold),
                      SizedBox(height: AppSizes.height(2)),
                      Text('Fixed from goal form', style: AppTextStyles.font10RegularMuted),
                    ],
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: AppSizes.height(20)),

          // SECTION: Start Date
          _SectionHeader(title: 'START DATE'),
          SizedBox(height: AppSizes.height(12)),
          GestureDetector(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: state.startDate,
                firstDate: DateTime.now().subtract(const Duration(days: 30)),
                lastDate: DateTime.now().add(const Duration(days: 365)),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.dark(
                        primary: AppColors.amber,
                        onPrimary: AppColors.background,
                        surface: AppColors.surface,
                        onSurface: AppColors.white,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (picked != null) notifier.setStartDate(picked);
            },
            child: Container(
              padding: EdgeInsets.all(AppSizes.width(16)),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSizes.radius(16)),
                border: Border.all(color: AppColors.borderDefault),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDate(state.startDate),
                    style: AppTextStyles.font15Medium,
                  ),
                  const Icon(Icons.calendar_today_rounded, color: AppColors.amber, size: 18),
                ],
              ),
            ),
          ),
          
          SizedBox(height: AppSizes.height(100)),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});
  @override
  Widget build(BuildContext context) => Text(
    title,
    style: AppTextStyles.font11RegularDim.copyWith(letterSpacing: 1),
  );
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const _MetricCard({
    required this.label,
    required this.value,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.width(12)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radius(16)),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.font10SemiBold.copyWith(color: AppColors.muted)),
          SizedBox(height: AppSizes.height(8)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _MiniButton(icon: Icons.remove, onTap: onDecrement),
              Text(value, style: AppTextStyles.font18Bold),
              _MiniButton(icon: Icons.add, onTap: onIncrement),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _MiniButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppSizes.width(4)),
        decoration: BoxDecoration(
          color: AppColors.surface2,
          borderRadius: BorderRadius.circular(AppSizes.radius(8)),
        ),
        child: Icon(icon, color: AppColors.amber, size: 16),
      ),
    );
  }
}

class _StepBuild extends ConsumerStatefulWidget {
  const _StepBuild({super.key});

  @override
  ConsumerState<_StepBuild> createState() => _StepBuildState();
}

class _StepBuildState extends ConsumerState<_StepBuild> {
  int _selectedWeek = 1;

  void _addExercises(int day) {
    final state = ref.read(programBuilderProvider);
    final exercisesAsync = ref.read(exerciseLibraryProvider);
    final notifier = ref.read(programBuilderProvider.notifier);

    final injuries = state.selectedClient?.injuries?.split(',').map((s) => s.trim()).toList();

    exercisesAsync.when(
      data: (exercises) {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => ExerciseLibrarySheet(
            initialAdded: const [], // Always start empty for slot-specific adds
            exercises: exercises,
            injuryKeywords: injuries,
            onDone: (added) {
              for (final ex in added) {
                notifier.addExerciseToSlot(_selectedWeek, day, ex);
              }
            },
          ),
        );
      },
      loading: () {}, // Handled by the button state if needed, but per-tap is fine here
      error: (e, _) => AppSnackBar.showError(context, 'Error loading exercises: $e'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(programBuilderProvider);
    final notifier = ref.read(programBuilderProvider.notifier);
    final client = state.selectedClient;

    return Column(
      children: [
        // Week Tabs
        Container(
          height: AppSizes.height(60),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border(bottom: BorderSide(color: AppColors.borderDefault)),
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: AppSizes.width(16), vertical: AppSizes.height(10)),
            itemCount: state.weeks,
            itemBuilder: (context, index) {
              final week = index + 1;
              final selected = _selectedWeek == week;
              return GestureDetector(
                onTap: () => setState(() => _selectedWeek = week),
                child: Container(
                  margin: EdgeInsets.only(right: AppSizes.width(8)),
                  padding: EdgeInsets.symmetric(horizontal: AppSizes.width(16)),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.amber : AppColors.surface2,
                    borderRadius: BorderRadius.circular(AppSizes.radius(100)),
                    border: Border.all(color: selected ? AppColors.amber : AppColors.borderDefault),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Week $week',
                    style: AppTextStyles.font12SemiBold.copyWith(
                      color: selected ? AppColors.background : AppColors.muted,
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        Expanded(
          child: ListView(
            padding: EdgeInsets.all(AppSizes.width(20)),
            children: [
              // Injury Warning
              if (client?.injuries != null && client!.injuries!.isNotEmpty)
                Container(
                  padding: EdgeInsets.all(AppSizes.width(12)),
                  margin: EdgeInsets.only(bottom: AppSizes.height(20)),
                  decoration: BoxDecoration(
                    color: AppColors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSizes.radius(12)),
                    border: Border.all(color: AppColors.red.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber_rounded, size: 20, color: AppColors.red),
                      SizedBox(width: AppSizes.width(12)),
                      Expanded(
                        child: Text(
                          'CLIENT INJURY: ${client.injuries}',
                          style: AppTextStyles.font12Regular.copyWith(color: AppColors.red),
                        ),
                      ),
                    ],
                  ),
                ),

              // Day Slots
              ...List.generate(state.daysPerWeek, (index) {
                final day = index + 1;
                final dayLabel = state.dayLabels["day_$day"];
                final exercises = state.exercisesFor(_selectedWeek, day);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Day Label Row
                    GestureDetector(
                      onTap: () async {
                        final controller = TextEditingController(text: dayLabel);
                        final newLabel = await showDialog<String>(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: AppColors.surface,
                            surfaceTintColor: Colors.transparent,
                            title: Text('Day $day Label', style: AppTextStyles.font16SemiBold),
                            content: TextField(
                              controller: controller,
                              autofocus: true,
                              style: AppTextStyles.font14Regular,
                              decoration: const InputDecoration(
                                hintText: 'e.g. Upper Body Power',
                                hintStyle: AppTextStyles.font14RegularDim,
                                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.borderDefault)),
                                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.amber)),
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Cancel', style: AppTextStyles.font14RegularMuted.copyWith(fontWeight: FontWeight.w600)),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, controller.text),
                                child: Text(
                                  'Save',
                                  style: AppTextStyles.font14Regular.copyWith(
                                    color: AppColors.amber,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                        if (newLabel != null) {
                          notifier.setDayLabel(day, newLabel);
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.only(bottom: AppSizes.height(4)),
                        child: Text(
                          dayLabel != null && dayLabel.isNotEmpty ? dayLabel.toUpperCase() : "ADD DAY LABEL",
                          style: AppTextStyles.font10SemiBold.copyWith(
                            color: dayLabel != null ? AppColors.amber : AppColors.muted,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('DAY $day', style: AppTextStyles.font11SemiBold.copyWith(color: AppColors.muted, letterSpacing: 1)),
                        IconButton(
                          onPressed: () => _addExercises(day),
                          icon: const Icon(Icons.add, color: AppColors.amber, size: 20),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                    if (exercises.isEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: AppSizes.height(20)),
                        child: Center(
                          child: Text(
                            'No exercises added for this day.',
                            style: AppTextStyles.font12RegularMuted,
                          ),
                        ),
                      )
                    else
                      ...exercises.asMap().entries.map((entry) {
                        return _ExerciseSlotItem(
                          exercise: entry.value,
                          onUpdate: (updated) => notifier.updateExerciseInSlot(_selectedWeek, day, entry.key, updated),
                          onRemove: () => notifier.removeExerciseFromSlot(_selectedWeek, day, entry.key),
                        );
                      }),
                    if (day < state.daysPerWeek)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: AppSizes.height(16)),
                        child: Divider(color: AppColors.borderDefault, thickness: 1),
                      ),
                  ],
                );
              }),
              
              SizedBox(height: AppSizes.height(100)),
            ],
          ),
        ),
      ],
    );
  }
}

class _ExerciseSlotItem extends StatefulWidget {
  final ExerciseModel exercise;
  final ValueChanged<ExerciseModel> onUpdate;
  final VoidCallback onRemove;

  const _ExerciseSlotItem({
    required this.exercise,
    required this.onRemove,
    required this.onUpdate,
  });

  @override
  State<_ExerciseSlotItem> createState() => _ExerciseSlotItemState();
}

class _ExerciseSlotItemState extends State<_ExerciseSlotItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _isExpanded = !_isExpanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(top: AppSizes.height(8)),
        padding: EdgeInsets.all(AppSizes.width(12)),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radius(16)),
          border: Border.all(
            color: _isExpanded ? AppColors.amber.withValues(alpha: 0.3) : AppColors.borderDefault,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.exercise.name, style: AppTextStyles.font15Medium),
                      if (!_isExpanded)
                        Padding(
                          padding: EdgeInsets.only(top: AppSizes.height(2)),
                          child: Text(
                            '${widget.exercise.sets} sets x ${widget.exercise.toFailure ? "Failure" : widget.exercise.reps}',
                            style: AppTextStyles.font11RegularDim,
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline, color: AppColors.red, size: 20),
                  onPressed: widget.onRemove,
                ),
              ],
            ),
            if (_isExpanded) ...[
              SizedBox(height: AppSizes.height(16)),
              Row(
                children: [
                  Expanded(
                    child: _StepperBlock(
                      label: 'SETS',
                      value: '${widget.exercise.sets}',
                      onDecrement: () => widget.onUpdate(widget.exercise.copyWith(sets: (widget.exercise.sets - 1).clamp(1, 20))),
                      onIncrement: () => widget.onUpdate(widget.exercise.copyWith(sets: (widget.exercise.sets + 1).clamp(1, 20))),
                    ),
                  ),
                  SizedBox(width: AppSizes.width(12)),
                  Expanded(
                    child: _StepperBlock(
                      label: 'REPS',
                      value: widget.exercise.toFailure ? 'Fail' : '${widget.exercise.reps}',
                      disabled: widget.exercise.toFailure,
                      onDecrement: () => widget.onUpdate(widget.exercise.copyWith(reps: (widget.exercise.reps - 1).clamp(1, 100))),
                      onIncrement: () => widget.onUpdate(widget.exercise.copyWith(reps: (widget.exercise.reps + 1).clamp(1, 100))),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSizes.height(16)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('TILL FAILURE', style: AppTextStyles.font11SemiBold.copyWith(color: AppColors.muted)),
                  GestureDetector(
                    onTap: () => widget.onUpdate(widget.exercise.copyWith(toFailure: !widget.exercise.toFailure)),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: AppSizes.width(12), vertical: AppSizes.height(6)),
                      decoration: BoxDecoration(
                        color: widget.exercise.toFailure ? AppColors.amber : AppColors.surface2,
                        borderRadius: BorderRadius.circular(AppSizes.radius(8)),
                      ),
                      child: Text(
                        widget.exercise.toFailure ? 'ON' : 'OFF',
                        style: AppTextStyles.font10SemiBold.copyWith(
                          color: widget.exercise.toFailure ? AppColors.background : AppColors.dim,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StepperBlock extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final bool disabled;

  const _StepperBlock({
    required this.label,
    required this.value,
    required this.onDecrement,
    required this.onIncrement,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.width(8)),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.circular(AppSizes.radius(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.font10SemiBold.copyWith(color: AppColors.muted)),
          SizedBox(height: AppSizes.height(8)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _MiniButton(icon: Icons.remove, onTap: disabled ? () {} : onDecrement),
              Text(
                value,
                style: AppTextStyles.font16Bold.copyWith(
                  color: disabled ? AppColors.dim : AppColors.white,
                ),
              ),
              _MiniButton(icon: Icons.add, onTap: disabled ? () {} : onIncrement),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepReview extends ConsumerWidget {
  const _StepReview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(programBuilderProvider);
    final client = state.selectedClient!;

    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSizes.width(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          Container(
            padding: EdgeInsets.all(AppSizes.width(16)),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSizes.radius(16)),
              border: Border.all(color: AppColors.borderDefault),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(client.fullName, style: AppTextStyles.font18Bold),
                SizedBox(height: AppSizes.height(12)),
                Wrap(
                  spacing: AppSizes.width(8),
                  runSpacing: AppSizes.height(8),
                  children: [
                    _Pill(label: state.name),
                    _Pill(label: state.level),
                    _Pill(label: '${state.weeks} weeks'),
                    _Pill(label: '${state.daysPerWeek} days/week'),
                  ],
                ),
                SizedBox(height: AppSizes.height(16)),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_rounded, size: 14, color: AppColors.amber),
                    SizedBox(width: AppSizes.width(8)),
                    Text(
                      'Starts ${_formatDate(state.startDate)}',
                      style: AppTextStyles.font12RegularMuted,
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: AppSizes.height(28)),

          // Week Summaries
          ...List.generate(state.weeks, (wIdx) {
            final week = wIdx + 1;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionHeader(title: 'WEEK $week'),
                SizedBox(height: AppSizes.height(12)),
                Container(
                  padding: EdgeInsets.all(AppSizes.width(4)),
                  margin: EdgeInsets.only(bottom: AppSizes.height(24)),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppSizes.radius(12)),
                    border: Border.all(color: AppColors.borderDefault),
                  ),
                  child: Column(
                    children: List.generate(state.daysPerWeek, (dIdx) {
                      final day = dIdx + 1;
                      final count = state.exercisesFor(week, day).length;
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppSizes.width(12), vertical: AppSizes.height(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Day $day', style: AppTextStyles.font13Regular.copyWith(color: AppColors.muted)),
                            Text(
                              '$count ${count == 1 ? "exercise" : "exercises"}',
                              style: count > 0 ? AppTextStyles.font13Medium : AppTextStyles.font13RegularMuted,
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ],
            );
          }),

          // Bottom Stats
          const Divider(color: AppColors.borderDefault),
          SizedBox(height: AppSizes.height(12)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('TOTAL EXERCISES', style: AppTextStyles.font11SemiBold.copyWith(color: AppColors.muted)),
              Text('${state.exercises.length}', style: AppTextStyles.font18Bold.copyWith(color: AppColors.amber)),
            ],
          ),
          SizedBox(height: AppSizes.height(8)),
          Text(
            'Program will start ${_formatDate(state.startDate)}',
            style: AppTextStyles.font12RegularMuted,
          ),

          SizedBox(height: AppSizes.height(100)),
        ],
      ),
    );
  }
}
