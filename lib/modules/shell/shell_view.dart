import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/utils/responsive.dart';
import '../../core/widgets/app_badge.dart';
import '../../core/widgets/glass_container.dart';
import '../ai_pricing/pricing_view.dart';
import '../auction_home/auction_view.dart';
import '../discounts_nearby/discounts_view.dart';
import '../explore/explore_view.dart';
import '../notifications/notifications_controller.dart';
import '../price_watch/price_watch_view.dart';
import '../settings/settings_controller.dart';
import '../settings/settings_view.dart';
import 'shell_controller.dart';

class ShellView extends GetView<ShellController> {
  const ShellView({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = Responsive.adaptivePadding(context);
    final scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      endDrawer: const SettingsDrawer(),
      body: Obx(
        () => NestedScrollView(
          physics: const BouncingScrollPhysics(),
          headerSliverBuilder: (context, innerScrolled) => [
            SliverAppBar(
              floating: true,
              snap: true,
              stretch: true,
              expandedHeight: 140,
              backgroundColor: Colors.white.withOpacity(0.2),
              title: Text(_pageTitle(controller.pageIndex.value).tr),
              flexibleSpace: FlexibleSpaceBar(
                background: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: padding,
                      right: padding,
                      top: 12,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => controller.openSettingsDrawer(scaffoldKey),
                              child: CircleAvatar(
                                radius: 24,
                                backgroundImage: NetworkImage(_avatarUrl()),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: GlassContainer(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: TextField(
                                  controller: controller.searchController,
                                  onChanged: controller.onSearchChanged,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    icon: const Icon(Icons.search_rounded),
                                    hintText: 'search_placeholder'.tr,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            GetX<NotificationsController>(
                              builder: (notifier) => AppBadge(
                                count: notifier.unreadCount,
                                child: IconButton(
                                  onPressed: controller.openNotifications,
                                  icon: const Icon(Icons.notifications_rounded),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: controller.openMyActivity,
                              icon: const Icon(Icons.more_horiz),
                            ),
                            IconButton(
                              onPressed: controller.openAddFlow,
                              icon: const Icon(Icons.add_rounded),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
          body: PageView(
            controller: controller.pageController,
            onPageChanged: controller.onPageChanged,
            physics: const ClampingScrollPhysics(),
            children: const [
              AuctionHomeView(),
              DiscountsNearbyView(),
              PriceWatchView(),
              AiPricingView(),
              ExploreView(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Obx(
        () => NavigationBar(
          selectedIndex: controller.pageIndex.value,
          onDestinationSelected: controller.onTabSelected,
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.gavel_outlined),
              selectedIcon: const Icon(Icons.gavel),
              label: 'auction'.tr,
            ),
            NavigationDestination(
              icon: const Icon(Icons.local_offer_outlined),
              selectedIcon: const Icon(Icons.local_offer),
              label: 'nearby_discounts'.tr,
            ),
            NavigationDestination(
              icon: const Icon(Icons.visibility_outlined),
              selectedIcon: const Icon(Icons.visibility),
              label: 'price_watch'.tr,
            ),
            NavigationDestination(
              icon: const Icon(Icons.smart_toy_outlined),
              selectedIcon: const Icon(Icons.smart_toy),
              label: 'ai_pricing'.tr,
            ),
            NavigationDestination(
              icon: const Icon(Icons.explore_outlined),
              selectedIcon: const Icon(Icons.explore),
              label: 'explore'.tr,
            ),
          ],
        ),
      ),
    );
  }

  String _pageTitle(int index) {
    switch (index) {
      case 0:
        return 'auction';
      case 1:
        return 'nearby_discounts';
      case 2:
        return 'price_watch';
      case 3:
        return 'ai_pricing';
      case 4:
        return 'explore';
      default:
        return 'auction';
    }
  }

  String _avatarUrl() {
    final settings = Get.find<SettingsController>();
    final user = settings.user.value;
    if (user != null && user.avatarUrl.isNotEmpty) {
      return user.avatarUrl;
    }
    return 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=200&q=60';
  }
}
