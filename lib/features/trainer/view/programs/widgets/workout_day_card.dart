import 'package:flutter/material.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/text_styles.dart';
import 'package:grit/utils/device/responsive_size.dart';

class WorkoutDayCard extends StatefulWidget {
  final int dayIndex;
  final String workoutName;
  final int exerciseCount;
  final ValueChanged<String> onNameChanged;
  final VoidCallback onAddExercises;

  const WorkoutDayCard({
    super.key,
    required this.dayIndex,
    required this.workoutName,
    required this.exerciseCount,
    required this.onNameChanged,
    required this.onAddExercises,
  });

  @override
  State<WorkoutDayCard> createState() => _WorkoutDayCardState();
}

class _WorkoutDayCardState extends State<WorkoutDayCard> {
  late TextEditingController _nameController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.workoutName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSizes.height(10)),
      padding: AppSizes.paddingAll(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radius(16)),
        border: Border.all(
          color: widget.exerciseCount > 0 ? AppColors.amber.withOpacity(0.2) : AppColors.borderDefault,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DAY ${widget.dayIndex + 1}',
                  style: AppTextStyles.font10SemiBold.copyWith(
                    color: AppColors.amber,
                    letterSpacing: 0.8,
                  ),
                ),
                SizedBox(height: AppSizes.height(6)),
                // Editable workout name
                if (_isEditing)
                  SizedBox(
                    width: AppSizes.width(180),
                    child: TextField(
                      controller: _nameController,
                      autofocus: true,
                      style: AppTextStyles.font15Medium.copyWith(fontWeight: FontWeight.w700),
                      onSubmitted: (v) {
                        setState(() {
                          _isEditing = false;
                        });
                        widget.onNameChanged(v);
                      },
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  )
                else
                  GestureDetector(
                    onTap: () => setState(() => _isEditing = true),
                    child: Row(
                      children: [
                        Text(
                          widget.workoutName,
                          style: AppTextStyles.font15Medium.copyWith(fontWeight: FontWeight.w700),
                        ),
                        SizedBox(width: AppSizes.width(6)),
                        Icon(
                          Icons.edit_outlined,
                          color: AppColors.dim,
                          size: AppSizes.font(12),
                        ),
                      ],
                    ),
                  ),
                SizedBox(height: AppSizes.height(4)),
                Text(
                  widget.exerciseCount == 0 ? 'No exercises yet' : '${widget.exerciseCount} exercises',
                  style: AppTextStyles.font12RegularMuted,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: widget.onAddExercises,
            child: Row(
              children: [
                Icon(
                  Icons.add_rounded,
                  color: AppColors.amber,
                  size: AppSizes.font(16),
                ),
                SizedBox(width: AppSizes.width(4)),
                Text(
                  'Add',
                  style: AppTextStyles.font12Regular.copyWith(color: AppColors.amber),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
