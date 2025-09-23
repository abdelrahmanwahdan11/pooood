import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/routing/app_routes.dart';
import '../../core/theme/glass_widgets.dart';
import '../../data/datasources/local/get_storage_ds.dart';

class SplashController extends GetxController {
  SplashController(this._storage);

  final GetStorageDataSource _storage;

  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(seconds: 2), () {
      final locale = _storage.read<String>('locale');
      final onboardingDone = _storage.read<bool>('onboarding_complete') ?? false;
      if (locale == null) {
        Get.offAllNamed(AppRoutes.language);
      } else if (!onboardingDone) {
        Get.offAllNamed(AppRoutes.onboarding);
      } else {
        Get.offAllNamed(AppRoutes.home);
      }
    });
  }
}

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const FlutterLogo(size: 96),
            const SizedBox(height: 20),
            Text('app_name'.tr, style: Get.textTheme.displaySmall),
            const SizedBox(height: 12),
            const CircularProgressIndicator.adaptive(),
          ],
        ),
      ),
    );
  }
}
