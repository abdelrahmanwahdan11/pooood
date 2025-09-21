import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../data/datasources/local/get_storage_ds.dart';
import '../../data/datasources/remote/stub_api_ds.dart';
import '../../data/repositories/auction_repo.dart';
import '../../data/repositories/location_repo.dart';
import '../../data/repositories/product_repo.dart';
import '../../data/repositories/trend_repo.dart';
import '../../services/location_service.dart';
import '../../services/notification_service.dart';
import '../../services/pricing_service.dart';
import '../../services/trend_service.dart';

class GlobalBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<GetStorage>(GetStorage());
    Get.lazyPut<GetStorageDataSource>(() => GetStorageDataSource(Get.find()));
    Get.lazyPut<StubApiDataSource>(() => StubApiDataSource());

    Get.lazyPut<ProductRepository>(() => ProductRepository(
          remoteDataSource: Get.find(),
          localDataSource: Get.find(),
        ));
    Get.lazyPut<TrendRepository>(() => TrendRepository(
          remoteDataSource: Get.find(),
          localDataSource: Get.find(),
        ));
    Get.lazyPut<LocationRepository>(() => LocationRepository(
          remoteDataSource: Get.find(),
          localDataSource: Get.find(),
        ));
    Get.lazyPut<AuctionRepository>(() => AuctionRepository(
          remoteDataSource: Get.find(),
          localDataSource: Get.find(),
        ));

    Get.lazyPut<NotificationService>(() => NotificationService(localDataSource: Get.find()));
    Get.lazyPut<PricingService>(() => PricingService());
    Get.lazyPut<TrendService>(() => TrendService(
          trendRepository: Get.find(),
          productRepository: Get.find(),
        ));
    Get.lazyPut<LocationService>(() => LocationService(
          locationRepository: Get.find(),
          storageDataSource: Get.find(),
        ));
  }
}
