import 'package:get/get.dart';

import '../../data/datasources/remote/stub_api_ds.dart';
import '../../data/repositories/auction_repo.dart';
import '../../data/repositories/product_repo.dart';
import '../../services/trend_service.dart';
import 'home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(
        productRepository: Get.find<ProductRepository>(),
        trendService: Get.find<TrendService>(),
        auctionRepository: Get.find<AuctionRepository>(),
        remoteDataSource: Get.find<StubApiDataSource>(),
      ),
    );
  }
}
