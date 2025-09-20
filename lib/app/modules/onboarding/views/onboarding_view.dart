import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../theme/app_theme.dart';
import '../../../theme/glass_widgets.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final slides = <_OnboardingSlideData>[
      const _OnboardingSlideData(
        titleKey: 'onboarding.title1',
        descKey: 'onboarding.desc1',
        icon: Icons.gavel,
        gradient: [Color(0xFF5D5FEF), Color(0xFF9E9DF5)],
      ),
      const _OnboardingSlideData(
        titleKey: 'onboarding.title2',
        descKey: 'onboarding.desc2',
        icon: Icons.local_offer_outlined,
        gradient: [Color(0xFF3E8BFF), Color(0xFF69B1FF)],
      ),
      const _OnboardingSlideData(
        titleKey: 'onboarding.title3',
        descKey: 'onboarding.desc3',
        icon: Icons.favorite_outline,
        gradient: [Color(0xFF8E5AE8), Color(0xFFC182FF)],
      ),
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: GlassAppBar(
        title: Text('appName'.tr, style: theme.textTheme.titleMedium),
        actions: [
          TextButton(
            onPressed: controller.skip,
            child: Text('skip'.tr, style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.primary)),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F172A), Color(0xFF1F2937)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: controller.pageController,
                    onPageChanged: controller.onPageChanged,
                    itemCount: slides.length,
                    itemBuilder: (context, index) {
                      final slide = slides[index];
                      return _OnboardingSlide(data: slide);
                    },
                  ),
                ),
                const SizedBox(height: 32),
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      slides.length,
                      (index) {
                        final isActive = controller.currentIndex.value == index;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: isActive ? 18 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: isActive ? theme.colorScheme.primary : Colors.white24,
                            borderRadius: BorderRadius.circular(999),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: Obx(
                    () => FilledButton.tonal(
                      style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 18)),
                      onPressed: controller.next,
                      child: Text(
                        controller.currentIndex.value == slides.length - 1 ? 'start'.tr : 'next'.tr,
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OnboardingSlideData {
  const _OnboardingSlideData({
    required this.titleKey,
    required this.descKey,
    required this.icon,
    required this.gradient,
  });

  final String titleKey;
  final String descKey;
  final IconData icon;
  final List<Color> gradient;
}

class _OnboardingSlide extends StatelessWidget {
  const _OnboardingSlide({required this.data});

  final _OnboardingSlideData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Expanded(
          child: GlassCard(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 160,
                  width: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: data.gradient),
                    boxShadow: const [
                      BoxShadow(color: AppColors.shadow, blurRadius: 24, offset: Offset(0, 16)),
                    ],
                  ),
                  child: Icon(data.icon, size: 72, color: Colors.white),
                ),
                const SizedBox(height: 32),
                Text(
                  data.titleKey.tr,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 16),
                Text(
                  data.descKey.tr,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.72)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
