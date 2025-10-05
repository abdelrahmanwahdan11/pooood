import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/hard_shadow_box.dart';
import '../../main.dart';
import '../auth/auth_routes.dart';
import 'onboarding_controller.dart';
import 'onboarding_routes.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  static const route = OnboardingRoutes.route;

  @override
  Widget build(BuildContext context) {
    final palette = Get.find<AppController>().palette;
    return Scaffold(
      backgroundColor: palette.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  HardShadowBox(
                    backgroundColor: palette.card,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Text('brand_title'.tr, style: Theme.of(context).textTheme.displayMedium),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: controller.skip,
                    child: Text('skip'.tr, style: Theme.of(context).textTheme.bodyMedium),
                  ),
                ],
              ),
              Text('brand_subtitle'.tr.toUpperCase(), style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 24),
              Expanded(
                child: PageView.builder(
                  controller: controller.pageController,
                  onPageChanged: controller.onPageChanged,
                  physics: const BouncingScrollPhysics(),
                  itemCount: controller.slides.length,
                  itemBuilder: (context, index) {
                    final prefix = controller.slides[index];
                    return _OnboardingCard(
                      palette: palette,
                      badge: '${prefix}_badge'.tr,
                      title: '${prefix}_title'.tr,
                      subtitle: '${prefix}_subtitle'.tr,
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
                          duration: const Duration(milliseconds: 240),
                          height: 12,
                          width: controller.pageIndex.value == index ? 36 : 12,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: palette.card,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.black, width: 3),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    HardShadowBox(
                      backgroundColor: palette.surface,
                      child: GestureDetector(
                        onTap: controller.next,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              controller.pageIndex.value == controller.slides.length - 1 ? 'start_now'.tr : 'next'.tr,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(width: 12),
                            const Icon(Icons.arrow_forward_rounded, color: Colors.black, size: 28),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Get.offAllNamed(AuthRoutes.route),
                  child: Text('sign_in'.tr, style: Theme.of(context).textTheme.bodyMedium),
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
    required this.palette,
    required this.badge,
    required this.title,
    required this.subtitle,
    required this.index,
  });

  final ColorPalette palette;
  final String badge;
  final String title;
  final String subtitle;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: HardShadowBox(
        backgroundColor: palette.surface,
        borderRadius: 32,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HardShadowBox(
              backgroundColor: palette.card,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Text(badge.toUpperCase(), style: Theme.of(context).textTheme.labelLarge),
            ),
            const SizedBox(height: 24),
            Text(title.toUpperCase(), style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: HardShadowBox(
                  backgroundColor: index % 2 == 0 ? palette.card : palette.surface,
                  borderRadius: 48,
                  padding: const EdgeInsets.all(32),
                  child: Icon(
                    [Icons.shopping_bag, Icons.auto_awesome_mosaic, Icons.chat_bubble][index],
                    size: 120,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(subtitle, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}
