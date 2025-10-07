import 'package:get/get.dart';

import '../../../core/services/feature_service.dart';
import '../../../core/services/settings_service.dart';
import '../../../routes/app_routes.dart';

class HomeController extends GetxController {
  final SettingsService _settings = Get.find<SettingsService>();
  final FeatureService _featureService = Get.find<FeatureService>();

  final cards = const [
    (
      titleKey: 'home_quiz',
      descriptionKey: 'home_quiz_desc',
      route: AppRoutes.quiz,
      gradientId: 'quiz_card',
      icon: 'psychology',
    ),
    (
      titleKey: 'home_insights',
      descriptionKey: 'home_insights_desc',
      route: AppRoutes.insights,
      gradientId: 'insights_card',
      icon: 'chat',
    ),
    (
      titleKey: 'home_compare',
      descriptionKey: 'home_compare_desc',
      route: AppRoutes.compare,
      gradientId: 'compare_card',
      icon: 'groups',
    ),
  ];

  RxString get displayName => _settings.displayNameRx;
  RxInt get streak => _settings.streakRx;

  List highlightFeatures() => _featureService.highlights();
  bool get reducedMotion => _featureService.isEnabled('reduced_motion');
  bool get focusMode => _featureService.isEnabled('focus_mode');

  String greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'greeting_morning'.tr;
    if (hour < 18) return 'greeting_afternoon'.tr;
    return 'greeting_evening'.tr;
  }

  void open(String route) {
    if (focusMode && route != AppRoutes.quiz) {
      Get.snackbar('feature_focus_mode_title'.tr, 'feature_focus_mode_desc'.tr,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    Get.toNamed(route);
  }

  void openSettings() {
    Get.toNamed(AppRoutes.settings);
  }

  void openFeatures() {
    Get.toNamed(AppRoutes.features);
  }

  Future<void> celebrateReflection() {
    return _settings.registerReflection();
  }
}
