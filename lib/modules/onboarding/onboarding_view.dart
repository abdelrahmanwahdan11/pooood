import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/glass_container.dart';
import 'onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GlassContainer(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      'app_name'.tr,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.accentPrimary,
                      ),
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: controller.skip,
                    child: Text('skip'.tr),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: PageView.builder(
                  controller: controller.pageController,
                  onPageChanged: controller.onPageChanged,
                  physics: const BouncingScrollPhysics(),
                  itemCount: controller.slides.length,
                  itemBuilder: (context, index) {
                    final key = controller.slides[index];
                    return _OnboardingCard(
                      title: '${key}_title'.tr,
                      subtitle: '${key}_subtitle'.tr,
                      badge: '${key}_badge'.tr,
                      index: index,
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              Obx(
                () => Row(
                  children: [
                    Row(
                      children: List.generate(
                        controller.slides.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 280),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 8,
                          width: controller.currentPage.value == index ? 24 : 8,
                          decoration: BoxDecoration(
                            color: controller.currentPage.value == index
                                ? AppTheme.accentPrimary
                                : Colors.white.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    FilledButton.icon(
                      onPressed: controller.next,
                      icon: const Icon(Icons.arrow_forward_rounded),
                      label: Text(
                        controller.currentPage.value == controller.slides.length - 1
                            ? 'start_now'.tr
                            : 'next'.tr,
                      ),
                    ).animate().fadeIn().slideX(begin: 0.2),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingCard extends StatelessWidget {
  const _OnboardingCard({
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.index,
  });

  final String title;
  final String subtitle;
  final String badge;
  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final heroColor = [
      const Color(0xFF141A37),
      const Color(0xFF00D9A6),
      const Color(0xFFFF6584),
    ][index % 3];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: GlassContainer(
            borderRadius: 36,
            padding: const EdgeInsets.all(24),
            gradient: LinearGradient(
              colors: [heroColor.withOpacity(0.85), heroColor.withOpacity(0.55)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: GlassContainer(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    child: Text(
                      badge,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: AppTheme.onSurface,
                      ),
                    ),
                  ).animate().fadeIn(delay: 200.ms).slideY(begin: -0.2, end: 0),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: theme.textTheme.displaySmall?.copyWith(
                    color: Colors.white,
                  ),
                ).animate().fadeIn().slideY(begin: 0.4, end: 0),
                const Spacer(),
                Container(
                  height: 220,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.22),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.watch_rounded,
                    size: 120,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ).animate().fadeIn(delay: 120.ms).scale(begin: const Offset(0.9, 0.9)),
                const SizedBox(height: 24),
                Text(
                  subtitle,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withOpacity(0.92),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
