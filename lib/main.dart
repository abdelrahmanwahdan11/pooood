import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/localization/app_translations.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_bindings.dart';
import 'core/widgets/hard_shadow_box.dart';
import 'data/marketplace_repository.dart';
import 'data/product_repository.dart';
import 'models/feature_idea.dart';
import 'models/locale_text.dart';
import 'models/marketplace_meta.dart';
import 'models/product.dart';
import 'modules/auth/auth_routes.dart';
import 'modules/home/home_routes.dart';
import 'modules/onboarding/onboarding_routes.dart';
import 'modules/root/root_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final controller = AppController(prefs: prefs);
  await controller.initialize();
  Get.put<AppController>(controller, permanent: true);
  runApp(AppRoot(controller: controller));
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key, required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GetMaterialApp(
        title: 'HYPER MARKET',
        debugShowCheckedModeBanner: false,
        translations: AppTranslations(),
        locale: controller.locale.value,
        fallbackLocale: const Locale('en'),
        supportedLocales: const [Locale('en'), Locale('ar')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        theme: AppTheme.buildTheme(isMonochrome: controller.isMonochrome.value),
        initialBinding: AppBindings(),
        initialRoute: RootShell.route,
        getPages: RootShell.routes,
        builder: (context, child) {
          final media = MediaQuery.of(context);
          final scale = media.textScaler.clamp(minScale: 0.9, maxScale: 1.1);
          return MediaQuery(data: media.copyWith(textScaler: scale), child: child ?? const SizedBox.shrink());
        },
      ),
    );
  }
}

class AppController extends GetxController {
  AppController({required this.prefs});

  final SharedPreferences prefs;

  final Rx<Locale> locale = const Locale('en').obs;
  final RxBool isMonochrome = false.obs;
  final RxBool isAuthenticated = false.obs;
  final RxBool completedOnboarding = false.obs;
  final RxList<Product> products = <Product>[].obs;
  final RxList<Product> visibleProducts = <Product>[].obs;
  final RxBool isFetching = false.obs;
  final RxBool hasMoreProducts = true.obs;
  final RxSet<String> favoriteIds = <String>{}.obs;
  final RxSet<String> cartIds = <String>{}.obs;
  final RxSet<String> compareIds = <String>{}.obs;
  final RxSet<String> selectedCategories = <String>{}.obs;
  final RxMap<String, double> ratings = <String, double>{}.obs;
  final RxString sortMode = 'popularity'.obs;
  final RxBool hasSavedSearch = false.obs;
  Timer? _usageTimer;
  FlutterLocalNotificationsPlugin? notificationsPlugin;
  int _page = 0;
  static const int pageSize = 6;

  ColorPalette get palette => isMonochrome.value ? ColorPalette.monochrome() : ColorPalette.colorful();

  String get initialRoute {
    if (!completedOnboarding.value) return OnboardingRoutes.route;
    return isAuthenticated.value ? HomeRoutes.route : AuthRoutes.route;
  }

  List<Product> get allProducts => ProductRepository.allProducts();
  List<CategoryTag> get categoryTags => MarketplaceRepository.categories;
  List<HighlightMetric> get marketHighlights => MarketplaceRepository.marketHighlights;
  List<LocaleText> get liveMoments => MarketplaceRepository.liveMoments;
  List<MarketplaceCollection> get collections => MarketplaceRepository.collections;
  List<Vendor> get vendors => MarketplaceRepository.vendors;
  List<TrustBadge> get trustBadges => MarketplaceRepository.trustBadges;
  List<MarketplacePolicy> get policies => MarketplaceRepository.policies;
  List<MarketplaceReport> get reports => MarketplaceRepository.reports;
  List<MarketplaceStory> get trustStories => MarketplaceRepository.marketplaceStories;
  String get sortLabel => 'sort_mode_${sortMode.value}'.tr;

  Future<void> initialize() async {
    final savedLocale = prefs.getString('locale');
    if (savedLocale != null) locale.value = Locale(savedLocale);
    isMonochrome.value = prefs.getBool('isMonochrome') ?? false;
    completedOnboarding.value = prefs.getBool('completedOnboarding') ?? false;
    isAuthenticated.value = prefs.getBool('isAuthenticated') ?? false;
    favoriteIds.addAll(prefs.getStringList('favorites') ?? const []);
    cartIds.addAll(prefs.getStringList('cart') ?? const []);
    compareIds.addAll(prefs.getStringList('compare') ?? const []);
    hasSavedSearch.value = prefs.getBool('saved_search') ?? false;
    final savedRatings = prefs.getString('ratings');
    if (savedRatings != null) {
      ratings.assignAll(ProductRepository.decodeRatings(savedRatings));
    }
    await _initNotifications();
    await refreshProducts();
    _restartUsageTimer();
  }

  Future<void> _initNotifications() async {
    if (kIsWeb) return;
    final plugin = FlutterLocalNotificationsPlugin();
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    final darwin = DarwinInitializationSettings();
    final initSettings = InitializationSettings(android: androidSettings, iOS: darwin, macOS: darwin);
    await plugin.initialize(initSettings);
    notificationsPlugin = plugin;
  }

  Future<void> refreshProducts() async {
    _page = 0;
    hasMoreProducts.value = true;
    final firstPage = await ProductRepository.fetchPage(page: _page, pageSize: pageSize);
    products.assignAll(firstPage);
    _page++;
    _applyFilters();
  }

  Future<void> loadMore() async {
    if (isFetching.value || !hasMoreProducts.value) return;
    isFetching.value = true;
    final next = await ProductRepository.fetchPage(page: _page, pageSize: pageSize);
    if (next.isEmpty) {
      hasMoreProducts.value = false;
    } else {
      products.addAll(next);
      _page++;
      _applyFilters();
    }
    isFetching.value = false;
  }

  Future<void> toggleTheme() async {
    isMonochrome.toggle();
    await prefs.setBool('isMonochrome', isMonochrome.value);
    _restartUsageTimer();
  }

  Future<void> toggleLanguage() async {
    final newLocale = locale.value.languageCode == 'ar' ? const Locale('en') : const Locale('ar');
    locale.value = newLocale;
    await prefs.setString('locale', newLocale.languageCode);
    Get.updateLocale(newLocale);
    _restartUsageTimer();
  }

  Future<void> completeOnboarding() async {
    completedOnboarding.value = true;
    await prefs.setBool('completedOnboarding', true);
    Get.offAllNamed(initialRoute);
  }

  Future<void> authenticate({required String email, required String password}) async {
    await Future<void>.delayed(const Duration(milliseconds: 480));
    isAuthenticated.value = true;
    await prefs.setBool('isAuthenticated', true);
    Get.offAllNamed(HomeRoutes.route);
    _restartUsageTimer();
  }

  Future<void> signOut() async {
    isAuthenticated.value = false;
    await prefs.setBool('isAuthenticated', false);
    Get.offAllNamed(AuthRoutes.route);
  }

  double ratingFor(Product product) => ratings[product.id] ?? product.initialRating;

  Future<void> setRating(Product product, double value) async {
    ratings[product.id] = value;
    await prefs.setString('ratings', ProductRepository.encodeRatings(ratings));
    _restartUsageTimer();
  }

  Future<void> toggleFavorite(Product product) async {
    if (favoriteIds.contains(product.id)) {
      favoriteIds.remove(product.id);
    } else {
      favoriteIds.add(product.id);
      await _notifyAction('favorite', product);
      await _showCelebration();
    }
    await prefs.setStringList('favorites', favoriteIds.toList());
    _restartUsageTimer();
  }

  Future<void> toggleCart(Product product) async {
    if (cartIds.contains(product.id)) {
      cartIds.remove(product.id);
    } else {
      cartIds.add(product.id);
      await _notifyAction('cart', product);
      await _showCelebration();
    }
    await prefs.setStringList('cart', cartIds.toList());
    _restartUsageTimer();
  }

  Future<void> toggleCompare(Product product) async {
    if (compareIds.contains(product.id)) {
      compareIds.remove(product.id);
      await prefs.setStringList('compare', compareIds.toList());
      Get.snackbar(
        'compare_drawer_title'.tr,
        'compare_removed_snack'.trParams({'name': product.name(locale.value)}),
        backgroundColor: palette.surface,
        colorText: Colors.black,
        margin: const EdgeInsets.all(20),
        snackPosition: SnackPosition.BOTTOM,
      );
      _restartUsageTimer();
      return;
    }
    if (compareIds.length >= 3) {
      Get.snackbar(
        'compare_drawer_title'.tr,
        'compare_limit_snack'.tr,
        backgroundColor: palette.surface,
        colorText: Colors.black,
        margin: const EdgeInsets.all(20),
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    compareIds.add(product.id);
    await prefs.setStringList('compare', compareIds.toList());
    Get.snackbar(
      'compare_drawer_title'.tr,
      'compare_added_snack'.trParams({'name': product.name(locale.value)}),
      backgroundColor: palette.surface,
      colorText: Colors.black,
      margin: const EdgeInsets.all(20),
      snackPosition: SnackPosition.BOTTOM,
    );
    _restartUsageTimer();
  }

  bool isCompared(Product product) => compareIds.contains(product.id);

  List<Product> compareProducts() =>
      allProducts.where((product) => compareIds.contains(product.id)).toList();

  Future<void> toggleSavedSearch() async {
    hasSavedSearch.toggle();
    await prefs.setBool('saved_search', hasSavedSearch.value);
    final key = hasSavedSearch.value ? 'save_search_added' : 'save_search_removed';
    Get.snackbar(
      'quick_actions_title'.tr,
      key.tr,
      backgroundColor: palette.surface,
      colorText: Colors.black,
      margin: const EdgeInsets.all(20),
      snackPosition: SnackPosition.BOTTOM,
    );
    _restartUsageTimer();
  }

  void shareMarketplace() {
    Get.dialog(
      Center(
        child: HardShadowBox(
          backgroundColor: palette.surface,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('share_marketplace_title'.tr, style: GoogleFonts.bebasNeue(fontSize: 32, letterSpacing: 2, color: Colors.black)),
              const SizedBox(height: 12),
              Text(
                'share_marketplace_body'.tr,
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 18),
              GestureDetector(
                onTap: () {
                  Get.back();
                  Get.snackbar(
                    'share_marketplace_title'.tr,
                    'share_marketplace_copied'.tr,
                    backgroundColor: palette.surface,
                    colorText: Colors.black,
                    margin: const EdgeInsets.all(20),
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
                child: HardShadowBox(
                  backgroundColor: palette.card,
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                  child: Text('copy_link'.tr, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierColor: Colors.black.withOpacity(0.55),
    );
    _restartUsageTimer();
  }

  void shareProduct(Product product) {
    final localeValue = Get.locale ?? locale.value;
    Get.dialog(
      Center(
        child: HardShadowBox(
          backgroundColor: palette.surface,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('share_product_title'.tr, style: GoogleFonts.bebasNeue(fontSize: 30, letterSpacing: 1.8, color: Colors.black)),
              const SizedBox(height: 12),
              Text(
                'share_product_body'.trParams({'name': product.name(localeValue)}),
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 18),
              GestureDetector(
                onTap: () {
                  Get.back();
                  Get.snackbar(
                    'share_product_title'.tr,
                    'share_product_hint'.tr,
                    backgroundColor: palette.surface,
                    colorText: Colors.black,
                    margin: const EdgeInsets.all(20),
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
                child: HardShadowBox(
                  backgroundColor: palette.card,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Text('copy_link'.tr, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierColor: Colors.black.withOpacity(0.55),
    );
    _restartUsageTimer();
  }

  void triggerRestock(Product product) {
    Get.snackbar(
      'restock_alert_title'.tr,
      'restock_alert_body'.trParams({'name': product.name(locale.value)}),
      backgroundColor: palette.surface,
      colorText: Colors.black,
      margin: const EdgeInsets.all(20),
      snackPosition: SnackPosition.BOTTOM,
    );
    _restartUsageTimer();
  }

  void downloadSpecs(Product product) {
    Get.snackbar(
      'spec_download_title'.tr,
      'spec_download_body'.trParams({'name': product.name(locale.value)}),
      backgroundColor: palette.surface,
      colorText: Colors.black,
      margin: const EdgeInsets.all(20),
      snackPosition: SnackPosition.BOTTOM,
    );
    _restartUsageTimer();
  }

  ProductMeta metaFor(String productId) => MarketplaceRepository.metaFor(productId);

  Vendor vendorFor(String vendorId) =>
      vendors.firstWhere((vendor) => vendor.id == vendorId, orElse: () => vendors.first);

  List<MarketplaceStory> testimonialsFor(Product product) =>
      MarketplaceRepository.testimonialsFor(product.id);

  List<QaEntry> qaFor(Product product) => MarketplaceRepository.qaFor(product.id);

  List<Product> collectionProducts(MarketplaceCollection collection) =>
      allProducts.where((product) => collection.productIds.contains(product.id)).take(4).toList();

  void toggleCategory(String id) {
    if (selectedCategories.contains(id)) {
      selectedCategories.remove(id);
    } else {
      selectedCategories.add(id);
    }
    _applyFilters();
  }

  void cycleSortMode() {
    const order = ['popularity', 'priceLow', 'priceHigh', 'rating'];
    final index = order.indexOf(sortMode.value);
    sortMode.value = order[(index + 1) % order.length];
    _applyFilters();
  }

  void _applyFilters() {
    final List<Product> filtered = selectedCategories.isEmpty
        ? List<Product>.from(products)
        : products.where((product) {
            final meta = metaFor(product.id);
            return meta.categoryIds.any(selectedCategories.contains);
          }).toList();

    switch (sortMode.value) {
      case 'priceLow':
        filtered.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'priceHigh':
        filtered.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'rating':
        filtered.sort((a, b) => ratingFor(b).compareTo(ratingFor(a)));
        break;
      default:
        filtered.sort((a, b) {
          final metaA = metaFor(a.id);
          final metaB = metaFor(b.id);
          final sustainabilityCompare = metaB.sustainabilityScore.compareTo(metaA.sustainabilityScore);
          if (sustainabilityCompare != 0) return sustainabilityCompare;
          return ratingFor(b).compareTo(ratingFor(a));
        });
        break;
    }

    visibleProducts.assignAll(filtered);
  }

  Future<void> _notifyAction(String type, Product product) async {
    final title = type == 'favorite'
        ? 'notification_favorite_title'.trParams({'name': product.name(locale.value)})
        : 'notification_cart_title'.trParams({'name': product.name(locale.value)});
    final body = type == 'favorite' ? 'notification_favorite_body'.tr : 'notification_cart_body'.tr;
    if (kIsWeb || notificationsPlugin == null) {
      Get.snackbar(title, body, backgroundColor: palette.surface, colorText: Colors.black, snackPosition: SnackPosition.TOP, margin: const EdgeInsets.all(16));
      return;
    }
    final details = NotificationDetails(
      android: AndroidNotificationDetails('hyper-market', 'Quick Actions', importance: Importance.high, priority: Priority.high),
      iOS: const DarwinNotificationDetails(),
      macOS: const DarwinNotificationDetails(),
    );
    await notificationsPlugin!.show(DateTime.now().millisecondsSinceEpoch ~/ 1000, title, body, details);
  }

  Future<void> _showCelebration() async {
    await Get.dialog(
      Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(color: palette.surface, borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.black, width: 3)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 160,
                width: 160,
                child: Lottie.asset('assets/celebration.json', repeat: false),
              ),
              const SizedBox(height: 16),
              Text('lottie_success_title'.tr, style: GoogleFonts.bebasNeue(fontSize: 32, letterSpacing: 2, color: Colors.black)),
            ],
          ),
        ),
      ),
      barrierColor: Colors.black.withOpacity(0.55),
    );
  }

  void _restartUsageTimer() {
    _usageTimer?.cancel();
    _usageTimer = Timer(const Duration(minutes: 30), _showUsageReminder);
  }

  void _showUsageReminder() {
    if (Get.context == null) return;
    Get.snackbar('usage_reminder_title'.tr, 'usage_reminder_body'.tr, backgroundColor: palette.surface, colorText: Colors.black, margin: const EdgeInsets.all(20), snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 6));
    _restartUsageTimer();
  }

  List<FeatureIdea> featureIdeas() => FeatureIdeaRepository.build(locale.value);

  @override
  void onClose() {
    _usageTimer?.cancel();
    super.onClose();
  }
}
