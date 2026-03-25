import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grit/features/trainer/view/assign/widgets/assign_step_indicator.dart';
import 'package:grit/features/trainer/view/assign/widgets/client_dropdown.dart';
import 'package:grit/features/trainer/view/programs/widgets/goal_summary_card.dart';
import 'package:grit/features/trainer/viewmodel/assign_program_viewmodel.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/text_styles.dart';
import 'package:grit/utils/device/responsive_size.dart';
import 'package:grit/utils/popups/snackbar.dart';

class AssignProgramScreen extends ConsumerStatefulWidget {
  const AssignProgramScreen({super.key});

  @override
  ConsumerState<AssignProgramScreen> createState() => _AssignProgramScreenState();
}

class _AssignProgramScreenState extends ConsumerState<AssignProgramScreen> {
  
  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  Future<void> _selectDate() async {
    final state = ref.read(assignProgramProvider);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: state.startDate,
      firstDate: DateTime.now(),
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
            dialogBackgroundColor: AppColors.background,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      ref.read(assignProgramProvider.notifier).setStartDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(assignProgramProvider);
    final notifier = ref.read(assignProgramProvider.notifier);

    ref.listen(assignProgramProvider.select((s) => s.isAssigned), (prev, next) {
      if (next) {
        AppSnackBar.showSuccess(context, 'Program assigned successfully!');
        context.pop();
      }
    });

    ref.listen(assignProgramProvider.select((s) => s.error), (prev, next) {
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
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.width(4),
                vertical: AppSizes.height(4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (state.currentStep > 0) {
                        notifier.prevStep();
                      } else {
                        context.pop();
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.width(16),
                        vertical: AppSizes.height(12),
                      ),
                      child: Icon(
                        state.currentStep > 0 ? Icons.arrow_back_rounded : Icons.close_rounded,
                        color: AppColors.muted,
                        size: AppSizes.font(22),
                      ),
                    ),
                  ),
                  Text(
                    'Assign Program',
                    style: AppTextStyles.font16SemiBold,
                  ),
                  SizedBox(width: AppSizes.width(54)),
                ],
              ),
            ),

            SizedBox(height: AppSizes.height(16)),

            // Step indicator
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.width(20)),
              child: AssignStepIndicator(currentStep: state.currentStep),
            ),

            SizedBox(height: AppSizes.height(28)),

            // Step content
            Expanded(
              child: state.isLoading 
                ? const Center(child: CircularProgressIndicator(color: AppColors.amber))
                : SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: AppSizes.width(20)),
                child: _buildStepContent(state, notifier),
              ),
            ),

            // Bottom CTA
            Padding(
              padding: EdgeInsets.only(
                left: AppSizes.width(20),
                right: AppSizes.width(20),
                bottom: AppSizes.height(24),
              ),
              child: GestureDetector(
                onTap: state.canProceed && !state.isLoading
                    ? () {
                        if (state.currentStep < 2) {
                          notifier.nextStep();
                        } else {
                          notifier.assign();
                        }
                      }
                    : null,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: AppSizes.height(18)),
                  decoration: BoxDecoration(
                    color: state.canProceed ? AppColors.amber : AppColors.surface,
                    borderRadius: BorderRadius.circular(AppSizes.radius(16)),
                    border: state.canProceed ? null : Border.all(color: AppColors.borderDefault),
                    boxShadow: state.canProceed
                        ? [
                            BoxShadow(
                              color: AppColors.amber.withOpacity(0.25),
                              blurRadius: 20,
                              offset: const Offset(0, 4),
                            )
                          ]
                        : null,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSizes.width(16)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          state.currentStep == 2 ? 'Assign Program' : 'Continue',
                          style: AppTextStyles.font16Bold.copyWith(
                            color: state.canProceed ? AppColors.background : AppColors.dim,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: state.canProceed ? AppColors.background : AppColors.dim,
                          size: AppSizes.font(18),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent(AssignProgramState state, AssignProgramViewModel notifier) {
    if (state.currentStep == 0) return _buildStepSelectClient(state, notifier);
    if (state.currentStep == 1) return _buildStepSelectProgram(state, notifier);
    return _buildStepConfirm(state, notifier);
  }

  Widget _buildStepSelectClient(AssignProgramState state, AssignProgramViewModel notifier) {
    final selectedClient = state.selectedClientId != null 
        ? state.clients.firstWhere((c) => c.id == state.selectedClientId)
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SELECT CLIENT',
          style: AppTextStyles.font11RegularDim.copyWith(letterSpacing: 0.8),
        ),
        SizedBox(height: AppSizes.height(12)),
        ClientDropdown(
          clients: state.clients.map((c) => {'id': c.id, 'name': c.fullName, 'initials': c.initials}).toList(),
          selectedIndex: state.selectedClientId != null 
              ? state.clients.indexWhere((c) => c.id == state.selectedClientId)
              : null,
          onChanged: (i) => notifier.selectClient(state.clients[i].id),
        ),
        if (selectedClient != null) ...[
          SizedBox(height: AppSizes.height(16)),
          GoalSummaryCard(
            goalDays: selectedClient.daysPerWeek ?? 0, 
            goal: selectedClient.primaryGoal ?? 'Not set',
            level: selectedClient.experienceLevel ?? 'Not set',
            duration: state.durationWeeks,
          ),
        ],

      ],
    );
  }

  Widget _buildStepSelectProgram(AssignProgramState state, AssignProgramViewModel notifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SELECT PROGRAM',
          style: AppTextStyles.font11RegularDim.copyWith(letterSpacing: 0.8),
        ),
        SizedBox(height: AppSizes.height(12)),

        Text(
          'AVAILABLE TEMPLATES',
          style: AppTextStyles.font10SemiBold.copyWith(
            color: AppColors.dim,
            letterSpacing: 0.8,
          ),
        ),
        SizedBox(height: AppSizes.height(10)),
        if (state.programs.isEmpty)
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: AppSizes.height(20)),
              child: Text('No programs found', style: AppTextStyles.font14RegularMuted),
            ),
          )
        else
          ...state.programs.map((p) => _SelectableProgramCard(
                name: p.name,
                tag: '${p.exercises.length} Exercises',
                isSelected: state.selectedProgramId == p.id,
                onTap: () => notifier.selectProgram(p.id),
              )),
      ],
    );
  }

  Widget _buildStepConfirm(AssignProgramState state, AssignProgramViewModel notifier) {
    final client = state.clients.firstWhere((c) => c.id == state.selectedClientId);
    final program = state.programs.firstWhere((p) => p.id == state.selectedProgramId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'REVIEW & CONFIRM',
          style: AppTextStyles.font11RegularDim.copyWith(letterSpacing: 0.8),
        ),
        SizedBox(height: AppSizes.height(12)),

        Container(
          padding: AppSizes.paddingAll(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSizes.radius(16)),
            border: Border.all(
              color: AppColors.amber.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              // Client row
              Row(
                children: [
                  Container(
                    width: AppSizes.width(40),
                    height: AppSizes.width(40),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.background,
                      border: Border.all(color: AppColors.amber, width: 2),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      client.initials,
                      style: AppTextStyles.font13Regular.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.amber,
                      ),
                    ),
                  ),
                  SizedBox(width: AppSizes.width(12)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Client', style: AppTextStyles.font10Regular.copyWith(color: AppColors.muted)),
                      Text(client.fullName, style: AppTextStyles.font15Medium.copyWith(fontWeight: FontWeight.w600)),
                    ],
                  ),
                ],
              ),

              // Divider
              Container(
                height: 1,
                color: AppColors.borderDefault,
                margin: EdgeInsets.symmetric(vertical: AppSizes.height(16)),
              ),

              // Program row
              Row(
                children: [
                  Container(
                    width: AppSizes.width(40),
                    height: AppSizes.width(40),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSizes.radius(10)),
                      color: AppColors.amber.withOpacity(0.12),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.fitness_center_rounded,
                      color: AppColors.amber,
                      size: AppSizes.font(18),
                    ),
                  ),
                  SizedBox(width: AppSizes.width(12)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Program', style: AppTextStyles.font10Regular.copyWith(color: AppColors.muted)),
                      Text(program.name, style: AppTextStyles.font15Medium.copyWith(fontWeight: FontWeight.w600)),
                    ],
                  ),
                ],
              ),

              // Divider
              Container(
                height: 1,
                color: AppColors.borderDefault,
                margin: EdgeInsets.symmetric(vertical: AppSizes.height(16)),
              ),

              // Duration row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        color: AppColors.amber,
                        size: AppSizes.font(18),
                      ),
                      SizedBox(width: AppSizes.width(12)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Duration', style: AppTextStyles.font10Regular.copyWith(color: AppColors.muted)),
                          Text(
                            '${state.durationWeeks} Weeks',
                            style: AppTextStyles.font15Medium.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _DurationButton(
                        icon: Icons.remove,
                        onTap: state.durationWeeks > 1 ? () => notifier.setDuration(state.durationWeeks - 1) : null,
                      ),
                      SizedBox(width: AppSizes.width(12)),
                      _DurationButton(
                        icon: Icons.add,
                        onTap: state.durationWeeks < 52 ? () => notifier.setDuration(state.durationWeeks + 1) : null,
                      ),
                    ],
                  ),
                ],
              ),

              // Divider
              Container(
                height: 1,
                color: AppColors.borderDefault,
                margin: EdgeInsets.symmetric(vertical: AppSizes.height(16)),
              ),

              // Start date row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        color: AppColors.amber,
                        size: AppSizes.font(18),
                      ),
                      SizedBox(width: AppSizes.width(12)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Start Date', style: AppTextStyles.font10Regular.copyWith(color: AppColors.muted)),
                          Text(
                            _formatDate(state.startDate),
                            style: AppTextStyles.font15Medium.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: _selectDate,
                    child: Text(
                      'Change',
                      style: AppTextStyles.font12Regular.copyWith(color: AppColors.amber),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),


        SizedBox(height: AppSizes.height(16)),

        Center(
          child: Text(
            'Client will be notified after assignment',
            style: AppTextStyles.font12RegularMuted,
          ),
        ),
      ],
    );
  }
}

class _SelectableProgramCard extends StatelessWidget {
  final String name;
  final String tag;
  final bool isSelected;
  final VoidCallback onTap;

  const _SelectableProgramCard({
    required this.name,
    required this.tag,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: AppSizes.height(10)),
        padding: AppSizes.paddingAll(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radius(16)),
          border: Border.all(
            color: isSelected ? AppColors.amber : AppColors.borderDefault,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.font15Medium.copyWith(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: AppSizes.height(6)),
                _TagChip(label: tag),
              ],
            ),
            if (isSelected)
              Container(
                width: AppSizes.width(24),
                height: AppSizes.width(24),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.amber,
                ),
                child: Icon(
                  Icons.check_rounded,
                  color: AppColors.background,
                  size: AppSizes.font(14),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String label;

  const _TagChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.width(10),
        vertical: AppSizes.height(5),
      ),
      decoration: BoxDecoration(
        color: AppColors.amber.withOpacity(0.12),
        borderRadius: BorderRadius.circular(AppSizes.radius(20)),
      ),
      child: Text(
        label,
        style: AppTextStyles.font10SemiBold.copyWith(color: AppColors.amber),
      ),
    );
  }
}

class _DurationButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _DurationButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: AppSizes.paddingAll(4),
        decoration: BoxDecoration(
          color: AppColors.surface2,
          borderRadius: BorderRadius.circular(AppSizes.radius(6)),
          border: Border.all(color: AppColors.borderDefault),
        ),
        child: Icon(
          icon,
          color: onTap != null ? AppColors.white : AppColors.muted,
          size: AppSizes.font(16),
        ),
      ),
    );
  }
}
