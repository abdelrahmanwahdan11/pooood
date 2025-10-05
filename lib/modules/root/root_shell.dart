import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../main.dart';
import '../auth/auth_routes.dart';
import '../auth/auth_view.dart';
import '../chat/chat_routes.dart';
import '../chat/chat_view.dart';
import '../home/home_routes.dart';
import '../home/home_view.dart';
import '../home/ideas_view.dart';
import '../onboarding/onboarding_routes.dart';
import '../onboarding/onboarding_view.dart';
import '../product/product_routes.dart';
import '../product/product_view.dart';
import '../trust/trust_binding.dart';
import '../trust/trust_routes.dart';
import '../trust/trust_view.dart';

class RootShell extends GetView<AppController> {
  const RootShell({super.key});

  static const route = '/root';

  static List<GetPage<dynamic>> get routes => [
        GetPage(name: route, page: RootShell.new),
        GetPage(name: OnboardingRoutes.route, page: OnboardingView.new),
        GetPage(name: AuthRoutes.route, page: AuthView.new),
        GetPage(name: HomeRoutes.route, page: HomeView.new),
        GetPage(name: HomeRoutes.ideasRoute, page: IdeasView.new),
        GetPage(name: ProductRoutes.route, page: ProductView.new),
        GetPage(name: ChatRoutes.route, page: ChatView.new),
        GetPage(name: TrustRoutes.route, page: TrustView.new, binding: TrustBinding()),
      ];

  @override
  Widget build(context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final target = controller.initialRoute;
      if (Get.currentRoute != target) {
        Get.offAllNamed(target);
      }
    });
    return const SizedBox.shrink();
  }
}
