import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/sizes.dart';
import 'package:grit/utils/device/responsive_size.dart';

class OnboardingDotIndicator extends StatefulWidget {
  final int currentPage;

  const OnboardingDotIndicator({
    super.key,
    required this.currentPage,
  });

  @override
  State<OnboardingDotIndicator> createState() => _OnboardingDotIndicatorState();
}

class _OnboardingDotIndicatorState extends State<OnboardingDotIndicator> {
  final CarouselSliderController _carouselController = CarouselSliderController();

  @override
  void didUpdateWidget(covariant OnboardingDotIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentPage != widget.currentPage) {
      _carouselController.animateToPage(widget.currentPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.height(GritSizes.size8),
      // Keeping width controlled so the Carousel Slider aligns neatly around the center.
      // 0.33 viewportFraction means 3 dots fit exactly inside.
      width: AppSizes.width(GritSizes.size8 * 10),
      child: CarouselSlider.builder(
        carouselController: _carouselController,
        itemCount: 3,
        options: CarouselOptions(
          height: AppSizes.height(GritSizes.size8),
          viewportFraction: 0.33,
          enableInfiniteScroll: false,
          initialPage: widget.currentPage,
          scrollPhysics: const NeverScrollableScrollPhysics(), // Usually dots are not manually swiped
        ),
        itemBuilder: (context, index, realIndex) {
          final isActive = widget.currentPage == index;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: AppSizes.width(isActive ? GritSizes.size8 * 3 : GritSizes.size8),
            height: AppSizes.height(GritSizes.size8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSizes.radius(GritSizes.size8 / 2)),
              color: isActive ? AppColors.amber : const Color(0xFF333333),
            ),
          );
        },
      ),
    );
  }
}
