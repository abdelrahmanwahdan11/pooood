/*
  هذا الملف يربط المسارات بوحدات GetX عبر الصفحات والبايندينغ.
  يمكن إضافة صفحات جديدة أو تحديث الربط بسهولة عند توسيع التطبيق.
*/
import 'package:get/get.dart';

import '../modules/additem/bindings/additem_binding.dart';
import '../modules/additem/views/additem_view.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/auth/views/signup_view.dart';
import '../modules/details/bindings/details_binding.dart';
import '../modules/details/views/details_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/mybids/bindings/mybids_binding.dart';
import '../modules/mybids/views/mybids_view.dart';
import '../modules/settings/bindings/settings_binding.dart';
import '../modules/settings/views/settings_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/wishlist/bindings/wishlist_binding.dart';
import '../modules/wishlist/views/wishlist_view.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = <GetPage<dynamic>>[
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: AuthBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => const SignupView(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
      transition: Transition.zoom,
    ),
    GetPage(
      name: AppRoutes.details,
      page: () => const DetailsView(),
      binding: DetailsBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: AppRoutes.wishlist,
      page: () => const WishlistView(),
      binding: WishlistBinding(),
      transition: Transition.fade,
    ),
    GetPage(
      name: AppRoutes.myBids,
      page: () => const MybidsView(),
      binding: MybidsBinding(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: AppRoutes.addItem,
      page: () => const AdditemView(),
      binding: AdditemBinding(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
      transition: Transition.fadeIn,
    ),
  ];
}
