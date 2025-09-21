import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../data/datasources/local/get_storage_ds.dart';
import '../../data/datasources/remote/stub_api_ds.dart';
import '../../data/repositories/auction_repo.dart';
import '../../data/repositories/pricing_repo.dart';
import '../../modules/auctions/auctions_controller.dart';
import '../../modules/home/home_controller.dart';
import '../../modules/onboarding/onboarding_controller.dart';
import '../../modules/pricing/pricing_controller.dart';
import '../../modules/settings/settings_controller.dart';
import '../../services/auction_sync_service.dart';
import '../../services/notification_service.dart';
import '../../services/pricing_service.dart';

class GlobalBindings extends Bindings {
  @override
  void dependencies() {
    final storage = GetStorage();
    final local = GetStorageDataSource(storage);
    final remote = StubApiDataSource();

    Get.put<GetStorageDataSource>(local, permanent: true);
    Get.put<StubApiDataSource>(remote, permanent: true);

    Get.put<AuctionRepository>(AuctionRepository(remote, local), permanent: true);
    Get.put<PricingRepository>(PricingRepository(remote), permanent: true);

    Get.putAsync<NotificationService>(() => NotificationService().init(),
        permanent: true);
    Get.putAsync<PricingService>(
      () => PricingService(Get.find<PricingRepository>()).init(),
      permanent: true,
    );
    Get.putAsync<AuctionSyncService>(
      () => AuctionSyncService(Get.find<AuctionRepository>()).init(),
      permanent: true,
    );

    Get.lazyPut(() => OnboardingController(Get.find<GetStorageDataSource>()));
    Get.lazyPut(() => HomeController());
    Get.lazyPut(
      () => AuctionsController(
        Get.find<AuctionRepository>(),
        Get.find<AuctionSyncService>(),
        Get.find<NotificationService>(),
      ),
    );
    Get.lazyPut(
      () => PricingController(
        Get.find<PricingService>(),
        Get.find<GetStorageDataSource>(),
      ),
    );
    Get.lazyPut(
      () => SettingsController(
        Get.find<GetStorageDataSource>(),
        Get.find<NotificationService>(),
      ),
    );
  }
}
