import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/utils/responsive.dart';
import '../ai_pricing/ai_pricing_view.dart';
import '../common/widgets/app_avatar.dart';
import '../common/widgets/app_badge.dart';
import '../common/widgets/app_search_bar.dart';
import '../discounts_nearby/discounts_nearby_view.dart';
import '../home_auction/home_auction_view.dart';
import '../map_explore/map_explore_view.dart';
import '../price_watch/price_watch_view.dart';
import '../settings/settings_drawer.dart';
import 'shell_controller.dart';

class ShellView extends GetView<ShellController> {
  const ShellView({super.key});

  static final _tabs = [
    const HomeAuctionView(),
    const DiscountsNearbyView(),
    const PriceWatchView(),
    const AiPricingView(),
    const MapExploreView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Get.locale?.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = Responsive.sizeOf(constraints);
          final padding = EdgeInsets.symmetric(
            horizontal: Responsive.horizontalPadding(size),
            vertical: 8,
          );
          return Obx(
            () => Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              endDrawer: const SettingsDrawer(),
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(92),
                child: Padding(
                  padding: padding,
                  child: _buildAppBar(context),
                ),
              ),
              body: IndexedStack(
                index: controller.currentIndex.value,
                children: _tabs,
              ),
              bottomNavigationBar: _buildBottomBar(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SafeArea(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Builder(
            builder: (context) => AppAvatar(
              imageUrl: controller.user.avatarUrl,
              onTap: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: AppSearchBar(
              onChanged: controller.updateSearch,
              onFiltersTap: controller.openFilters,
            ),
          ),
          const SizedBox(width: 12),
          AppBadge(
            count: controller.notificationsService.unreadCount,
            child: IconButton(
              onPressed: controller.openNotifications,
              icon: const Icon(Icons.notifications_none_rounded),
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.dashboard_customize_rounded),
            onSelected: controller.openMyActivity,
            itemBuilder: (context) => [
              PopupMenuItem(value: 'bids', child: Text('my_bids'.tr)),
              PopupMenuItem(value: 'discounts', child: Text('my_discounts'.tr)),
            ],
          ),
          const SizedBox(width: 4),
          IconButton(
            onPressed: controller.openAddItem,
            icon: const Icon(Icons.add_circle_rounded, size: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Obx(
      () => NavigationBar(
        selectedIndex: controller.currentIndex.value,
        height: 72,
        onDestinationSelected: controller.changeTab,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.gavel_rounded),
            label: 'auction_tab'.tr,
          ),
          NavigationDestination(
            icon: const Icon(Icons.local_offer_rounded),
            label: 'discounts_tab'.tr,
          ),
          NavigationDestination(
            icon: const Icon(Icons.visibility_rounded),
            label: 'price_watch_tab'.tr,
          ),
          NavigationDestination(
            icon: const Icon(Icons.auto_awesome_rounded),
            label: 'ai_pricing_tab'.tr,
          ),
          NavigationDestination(
            icon: const Icon(Icons.map_rounded),
            label: 'map_tab'.tr,
          ),
        ],
      ),
    );
  }
}
