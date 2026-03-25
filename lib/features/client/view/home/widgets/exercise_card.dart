import 'package:flutter/material.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/text_styles.dart';
import 'package:grit/utils/device/responsive_size.dart';

enum ExerciseCardState { notStarted, active, done }

class ExerciseCard extends StatelessWidget {
  final String name;
  final String details;
  final ExerciseCardState state;
  final int completedSets;
  final int totalSets;

  const ExerciseCard({
    super.key,
    required this.name,
    required this.details,
    this.state = ExerciseCardState.notStarted,
    this.completedSets = 0,
    this.totalSets = 4,
  });

  @override
  Widget build(BuildContext context) {
    Color getCardBorderColor() {
      switch (state) {
        case ExerciseCardState.active:
          return const Color(0x4DF59E0B);
        case ExerciseCardState.done:
          return const Color(0x55F59E0B); // Tinted amber border for done
        case ExerciseCardState.notStarted:
          return AppColors.borderDefault; // #2A2A2A
      }
    }

    Color getNameColor() {
      switch (state) {
        case ExerciseCardState.done:
          return AppColors.amber; // #F59E0B
        case ExerciseCardState.active:
        case ExerciseCardState.notStarted:
          return AppColors.white;
      }
    }

    Color getDetailsColor() {
      switch (state) {
        case ExerciseCardState.done:
          return const Color(0xFF333333); // Dimmed
        case ExerciseCardState.active:
        case ExerciseCardState.notStarted:
          return AppColors.muted; // #A3A3A3
      }
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.width(16),
        vertical: AppSizes.height(16),
      ),
      decoration: BoxDecoration(
        color: AppColors.surface, // #141414
        borderRadius: BorderRadius.circular(AppSizes.radius(16)),
        border: Border.all(
          color: getCardBorderColor(),
          width: AppSizes.width(1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left side: Icon Box + Details
          Row(
            children: [
              _buildIconBox(),
              SizedBox(width: AppSizes.width(12)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    name,
                    style: AppTextStyles.font14Regular.copyWith(
                      color: getNameColor(),
                    ),
                  ),
                  SizedBox(height: AppSizes.height(4)),
                  Text(
                    details,
                    style: AppTextStyles.font12Regular.copyWith(
                      color: getDetailsColor(),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Right side
          _buildRightIndicator(),
        ],
      ),
    );
  }

  Widget _buildIconBox() {
    final bool isUpcoming = state == ExerciseCardState.notStarted;

    return Container(
      width: AppSizes.width(36),
      height: AppSizes.width(36),
      decoration: BoxDecoration(
        color: isUpcoming
            ? AppColors.surface2
            : AppColors.amber, // solid amber for active/done
        borderRadius: BorderRadius.circular(AppSizes.radius(10)),
      ),
      child: Center(
        child: isUpcoming
            ? Container(
                width: AppSizes.width(14),
                height: AppSizes.height(2),
                color: const Color(0xFF3A3A3A),
              )
            : Container(
                width: AppSizes.width(14),
                height: AppSizes.width(14),
                decoration: const BoxDecoration(
                  color: AppColors.background, // black inner dot
                  shape: BoxShape.circle,
                ),
              ),
      ),
    );
  }

  Widget _buildRightIndicator() {
    if (state == ExerciseCardState.done) {
      // Row of small dots showing set progress
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(totalSets, (index) {
          final isCompleted = index < completedSets;
          return Container(
            width: AppSizes.width(6),
            height: AppSizes.width(6),
            margin: EdgeInsets.only(left: index == 0 ? 0 : AppSizes.width(4)),
            decoration: BoxDecoration(
              color: isCompleted
                  ? AppColors.amber
                  : AppColors.borderDefault, // #2A2A2A
              shape: BoxShape.circle,
            ),
          );
        }),
      );
    }

    if (state == ExerciseCardState.active) {
      return const DoubleRingPulse();
    }

    // Empty circle for Upcoming
    return Container(
      width: AppSizes.width(20),
      height: AppSizes.width(20),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.borderDefault, // #2A2A2A
          width: 1.5,
        ),
      ),
    );
  }
}

class DoubleRingPulse extends StatefulWidget {
  const DoubleRingPulse({super.key});

  @override
  State<DoubleRingPulse> createState() => _DoubleRingPulseState();
}

class _DoubleRingPulseState extends State<DoubleRingPulse> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: AppSizes.width(20) + (AppSizes.width(16) * _controller.value),
              height: AppSizes.width(20) + (AppSizes.width(16) * _controller.value),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.amber.withValues(alpha: (1.0 - _controller.value) * 0.5),
              ),
            ),
            Container(
              width: AppSizes.width(20),
              height: AppSizes.width(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.amber, width: 2.0),
              ),
            ),
          ],
        );
      },
    );
  }
}
