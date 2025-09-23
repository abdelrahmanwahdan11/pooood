import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/glass_widgets.dart';
import '../../core/widgets/app_button.dart';
import 'onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = [
      _OnboardingSlide(
        image: 'https://images.unsplash.com/photo-1515169067865-5387ec356754',
        title: 'onboarding_title_1'.tr,
        description: 'onboarding_desc_1'.tr,
      ),
      _OnboardingSlide(
        image: 'https://images.unsplash.com/photo-1498050108023-c5249f4df085',
        title: 'onboarding_title_2'.tr,
        description: 'onboarding_desc_2'.tr,
      ),
      _OnboardingSlide(
        image: 'https://images.unsplash.com/photo-1494526585095-c41746248156',
        title: 'onboarding_title_3'.tr,
        description: 'onboarding_desc_3'.tr,
      ),
    ];
    return GlassScaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: controller.skip,
                child: Text('skip'.tr, style: Get.textTheme.bodyMedium),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                itemCount: pages.length,
                itemBuilder: (_, index) => pages[index],
              ),
            ),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  pages.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                    height: 6,
                    width: controller.currentPage.value == index ? 24 : 12,
                    decoration: BoxDecoration(
                      color: controller.currentPage.value == index
                          ? AppColors.accent
                          : Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: AppButton(
                label: controller.currentPage.value == pages.length - 1
                    ? 'get_started'.tr
                    : 'next'.tr,
                onPressed: controller.next,
                expanded: true,
                icon: Icons.chevron_right,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingSlide extends StatelessWidget {
  const _OnboardingSlide({
    required this.image,
    required this.title,
    required this.description,
  });

  final String image;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: GradientGlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(title, style: Get.textTheme.headlineMedium),
            const SizedBox(height: 12),
            Text(
              description,
              style: Get.textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
