import 'package:get/get.dart';

import 'auction_repository.dart';
import 'discount_repository.dart';
import 'notifications_repository.dart';
import 'price_watch_repository.dart';
import 'pricing_repository.dart';
import 'settings_repository.dart';
import 'user_repository.dart';

class AppRepositoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<UserRepository>(InMemoryUserRepository(), permanent: true);
    Get.put<AuctionRepository>(InMemoryAuctionRepository(), permanent: true);
    Get.put<DiscountRepository>(InMemoryDiscountRepository(), permanent: true);
    Get.put<PriceWatchRepository>(InMemoryPriceWatchRepository(), permanent: true);
    Get.put<PricingRepository>(InMemoryPricingRepository(), permanent: true);
    Get.put<SettingsRepository>(InMemorySettingsRepository(), permanent: true);
    Get.put<NotificationsRepository>(InMemoryNotificationsRepository(), permanent: true);
  }
}
