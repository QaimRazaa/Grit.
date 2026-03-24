import 'package:flutter/material.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/sizes.dart';

class LoadingDots extends StatefulWidget {
  const LoadingDots({super.key});

  @override
  State<LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<LoadingDots> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return _AnimatedDot(
          index: index,
          controller: _controller,
        );
      }),
    );
  }
}

class _AnimatedDot extends StatelessWidget {
  final int index;
  final AnimationController controller;

  const _AnimatedDot({
    required this.index,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        // Each dot starts its fade animation at a different interval
        final start = index * 0.2;
        final end = start + 0.6;
        
        double opacity = 0.2;
        if (controller.value >= start && controller.value <= end) {
          // Pulse effect: fade in then out within its window
          final relativeValue = (controller.value - start) / 0.6;
          opacity = relativeValue <= 0.5 
              ? 0.2 + (relativeValue * 2 * 0.8) // Fade in from 0.2 to 1.0
              : 1.0 - ((relativeValue - 0.5) * 2 * 0.8); // Fade out back to 0.2
        }

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: GritSizes.size6,
          height: GritSizes.size6,
          decoration: BoxDecoration(
            color: AppColors.amber.withValues(alpha: opacity.clamp(0.2, 1.0)),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}
