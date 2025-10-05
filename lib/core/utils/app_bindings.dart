import 'package:get/get.dart';

import '../../main.dart';
import '../../modules/auth/auth_binding.dart';
import '../../modules/chat/chat_binding.dart';
import '../../modules/home/home_binding.dart';
import '../../modules/onboarding/onboarding_binding.dart';
import '../../modules/product/product_binding.dart';
import '../../modules/trust/trust_binding.dart';

class AppBindings extends Bindings {
  AppBindings();

  @override
  void dependencies() {
    OnboardingBinding().dependencies();
    AuthBinding().dependencies();
    HomeBinding().dependencies();
    ProductBinding().dependencies();
    ChatBinding().dependencies();
    TrustBinding().dependencies();
  }
}
