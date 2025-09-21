import 'package:get/get.dart';

import '../../core/routing/app_routes.dart';
import '../../data/datasources/local/get_storage_ds.dart';

class OnboardingController extends GetxController {
  OnboardingController(this._local);

  final GetStorageDataSource _local;

  final RxInt currentPage = 0.obs;

  void changePage(int index) {
    currentPage.value = index;
  }

  Future<void> completeOnboarding() async {
    await _local.setOnboardingComplete(true);
    Get.offAllNamed(AppRoutes.home);
  }

  void skip() => completeOnboarding();
}
