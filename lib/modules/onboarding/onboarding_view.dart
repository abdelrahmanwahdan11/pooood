import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/widgets/app_button.dart';
import '../../core/widgets/glass_container.dart';
import 'onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const pages = [
      _OnboardingPageData(
        titleKey: 'onboarding_title_1',
        bodyKey: 'onboarding_body_1',
        icon: Icons.trending_up,
      ),
      _OnboardingPageData(
        titleKey: 'onboarding_title_2',
        bodyKey: 'onboarding_body_2',
        icon: Icons.gavel_rounded,
      ),
      _OnboardingPageData(
        titleKey: 'onboarding_title_3',
        bodyKey: 'onboarding_body_3',
        icon: Icons.flash_on_rounded,
      ),
    ];

    return Directionality(
      textDirection: Get.locale?.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1F2A44), Color(0xFF304361), Color(0xFF0F172A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('app_title'.tr, style: theme.textTheme.headlineSmall?.copyWith(color: Colors.white)),
                      TextButton(
                        onPressed: controller.skip,
                        child: Text('skip'.tr, style: const TextStyle(color: Colors.white70)),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: controller.pageController,
                    onPageChanged: controller.onPageChanged,
                    itemCount: pages.length,
                    itemBuilder: (context, index) => _OnboardingPage(
                      titleKey: pages[index].titleKey,
                      bodyKey: pages[index].bodyKey,
                      icon: pages[index].icon,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            pages.length,
                            (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: controller.currentPage.value == index ? 24 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: controller.currentPage.value == index
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      GlassContainer(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text('choose_language'.tr, style: theme.textTheme.titleMedium?.copyWith(color: Colors.white)),
                            const SizedBox(height: 12),
                            Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 12,
                              children: [
                                AppButton(
                                  label: 'English',
                                  onPressed: () => controller.changeLocale('en'),
                                ),
                                AppButton(
                                  label: 'العربية',
                                  onPressed: () => controller.changeLocale('ar'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Obx(
                        () => AppButton(
                          label: controller.currentPage.value == pages.length - 1 ? 'get_started'.tr : 'next'.tr,
                          onPressed: controller.next,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
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

class _OnboardingPageData {
  const _OnboardingPageData({
    required this.titleKey,
    required this.bodyKey,
    required this.icon,
  });

  final String titleKey;
  final String bodyKey;
  final IconData icon;
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({
    required this.titleKey,
    required this.bodyKey,
    required this.icon,
  });

  final String titleKey;
  final String bodyKey;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        children: [
          Expanded(
            child: GlassContainer(
              style: const GlassContainerStyle(blur: 40, opacity: 0.2),
              child: Center(
                child: Icon(
                  icon,
                  size: 120,
                  color: Colors.white70,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(titleKey.tr, style: theme.textTheme.headlineMedium?.copyWith(color: Colors.white), textAlign: TextAlign.center),
          const SizedBox(height: 12),
          Text(
            bodyKey.tr,
            style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
