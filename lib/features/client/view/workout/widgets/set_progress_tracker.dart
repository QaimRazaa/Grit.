import 'package:flutter/material.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/device/responsive_size.dart';

class SetProgressTracker extends StatelessWidget {
  final int totalSets;
  final int currentSet; // 1-indexed
  final Set<String> loggedSets;
  final int currentExerciseIndex;

  const SetProgressTracker({
    super.key,
    required this.totalSets,
    required this.currentSet,
    required this.loggedSets,
    required this.currentExerciseIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: AppSizes.height(16),
        left: AppSizes.width(24),
        right: AppSizes.width(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(totalSets, (index) {
          final setIndex = index + 1;
          final isLogged = loggedSets.contains('${currentExerciseIndex}_$setIndex');
          final isCurrent = setIndex == currentSet;
          
          Color pillColor;
          if (isLogged) {
            pillColor = AppColors.amber;
          } else if (isCurrent) {
            pillColor = const Color(0x66F59E0B); // Amber 40% opacity
          } else {
            pillColor = AppColors.borderDefault; // #2A2A2A
          }

          return Expanded(
            child: Container(
              height: AppSizes.height(6),
              margin: EdgeInsets.only(left: index == 0 ? 0 : AppSizes.width(8)),
              decoration: BoxDecoration(
                color: pillColor,
                borderRadius: BorderRadius.circular(AppSizes.radius(3)),
              ),
            ),
          );
        }),
      ),
    );
  }
}
