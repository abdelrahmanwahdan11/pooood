import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../main.dart';
import '../../models/product.dart';
import '../chat/chat_routes.dart';
import '../product/product_routes.dart';
import 'home_routes.dart';

class HomeController extends GetxController {
  final ScrollController scrollController = ScrollController();
  AppController get appController => Get.find<AppController>();

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_handleScroll);
  }

  List<Product> get products => appController.products;

  Future<void> refresh() async {
    await appController.refreshProducts();
  }

  void _handleScroll() {
    if (scrollController.position.extentAfter < 300 && appController.hasMoreProducts.value) {
      appController.loadMore();
    }
  }

  void toggleTheme() => appController.toggleTheme();

  void toggleLanguage() => appController.toggleLanguage();

  void openProduct(Product product) {
    Get.toNamed(ProductRoutes.route, arguments: product);
  }

  void openChat() => Get.toNamed(ChatRoutes.route);

  void openFeatureIdeas() => Get.toNamed(HomeRoutes.ideasRoute);

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
