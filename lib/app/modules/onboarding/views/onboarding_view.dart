import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/layout_helper.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  LinearGradient _gradientFor(String id, bool isDark) {
    final gradients = isDark ? AppColors.darkGradients : AppColors.lightGradients;
    final colors = gradients[id] ?? gradients.values.first;
    return LinearGradient(colors: colors);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      body: LayoutHelper.constrain(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: controller.pageController,
                    onPageChanged: controller.onPageChanged,
                    itemCount: controller.slides.length,
                    itemBuilder: (context, index) {
                      final slide = controller.slides[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 24),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: _gradientFor(slide.gradientId, isDark),
                                borderRadius: BorderRadius.circular(32),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 24,
                                    offset: const Offset(0, 16),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(28),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    slide.titleKey.tr,
                                    textAlign: TextAlign.start,
                                    style: theme.textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: isDark ? Colors.black : AppColors.textDark,
                                    ),
                                  ).animate().fade(duration: 400.ms).slide(begin: const Offset(0, 0.1)),
                                  const SizedBox(height: 18),
                                  Text(
                                    slide.descriptionKey.tr,
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      color: isDark ? Colors.black.withOpacity(0.85) : AppColors.textDark.withOpacity(0.7),
                                    ),
                                  ).animate(delay: 100.ms).fade(duration: 450.ms).slide(begin: const Offset(0, 0.2)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                SmoothPageIndicator(
                  controller: controller.pageController,
                  count: controller.slides.length,
                  effect: ExpandingDotsEffect(
                    dotColor: theme.colorScheme.primary.withOpacity(0.2),
                    activeDotColor: theme.colorScheme.primary,
                    dotHeight: 8,
                    dotWidth: 8,
                    spacing: 12,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: controller.complete,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: Text('get_started'.tr),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
