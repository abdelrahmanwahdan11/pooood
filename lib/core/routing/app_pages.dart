import 'package:get/get.dart';

import '../../modules/auctions/auction_detail_view.dart';
import '../../modules/auctions/auctions_view.dart';
import '../../modules/home/home_view.dart';
import '../../modules/onboarding/onboarding_view.dart';
import '../../modules/pricing/pricing_view.dart';
import '../../modules/settings/settings_view.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static final routes = <GetPage<dynamic>>[
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingView(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
    ),
    GetPage(
      name: AppRoutes.auctions,
      page: () => const AuctionsView(),
    ),
    GetPage(
      name: '${AppRoutes.auctionDetail}/:id',
      page: () => AuctionDetailView(auctionId: Get.parameters['id'] ?? ''),
    ),
    GetPage(
      name: AppRoutes.pricing,
      page: () => const PricingView(),
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsView(),
    ),
  ];
}
