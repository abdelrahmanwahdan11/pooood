import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/glass_widgets.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/empty_state.dart';
import '../auctions/auctions_view.dart';
import '../deals/deals_view.dart';
import '../map/map_view.dart';
import '../pricing/pricing_view.dart';
import '../settings/settings_view.dart';
import '../wanted/wanted_view.dart';
import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = const [
      AuctionsView(),
      DealsView(),
      WantedView(),
      PricingView(),
      MapView(),
    ];
    return GlassScaffold(
      appBar: GlassAppBar(
        title: Text('app_name'.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Get.to(() => const SettingsView()),
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: pages,
        ),
      ),
      bottomNavigationBar: Obx(
        () => NavigationBar(
          selectedIndex: controller.currentIndex.value,
          height: 70,
          backgroundColor: Colors.black.withOpacity(0.4),
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.gavel_outlined),
              selectedIcon: const Icon(Icons.gavel),
              label: 'auctions'.tr,
            ),
            NavigationDestination(
              icon: const Icon(Icons.local_offer_outlined),
              selectedIcon: const Icon(Icons.local_offer),
              label: 'deals'.tr,
            ),
            NavigationDestination(
              icon: const Icon(Icons.notifications_active_outlined),
              selectedIcon: const Icon(Icons.notifications_active),
              label: 'wanted'.tr,
            ),
            NavigationDestination(
              icon: const Icon(Icons.price_check_outlined),
              selectedIcon: const Icon(Icons.price_check),
              label: 'pricing'.tr,
            ),
            NavigationDestination(
              icon: const Icon(Icons.map_outlined),
              selectedIcon: const Icon(Icons.map),
              label: 'map'.tr,
            ),
          ],
          onDestinationSelected: controller.changeIndex,
        ),
      ),
    );
  }

  Drawer _buildDrawer() {
    return Drawer(
      backgroundColor: Colors.black.withOpacity(0.6),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ListTile(
              leading: const Icon(Icons.add_circle_outline),
              title: Text('drawer_add_product'.tr),
              onTap: _showComingSoon,
            ),
            ListTile(
              leading: const Icon(Icons.discount_outlined),
              title: Text('drawer_add_deal'.tr),
              onTap: _showComingSoon,
            ),
            ListTile(
              leading: const Icon(Icons.notifications_active_outlined),
              title: Text('drawer_add_wanted'.tr),
              onTap: () {
                Get.back();
                Get.to(() => const WantedView());
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text('drawer_settings'.tr),
              onTap: () => Get.to(() => const SettingsView()),
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoon() {
    Get.back();
    Get.bottomSheet(
      GradientGlassCard(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            EmptyState(
              icon: Icons.info_outline,
              title: 'coming_soon'.tr,
              subtitle: 'pricing_hint'.tr,
            ),
            const SizedBox(height: 16),
            AppButton(
              label: 'close'.tr,
              onPressed: () => Get.back(),
              expanded: true,
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }
}
