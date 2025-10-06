import 'package:get/get.dart';

import '../../../routes/app_routes.dart';

class HomeController extends GetxController {
  final cards = [
    (
      titleKey: 'home_quiz',
      descriptionKey: 'results_title',
      route: AppRoutes.quiz,
      gradientId: 'quiz_card',
    ),
    (
      titleKey: 'home_insights',
      descriptionKey: 'insights_title',
      route: AppRoutes.insights,
      gradientId: 'insights_card',
    ),
    (
      titleKey: 'home_compare',
      descriptionKey: 'compare_title',
      route: AppRoutes.compare,
      gradientId: 'compare_card',
    ),
  ];

  void open(String route) {
    Get.toNamed(route);
  }

  void openSettings() {
    Get.toNamed(AppRoutes.settings);
  }
}
