import 'package:get/get.dart';

import '../modules/auth/forgot/forgot_binding.dart';
import '../modules/auth/forgot/views/forgot_view.dart';
import '../modules/auth/signin/signin_binding.dart';
import '../modules/auth/signin/views/signin_view.dart';
import '../modules/auth/signup/signup_binding.dart';
import '../modules/auth/signup/views/signup_view.dart';
import '../modules/compare/compare_binding.dart';
import '../modules/compare/views/compare_view.dart';
import '../modules/home/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/insights/insights_binding.dart';
import '../modules/insights/views/insights_view.dart';
import '../modules/invite/invite_binding.dart';
import '../modules/invite/views/invite_view.dart';
import '../modules/onboarding/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/profile/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/quiz/quiz_binding.dart';
import '../modules/quiz/views/quiz_view.dart';
import '../modules/results/results_binding.dart';
import '../modules/results/views/results_view.dart';
import '../modules/settings/settings_binding.dart';
import '../modules/settings/views/settings_view.dart';
import '../modules/splash/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = AppRoutes.splash;

  static final routes = <GetPage<dynamic>>[
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: AppRoutes.signin,
      page: () => const SignInView(),
      binding: SignInBinding(),
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => const SignUpView(),
      binding: SignUpBinding(),
    ),
    GetPage(
      name: AppRoutes.forgot,
      page: () => const ForgotView(),
      binding: ForgotBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.quiz,
      page: () => const QuizView(),
      binding: QuizBinding(),
    ),
    GetPage(
      name: AppRoutes.results,
      page: () => const ResultsView(),
      binding: ResultsBinding(),
    ),
    GetPage(
      name: AppRoutes.insights,
      page: () => const InsightsView(),
      binding: InsightsBinding(),
    ),
    GetPage(
      name: AppRoutes.compare,
      page: () => const CompareView(),
      binding: CompareBinding(),
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.invite,
      page: () => const InviteView(),
      binding: InviteBinding(),
    ),
  ];
}
