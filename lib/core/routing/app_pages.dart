import 'package:get/get.dart';

import '../../modules/auctions/auction_detail_view.dart';
import '../../modules/auctions/auctions_controller.dart';
import '../../modules/auth/auth_controller.dart';
import '../../modules/auth/login_view.dart';
import '../../modules/auth/signup_view.dart';
import '../../modules/deals/deals_controller.dart';
import '../../modules/deals/deals_view.dart';
import '../../modules/home/home_controller.dart';
import '../../modules/home/home_view.dart';
import '../../modules/language_gate/language_controller.dart';
import '../../modules/language_gate/language_view.dart';
import '../../modules/map/map_controller.dart';
import '../../modules/map/map_view.dart';
import '../../modules/onboarding/onboarding_controller.dart';
import '../../modules/onboarding/onboarding_view.dart';
import '../../modules/pricing/pricing_controller.dart';
import '../../modules/pricing/pricing_view.dart';
import '../../modules/settings/settings_controller.dart';
import '../../modules/settings/settings_view.dart';
import '../../modules/splash/splash_view.dart';
import '../../modules/wanted/wanted_controller.dart';
import '../../modules/wanted/wanted_view.dart';
import '../../services/auction_sync_service.dart';
import '../../services/auth_service.dart';
import '../../services/gemini_service.dart';
import '../../services/location_service.dart';
import '../../services/notification_service.dart';
import '../../services/pricing_service.dart';
import '../../core/routing/app_routes.dart';
import '../../data/datasources/local/get_storage_ds.dart';
import '../../data/repositories/auction_repo.dart';
import '../../data/repositories/deal_repo.dart';
import '../../data/repositories/product_repo.dart';
import '../../data/repositories/wanted_repo.dart';

class AppPages {
  static final routes = <GetPage<dynamic>>[
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: BindingsBuilder(() {
        Get.put(SplashController(Get.find<GetStorageDataSource>()));
      }),
    ),
    GetPage(
      name: AppRoutes.language,
      page: () => const LanguageGateView(),
      binding: BindingsBuilder(() {
        Get.put(LanguageController(Get.find<GetStorageDataSource>()));
      }),
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingView(),
      binding: BindingsBuilder(() {
        Get.put(OnboardingController(Get.find<GetStorageDataSource>()));
      }),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: BindingsBuilder(() {
        Get.put(AuthController(
          Get.find<AuthService>(),
          Get.find<NotificationService>(),
        ));
      }),
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => const SignupView(),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<AuthController>()) {
          Get.put(AuthController(
            Get.find<AuthService>(),
            Get.find<NotificationService>(),
          ));
        }
      }),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: BindingsBuilder(() {
        Get.put(HomeController());
        Get.lazyPut(
          () => AuctionsController(
            Get.find<AuctionRepository>(),
            Get.find<ProductRepository>(),
            Get.find<LocationService>(),
          ),
          fenix: true,
        );
        Get.lazyPut(
          () => DealsController(
            Get.find<DealRepository>(),
            Get.find<ProductRepository>(),
            Get.find<LocationService>(),
          ),
          fenix: true,
        );
        Get.lazyPut(
          () => WantedController(
            Get.find<WantedRepository>(),
            Get.find<LocationService>(),
          ),
          fenix: true,
        );
        Get.lazyPut(
          () => PricingController(
            Get.find<PricingService>(),
            Get.find<GeminiService>(),
          ),
          fenix: true,
        );
        Get.lazyPut(
          () => MapController(
            Get.find<WantedRepository>(),
            Get.find<LocationService>(),
          ),
          fenix: true,
        );
        Get.lazyPut(
          () => SettingsController(
            Get.find<NotificationService>(),
            Get.find<LocationService>(),
            Get.find<AuthService>(),
            Get.find<GetStorageDataSource>(),
          ),
          fenix: true,
        );
      }),
    ),
    GetPage(
      name: '${AppRoutes.auctionDetail}/:id',
      page: () => const AuctionDetailView(),
      binding: BindingsBuilder(() {
        Get.put(AuctionDetailController(
          Get.find<AuctionRepository>(),
          Get.find<ProductRepository>(),
          Get.find<AuctionSyncService>(),
          Get.find<AuthService>(),
        ));
      }),
    ),
    GetPage(
      name: AppRoutes.deals,
      page: () => const DealsView(),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<DealsController>()) {
          Get.put(
            DealsController(
              Get.find<DealRepository>(),
              Get.find<ProductRepository>(),
              Get.find<LocationService>(),
            ),
          );
        }
      }),
    ),
    GetPage(
      name: AppRoutes.pricing,
      page: () => const PricingView(),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<PricingController>()) {
          Get.put(
            PricingController(
              Get.find<PricingService>(),
              Get.find<GeminiService>(),
            ),
          );
        }
      }),
    ),
    GetPage(
      name: AppRoutes.wanted,
      page: () => const WantedView(),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<WantedController>()) {
          Get.put(
            WantedController(
              Get.find<WantedRepository>(),
              Get.find<LocationService>(),
            ),
          );
        }
      }),
    ),
    GetPage(
      name: AppRoutes.map,
      page: () => const MapView(),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<MapController>()) {
          Get.put(
            MapController(
              Get.find<WantedRepository>(),
              Get.find<LocationService>(),
            ),
          );
        }
      }),
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsView(),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<SettingsController>()) {
          Get.put(
            SettingsController(
              Get.find<NotificationService>(),
              Get.find<LocationService>(),
              Get.find<AuthService>(),
              Get.find<GetStorageDataSource>(),
            ),
          );
        }
      }),
    ),
  ];
}
