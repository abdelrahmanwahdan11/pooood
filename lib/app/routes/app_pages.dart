import 'package:get/get.dart';

import '../modules/language_select/bindings/language_select_binding.dart';
import '../modules/language_select/views/language_select_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.language;

  static final routes = <GetPage<dynamic>>[
    GetPage<dynamic>(
      name: Routes.language,
      page: () => const LanguageSelectView(),
      binding: LanguageSelectBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage<dynamic>(
      name: Routes.onboarding,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
  ];
}
