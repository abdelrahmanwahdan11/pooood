import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/widgets/gradient_scaffold.dart';
import '../auctions/auctions_view.dart';
import '../pricing/pricing_view.dart';
import '../settings/settings_view.dart';
import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = const [
      AuctionsView(),
      PricingView(),
      SettingsView(),
    ];

    return GradientScaffold(
      extendBody: true,
      body: Obx(
        () => IndexedStack(
          index: controller.index.value,
          children: pages,
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.index.value,
          onTap: controller.changeTab,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.gavel_outlined),
              label: 'auctions'.tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.price_change_outlined),
              label: 'pricing'.tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.settings_outlined),
              label: 'settings'.tr,
            ),
          ],
        ),
      ),
    );
  }
}
