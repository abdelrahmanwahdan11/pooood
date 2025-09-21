import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/green_theme.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/gradient_scaffold.dart';
import 'onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  List<_OnboardingSlide> _slides(BuildContext context) => [
        _OnboardingSlide(
          title: 'onboarding_title'.tr,
          subtitle: 'onboarding_subtitle'.tr,
          icon: Icons.gavel,
        ),
        _OnboardingSlide(
          title: 'pricing'.tr,
          subtitle: 'pricing_hint'.tr,
          icon: Icons.price_change,
        ),
        _OnboardingSlide(
          title: 'settings'.tr,
          subtitle: 'notifications'.tr,
          icon: Icons.auto_awesome,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final slides = _slides(context);
    final pageController = PageController();

    return GradientScaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton(
                onPressed: controller.skip,
                child: Text(
                  'skip'.tr,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Colors.white),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: pageController,
                itemCount: slides.length,
                onPageChanged: controller.changePage,
                itemBuilder: (context, index) {
                  final slide = slides[index];
                  return _OnboardingContent(slide: slide);
                },
              ),
            ),
            const SizedBox(height: 24),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(slides.length, (index) {
                  final isActive = controller.currentPage.value == index;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    width: isActive ? 20 : 10,
                    height: 10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      color: isActive
                          ? Colors.white
                          : Colors.white.withOpacity(0.5),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 24),
            AppButton(
              label: 'get_started'.tr,
              isExpanded: true,
              onPressed: controller.completeOnboarding,
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingSlide {
  _OnboardingSlide({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;
}

class _OnboardingContent extends StatelessWidget {
  const _OnboardingContent({required this.slide});

  final _OnboardingSlide slide;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: GreenTheme.primaryGradient,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Icon(
            slide.icon,
            size: 64,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 32),
        Text(
          slide.title,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          slide.subtitle,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: Colors.white.withOpacity(0.9),
          ),
        ),
      ],
    );
  }
}
