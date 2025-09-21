import 'package:get/get.dart';

import '../../modules/alerts/alerts_binding.dart';
import '../../modules/alerts/alerts_view.dart';
import '../../modules/auctions/auctions_binding.dart';
import '../../modules/auctions/auction_detail_view.dart';
import '../../modules/auctions/auctions_view.dart';
import '../../modules/auth/auth_binding.dart';
import '../../modules/auth/login_view.dart';
import '../../modules/categories/categories_binding.dart';
import '../../modules/categories/categories_view.dart';
import '../../modules/deals/deals_binding.dart';
import '../../modules/deals/deals_view.dart';
import '../../modules/favorites/favorites_binding.dart';
import '../../modules/favorites/favorites_view.dart';
import '../../modules/home/home_binding.dart';
import '../../modules/home/home_view.dart';
import '../../modules/onboarding/onboarding_binding.dart';
import '../../modules/onboarding/onboarding_view.dart';
import '../../modules/product_detail/product_detail_binding.dart';
import '../../modules/product_detail/product_detail_view.dart';
import '../../modules/profile/profile_binding.dart';
import '../../modules/profile/settings_view.dart';
import '../../modules/search/search_binding.dart';
import '../../modules/search/search_view.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = <GetPage<dynamic>>[
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: AppRoutes.auth,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: '${AppRoutes.product}/:id',
      page: () => const ProductDetailView(),
      binding: ProductDetailBinding(),
    ),
    GetPage(
      name: '${AppRoutes.auction}/:id',
      page: () => const AuctionDetailView(),
      binding: AuctionsBinding(),
    ),
    GetPage(
      name: AppRoutes.deals,
      page: () => const DealsView(),
      binding: DealsBinding(),
    ),
    GetPage(
      name: AppRoutes.alerts,
      page: () => const AlertsView(),
      binding: AlertsBinding(),
    ),
    GetPage(
      name: AppRoutes.favorites,
      page: () => const FavoritesView(),
      binding: FavoritesBinding(),
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.search,
      page: () => const SearchView(),
      binding: SearchBinding(),
    ),
    GetPage(
      name: '/categories',
      page: () => const CategoriesView(),
      binding: CategoriesBinding(),
    ),
  ];
}
