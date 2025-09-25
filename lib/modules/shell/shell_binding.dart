import 'package:get/get.dart';

import '../add_item/add_item_binding.dart';
import '../ai_pricing/ai_pricing_binding.dart';
import '../discounts_nearby/discounts_nearby_binding.dart';
import '../home_auction/home_auction_binding.dart';
import '../map_explore/map_explore_binding.dart';
import '../price_watch/price_watch_binding.dart';
import '../settings/settings_binding.dart';
import 'shell_controller.dart';

class ShellBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShellController>(() => ShellController());
    HomeAuctionBinding().dependencies();
    DiscountsNearbyBinding().dependencies();
    PriceWatchBinding().dependencies();
    AiPricingBinding().dependencies();
    MapExploreBinding().dependencies();
    SettingsBinding().dependencies();
    AddItemBinding().dependencies();
  }
}
