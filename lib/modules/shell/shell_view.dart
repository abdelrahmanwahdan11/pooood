import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/glass_container.dart';
import '../favorites/favorites_view.dart';
import '../home/home_view.dart';
import '../profile/profile_view.dart';
import 'shell_controller.dart';

class ShellView extends GetView<ShellController> {
  const ShellView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settings = controller.settingsRepository;
    return Scaffold(
      key: controller.scaffoldKey,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: GlassContainer(
                borderRadius: 28,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('app_name'.tr, style: theme.textTheme.titleLarge),
                        Text('hero_subtitle'.tr, style: theme.textTheme.bodySmall),
                      ],
                    ),
                    const Spacer(),
                    FilledButton.tonal(
                      onPressed: controller.toggleLocale,
                      child: Text(settings.currentLocale.languageCode == 'ar' ? 'EN' : 'AR'),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: PageView(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                physics: const BouncingScrollPhysics(),
                children: const [
                  HomeView(),
                  FavoritesView(),
                  ProfileView(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () => NavigationBar(
          selectedIndex: controller.pageIndex.value,
          onDestinationSelected: controller.onTabSelected,
          height: 72,
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home_rounded),
              label: 'home'.tr,
            ),
            NavigationDestination(
              icon: const Icon(Icons.favorite_border_rounded),
              selectedIcon: const Icon(Icons.favorite_rounded),
              label: 'favorites'.tr,
            ),
            NavigationDestination(
              icon: const Icon(Icons.person_outline_rounded),
              selectedIcon: const Icon(Icons.person_rounded),
              label: 'profile'.tr,
            ),
          ],
        ),
      ),
    );
  }
}
