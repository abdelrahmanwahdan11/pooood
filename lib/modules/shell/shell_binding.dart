import 'package:get/get.dart';

import '../../data/db/app_db.dart';
import '../../data/repositories/auctions_repo.dart';
import '../../data/repositories/discounts_repo.dart';
import '../../data/repositories/notifications_repo.dart';
import '../../data/repositories/settings_repo.dart';
import '../../data/repositories/watches_repo.dart';
import '../ai_pricing/pricing_controller.dart';
import '../auction_home/auction_controller.dart';
import '../discounts_nearby/discounts_controller.dart';
import '../auth/auth_controller.dart';
import '../explore/explore_controller.dart';
import '../notifications/notifications_controller.dart';
import '../price_watch/price_watch_controller.dart';
import '../settings/settings_controller.dart';
import 'shell_controller.dart';

class ShellBinding extends Bindings {
  ShellBinding({this.settingsRepository});

  final SettingsRepository? settingsRepository;

  @override
  void dependencies() {
    if (!Get.isRegistered<AppDatabase>()) {
      Get.put(AppDatabase.instance, permanent: true);
    }
    final db = Get.find<AppDatabase>();

    if (settingsRepository != null &&
        !Get.isRegistered<SettingsRepository>()) {
      Get.put<SettingsRepository>(settingsRepository!, permanent: true);
    } else if (!Get.isRegistered<SettingsRepository>()) {
      throw Exception('SettingsRepository must be provided');
    }
    final settingsRepo = Get.find<SettingsRepository>();

    Get.lazyPut(() => AuctionsRepository(database: db));
    Get.lazyPut(() => DiscountsRepository(database: db));
    Get.lazyPut(() => WatchesRepository(database: db));
    Get.lazyPut(() => NotificationsRepository(database: db));

    Get.put(ShellController(settingsRepo), permanent: true);
    Get.put(AuthController(), permanent: true);
    Get.put(AuctionController(Get.find<AuctionsRepository>(), settingsRepo),
        permanent: true);
    Get.put(DiscountsController(Get.find<DiscountsRepository>(), settingsRepo),
        permanent: true);
    Get.put(PriceWatchController(Get.find<WatchesRepository>()),
        permanent: true);
    Get.put(PricingController(Get.find<AuctionsRepository>(), settingsRepo),
        permanent: true);
    Get.put(
        ExploreController(
          Get.find<AuctionsRepository>(),
          Get.find<DiscountsRepository>(),
          settingsRepo,
        ),
        permanent: true);
    Get.put(SettingsController(settingsRepo), permanent: true);
    Get.put(NotificationsController(Get.find<NotificationsRepository>()),
        permanent: true);
  }
}
