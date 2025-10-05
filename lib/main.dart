import 'dart:async';
import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await SharedPreferences.getInstance();
  final controller = AppController(prefs: preferences);
  await controller.init();
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
        title: 'Liquid Experience',
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
        theme: AppThemeBuilder.build(
          isMonochrome: controller.isMonochrome.value,
          locale: controller.locale.value,
        ),
        initialRoute: '/root',
        defaultTransition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 240),
        getPages: const [
          GetPage(name: '/root', page: RootRouter.new),
          GetPage(name: '/onboarding', page: OnboardingPackage.new),
          GetPage(name: '/auth', page: AuthPackage.new),
          GetPage(name: '/home', page: HomeShell.new),
          GetPage(name: '/detail', page: ProductDetailPage.new),
        ],
        builder: (context, child) {
          final media = MediaQuery.of(context);
          final scale = media.textScaler.clamp(minScale: 0.9, maxScale: 1.1);
          return MediaQuery(
            data: media.copyWith(textScaler: scale),
            child: child ?? const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}

class RootRouter extends GetView<AppController> {
  const RootRouter({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final targetRoute = controller.initialRoute;
      if (Get.currentRoute != targetRoute) {
        Get.offAllNamed(targetRoute);
      }
    });
    return Scaffold(
      backgroundColor: controller.palette.background,
      body: Center(
        child: CircularProgressIndicator(
          color: controller.palette.accent,
        ),
      ),
    );
  }
}

class AppController extends GetxController {
  AppController({required this.prefs});

  final SharedPreferences prefs;

  final Rx<Locale> locale = const Locale('en').obs;
  final RxBool isMonochrome = false.obs;
  final RxBool hasCompletedOnboarding = false.obs;
  final RxBool isAuthenticated = false.obs;
  final RxInt navIndex = 0.obs;
  final RxList<Product> products = <Product>[].obs;
  final RxBool isFetching = false.obs;
  final RxBool hasMoreProducts = true.obs;
  final RxSet<String> favoriteProductIds = <String>{}.obs;
  final RxSet<String> cartProductIds = <String>{}.obs;
  final RxMap<String, double> ratings = <String, double>{}.obs;

  Timer? _usageTimer;
  FlutterLocalNotificationsPlugin? notificationsPlugin;
  int _page = 0;
  static const int _pageSize = 6;

  ColorPalette get palette =>
      isMonochrome.value ? ColorPalette.monochrome() : ColorPalette.colorful();

  String get initialRoute => hasCompletedOnboarding.value
      ? (isAuthenticated.value ? '/home' : '/auth')
      : '/onboarding';

  Future<void> init() async {
    final savedLocale = prefs.getString('locale');
    if (savedLocale != null) {
      locale.value = Locale(savedLocale);
    }
    isMonochrome.value = prefs.getBool('isMonochrome') ?? false;
    hasCompletedOnboarding.value =
        prefs.getBool('hasCompletedOnboarding') ?? false;
    isAuthenticated.value = prefs.getBool('isAuthenticated') ?? false;
    favoriteProductIds.addAll(prefs.getStringList('favorites') ?? const []);
    cartProductIds.addAll(prefs.getStringList('cart') ?? const []);

    final ratingsString = prefs.getString('ratings');
    if (ratingsString != null) {
      final parsed = jsonDecode(ratingsString) as Map<String, dynamic>;
      ratings.assignAll(parsed.map(
        (key, value) => MapEntry(key, (value as num).toDouble()),
      ));
    }

    await _initNotifications();
    await refreshProducts();
    _startUsageTimer();
  }

  Future<void> _initNotifications() async {
    if (kIsWeb) {
      return;
    }
    final plugin = FlutterLocalNotificationsPlugin();
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    final darwinSettings = DarwinInitializationSettings();
    final initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
    );
    await plugin.initialize(initSettings);
    notificationsPlugin = plugin;
  }

  Future<void> refreshProducts() async {
    _page = 0;
    hasMoreProducts.value = true;
    products.clear();
    await loadMoreProducts();
  }

  Future<void> loadMoreProducts() async {
    if (isFetching.value || !hasMoreProducts.value) {
      return;
    }
    isFetching.value = true;
    final newItems = await ProductRepository.fetch(
      page: _page,
      pageSize: _pageSize,
    );
    if (newItems.isEmpty) {
      hasMoreProducts.value = false;
    } else {
      products.addAll(newItems);
      _page += 1;
    }
    isFetching.value = false;
  }

  Future<void> toggleTheme() async {
    isMonochrome.toggle();
    await prefs.setBool('isMonochrome', isMonochrome.value);
    recordActivity();
  }

  Future<void> toggleLanguage() async {
    final newLocale = locale.value.languageCode == 'ar'
        ? const Locale('en')
        : const Locale('ar');
    locale.value = newLocale;
    await prefs.setString('locale', newLocale.languageCode);
    Get.updateLocale(newLocale);
    recordActivity();
  }

  Future<void> completeOnboarding() async {
    hasCompletedOnboarding.value = true;
    await prefs.setBool('hasCompletedOnboarding', true);
  }

  Future<void> authenticate(String email, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 420));
    isAuthenticated.value = true;
    await prefs.setBool('isAuthenticated', true);
    recordActivity();
  }

  Future<void> signOut() async {
    isAuthenticated.value = false;
    await prefs.setBool('isAuthenticated', false);
    recordActivity();
    Get.offAllNamed('/auth');
  }

  Future<void> addToFavorites(Product product) async {
    if (favoriteProductIds.contains(product.id)) {
      favoriteProductIds.remove(product.id);
    } else {
      favoriteProductIds.add(product.id);
      await _showAddNotification('favorite', product);
      await _showSuccessCelebration();
    }
    await prefs.setStringList('favorites', favoriteProductIds.toList());
    recordActivity();
  }

  Future<void> addToCart(Product product) async {
    if (cartProductIds.contains(product.id)) {
      cartProductIds.remove(product.id);
    } else {
      cartProductIds.add(product.id);
      await _showAddNotification('cart', product);
      await _showSuccessCelebration();
    }
    await prefs.setStringList('cart', cartProductIds.toList());
    recordActivity();
  }

  Future<void> _showAddNotification(String type, Product product) async {
    final title = type == 'favorite'
        ? 'notification_favorite_title'.trParams(
            {'name': product.localizedName(locale.value)},
          )
        : 'notification_cart_title'.trParams(
            {'name': product.localizedName(locale.value)},
          );
    final body =
        type == 'favorite' ? 'notification_favorite_body'.tr : 'notification_cart_body'.tr;
    if (kIsWeb || notificationsPlugin == null) {
      Get.snackbar(
        title,
        body,
        backgroundColor: palette.surface,
        colorText: palette.textOnSurface,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      );
      return;
    }
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        'quick-actions',
        'Quick Actions',
        channelDescription: 'Quick feedback for cart and favorites',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: const DarwinNotificationDetails(),
      macOS: const DarwinNotificationDetails(),
    );
    await notificationsPlugin!.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
    );
  }

  Future<void> _showSuccessCelebration() async {
    await Get.dialog(
      Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: palette.surface,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 120,
                width: 120,
                child: Lottie.network(
                  'https://lottie.host/ca28f6d2-4dd9-4f27-99b1-5f9c39f2d365/8dB7L1jFJw.json',
                  repeat: false,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'lottie_success_title'.tr,
                style: Get.textTheme.titleLarge?.copyWith(
                  color: palette.textOnSurface,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      barrierColor: Colors.black.withOpacity(0.45),
      barrierDismissible: true,
    );
  }

  double ratingFor(Product product) =>
      ratings[product.id] ?? product.initialRating;

  Future<void> updateRating(Product product, double value) async {
    ratings[product.id] = value;
    await prefs.setString('ratings', jsonEncode(ratings));
    recordActivity();
  }

  void recordActivity() {
    _startUsageTimer();
  }

  void _startUsageTimer() {
    _usageTimer?.cancel();
    _usageTimer = Timer(const Duration(minutes: 30), _showUsageReminder);
  }

  void _showUsageReminder() {
    if (Get.context == null) {
      return;
    }
    Get.snackbar(
      'usage_reminder_title'.tr,
      'usage_reminder_body'.tr,
      backgroundColor: palette.surface,
      colorText: palette.textOnSurface,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(18),
      duration: const Duration(seconds: 6),
    );
    _startUsageTimer();
  }

  @override
  void onClose() {
    _usageTimer?.cancel();
    super.onClose();
  }

  List<FeatureIdea> featureIdeas(Locale locale) => FeatureIdeaRepository.localized(locale);
}

class AppThemeBuilder {
  static ThemeData build({required bool isMonochrome, required Locale locale}) {
    final palette =
        isMonochrome ? ColorPalette.monochrome() : ColorPalette.colorful();
    final base = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: palette.background,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: palette.accent,
        onPrimary: palette.background,
        secondary: palette.highlight,
        onSecondary: palette.textOnSurface,
        error: palette.caution,
        onError: palette.textOnSurface,
        surface: palette.surface,
        onSurface: palette.textOnSurface,
        background: palette.background,
        onBackground: palette.textOnSurface,
      ),
      textTheme: _buildTextTheme(locale, palette),
      appBarTheme: AppBarTheme(
        backgroundColor: palette.background,
        foregroundColor: palette.textOnSurface,
        centerTitle: false,
        elevation: 0,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: palette.navbar,
        selectedItemColor: palette.highlight,
        unselectedItemColor: palette.textOnSurface.withOpacity(0.5),
        type: BottomNavigationBarType.fixed,
      ),
      sliderTheme: SliderThemeData(
        thumbColor: palette.accent,
        activeTrackColor: palette.highlight,
        inactiveTrackColor: palette.textOnSurface.withOpacity(0.2),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: palette.surface,
        contentTextStyle: TextStyle(color: palette.textOnSurface),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          textStyle: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w600),
        ),
      ),
    );
    return base;
  }

  static TextTheme _buildTextTheme(Locale locale, ColorPalette palette) {
    final font = locale.languageCode == 'ar'
        ? GoogleFonts.tajawal()
        : GoogleFonts.spaceGrotesk();
    return TextTheme(
      displayLarge: font.copyWith(
        color: palette.textOnSurface,
        fontWeight: FontWeight.w700,
      ),
      displayMedium: font.copyWith(
        color: palette.textOnSurface,
        fontWeight: FontWeight.w600,
      ),
      displaySmall: font.copyWith(color: palette.textOnSurface),
      headlineLarge: font.copyWith(
        color: palette.textOnSurface,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: font.copyWith(color: palette.textOnSurface),
      headlineSmall: font.copyWith(color: palette.textOnSurface),
      titleLarge: font.copyWith(
        color: palette.textOnSurface,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: font.copyWith(color: palette.textOnSurface),
      titleSmall: font.copyWith(color: palette.textOnSurface),
      bodyLarge: font.copyWith(color: palette.textOnSurface),
      bodyMedium: font.copyWith(color: palette.textOnSurface),
      bodySmall: font.copyWith(color: palette.textOnSurface.withOpacity(0.72)),
      labelLarge: font.copyWith(color: palette.textOnSurface),
      labelMedium: font.copyWith(color: palette.textOnSurface),
      labelSmall: font.copyWith(color: palette.textOnSurface),
    );
  }
}

class ColorPalette {
  const ColorPalette({
    required this.background,
    required this.surface,
    required this.altSurface,
    required this.highlight,
    required this.accent,
    required this.navbar,
    required this.textOnSurface,
    required this.caution,
  });

  final Color background;
  final Color surface;
  final Color altSurface;
  final Color highlight;
  final Color accent;
  final Color navbar;
  final Color textOnSurface;
  final Color caution;

  static ColorPalette colorful() {
    return const ColorPalette(
      background: Color(0xFF8A46FF),
      surface: Color(0xFFCEFF1A),
      altSurface: Color(0xFFFFB347),
      highlight: Color(0xFFFF5C39),
      accent: Color(0xFF171717),
      navbar: Color(0xFF0D0D0D),
      textOnSurface: Color(0xFF0F0F0F),
      caution: Color(0xFFF7567C),
    );
  }

  static ColorPalette monochrome() {
    return const ColorPalette(
      background: Color(0xFFEAEAEA),
      surface: Color(0xFFF9F9F9),
      altSurface: Color(0xFFDDDDDD),
      highlight: Color(0xFF1A1A1A),
      accent: Color(0xFF111111),
      navbar: Color(0xFF1F1F1F),
      textOnSurface: Color(0xFF101010),
      caution: Color(0xFFB00020),
    );
  }
}

class ProductRepository {
  static Future<List<Product>> fetch({
    required int page,
    required int pageSize,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 380));
    final startIndex = page * pageSize;
    final endIndex = startIndex + pageSize;
    final List<Product> items = [];
    for (int i = startIndex; i < endIndex; i++) {
      final template = _seedProducts[i % _seedProducts.length];
      final id = 'product_$i';
      final localizedImages = template.imageUrls
          .map(
            (url) => url.replaceAll(template.id, id),
          )
          .toList();
      items.add(
        template.copyWith(
          id: id,
          heroTag: 'hero_$id',
          nameEn: '${template.nameEn} ${i + 1}',
          nameAr: '${template.nameAr} ${i + 1}',
          price: template.price + (i % 4) * 3.75,
          descriptionEn:
              '${template.descriptionEn}\nGeneration ${(i % 4) + 1}.',
          descriptionAr:
              '${template.descriptionAr}\nالجيل ${(i % 4) + 1}.',
          imageUrls: localizedImages,
        ),
      );
    }
    return items;
  }

  static final List<Product> _seedProducts = [
    Product(
      id: 'seed_1',
      heroTag: 'hero_seed_1',
      nameEn: 'Neon Delivery Capsule',
      nameAr: 'كبسولة التوصيل النيونية',
      descriptionEn: 'A modular storage pod with holographic tracking.',
      descriptionAr: 'وحدة تخزين معيارية مع تتبع هولوجرافي.',
      price: 123.0,
      featuresEn: [
        'Magnetic smart lid',
        'Eco-charge battery',
        'Pair with neon scooter',
      ],
      featuresAr: [
        'غطاء ذكي مغناطيسي',
        'بطارية بشحن صديق للبيئة',
        'اقتران مع السكوتر النيون',
      ],
      imageUrls: const [
        'https://picsum.photos/seed/seed_1/720/720',
        'https://picsum.photos/seed/seed_1_b/720/720',
        'https://picsum.photos/seed/seed_1_c/720/720',
      ],
      initialRating: 4.3,
      accentColor: const Color(0xFFCEFF1A),
    ),
    Product(
      id: 'seed_2',
      heroTag: 'hero_seed_2',
      nameEn: 'Pulse Courier Dock',
      nameAr: 'حامل النبض السريع',
      descriptionEn: 'Vibrant dock station for urban couriers.',
      descriptionAr: 'محطة شحن نابضة لمرسلي المدن.',
      price: 129.0,
      featuresEn: [
        'Soft-touch grip',
        'Solar assist roof',
        'Optimized quick slots',
      ],
      featuresAr: [
        'قبضة ناعمة',
        'سطح مساعد بالطاقة الشمسية',
        'فتحات سريعة محسّنة',
      ],
      imageUrls: const [
        'https://picsum.photos/seed/seed_2/720/720',
        'https://picsum.photos/seed/seed_2_b/720/720',
        'https://picsum.photos/seed/seed_2_c/720/720',
      ],
      initialRating: 4.1,
      accentColor: const Color(0xFFFFB347),
    ),
    Product(
      id: 'seed_3',
      heroTag: 'hero_seed_3',
      nameEn: 'Vivid Transit Crate',
      nameAr: 'صندوق العبور النابض',
      descriptionEn: 'Pop-art crate with social commerce overlay.',
      descriptionAr: 'صندوق بأسلوب فن البوب مع طبقة تواصل اجتماعي.',
      price: 117.0,
      featuresEn: [
        'Shared playlist zone',
        'Tap-to-pay module',
        'Removable chat bubbles',
      ],
      featuresAr: [
        'منطقة قوائم تشغيل مشتركة',
        'وحدة دفع باللمس',
        'فقاعات محادثة قابلة للإزالة',
      ],
      imageUrls: const [
        'https://picsum.photos/seed/seed_3/720/720',
        'https://picsum.photos/seed/seed_3_b/720/720',
        'https://picsum.photos/seed/seed_3_c/720/720',
      ],
      initialRating: 4.6,
      accentColor: const Color(0xFFFF5C39),
    ),
    Product(
      id: 'seed_4',
      heroTag: 'hero_seed_4',
      nameEn: 'Flux Market Pod',
      nameAr: 'وحدة السوق المتدفقة',
      descriptionEn: 'Compact retail pod with adaptive branding layers.',
      descriptionAr: 'وحدة بيع مدمجة مع طبقات علامة تجارية متكيفة.',
      price: 133.0,
      featuresEn: [
        'Dynamic neon edges',
        'Integrated chat AI',
        'Gesture-based unlock',
      ],
      featuresAr: [
        'حواف نيون متحركة',
        'ذكاء اصطناعي للمحادثة مدمج',
        'فتح بالإيماءات',
      ],
      imageUrls: const [
        'https://picsum.photos/seed/seed_4/720/720',
        'https://picsum.photos/seed/seed_4_b/720/720',
        'https://picsum.photos/seed/seed_4_c/720/720',
      ],
      initialRating: 4.0,
      accentColor: const Color(0xFFCEFF1A),
    ),
  ];
}

class Product {
  const Product({
    required this.id,
    required this.heroTag,
    required this.nameEn,
    required this.nameAr,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.price,
    required this.featuresEn,
    required this.featuresAr,
    required this.imageUrls,
    required this.initialRating,
    required this.accentColor,
  });

  final String id;
  final String heroTag;
  final String nameEn;
  final String nameAr;
  final String descriptionEn;
  final String descriptionAr;
  final double price;
  final List<String> featuresEn;
  final List<String> featuresAr;
  final List<String> imageUrls;
  final double initialRating;
  final Color accentColor;

  String localizedName(Locale locale) =>
      locale.languageCode == 'ar' ? nameAr : nameEn;

  String localizedDescription(Locale locale) =>
      locale.languageCode == 'ar' ? descriptionAr : descriptionEn;

  List<String> localizedFeatures(Locale locale) =>
      locale.languageCode == 'ar' ? featuresAr : featuresEn;

  Product copyWith({
    String? id,
    String? heroTag,
    String? nameEn,
    String? nameAr,
    String? descriptionEn,
    String? descriptionAr,
    double? price,
    List<String>? featuresEn,
    List<String>? featuresAr,
    List<String>? imageUrls,
    double? initialRating,
    Color? accentColor,
  }) {
    return Product(
      id: id ?? this.id,
      heroTag: heroTag ?? this.heroTag,
      nameEn: nameEn ?? this.nameEn,
      nameAr: nameAr ?? this.nameAr,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      price: price ?? this.price,
      featuresEn: featuresEn ?? this.featuresEn,
      featuresAr: featuresAr ?? this.featuresAr,
      imageUrls: imageUrls ?? this.imageUrls,
      initialRating: initialRating ?? this.initialRating,
      accentColor: accentColor ?? this.accentColor,
    );
  }
}

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': {
          'onboarding_title_1': 'Hyper-custom delivery',
          'onboarding_sub_1':
              'Crafted for couriers and creators. Modular pods ready for neon adventures.',
          'onboarding_title_2': 'Playful social commerce',
          'onboarding_sub_2':
              'Flip, chat, and share every product story with live reactions.',
          'onboarding_title_3': 'Dual language. Dual theme.',
          'onboarding_sub_3':
              'Switch between Arabic & English plus vivid or monochrome palettes.',
          'onboarding_start': 'Start the experience',
          'onboarding_next': 'Next',
          'auth_title': 'Sign in to continue',
          'auth_email': 'Email',
          'auth_password': 'Password',
          'auth_sign_in': 'Sign in',
          'auth_skip': 'Continue as guest',
          'home_greeting': 'Hi Max',
          'search_hint': 'Search neon parcels...',
          'category_featured': 'Featured drops',
          'category_live': 'Live now',
          'category_saved': 'Saved pods',
          'shop_title': 'Shop',
          'add_to_cart': 'Add to cart',
          'add_to_favorites': 'Add to favorites',
          'detail_features': 'Highlights',
          'detail_rating': 'Your rating',
          'detail_description': 'Description',
          'community_title': 'Store name',
          'community_subtitle': 'Futuristic upgrade backlog',
          'notification_favorite_title': 'Favorite: @name',
          'notification_favorite_body': 'Saved to your neon wishlist.',
          'notification_cart_title': 'Cart: @name',
          'notification_cart_body': 'Added to your fast cart.',
          'lottie_success_title': 'Saved with style!',
          'usage_reminder_title': 'Time for a breather',
          'usage_reminder_body':
              'You have been exploring for 30 minutes. Stretch and hydrate.',
          'toggle_theme': 'Theme',
          'toggle_language': 'ع',
          'nav_home': 'Home',
          'nav_shop': 'Shop',
          'nav_updates': 'Updates',
          'empty_features': 'More upgrades incoming soon.',
          'rating_label': 'Adjust rating',
          'price_label': 'Price',
          'logout': 'Sign out',
          'refresh': 'Refresh',
        },
        'ar': {
          'onboarding_title_1': 'توصيل فائق التخصيص',
          'onboarding_sub_1':
              'مصمم للمرسلين والمبدعين. كبسولات معيارية جاهزة لمغامرات النيون.',
          'onboarding_title_2': 'تجارة اجتماعية مرحة',
          'onboarding_sub_2':
              'اقلب وتحدث وشارك قصة كل منتج مع تفاعلات مباشرة.',
          'onboarding_title_3': 'لغتان وثيمان',
          'onboarding_sub_3':
              'بدّل بين العربية والإنجليزية مع لوحة ألوان زاهية أو أحادية.',
          'onboarding_start': 'ابدأ التجربة',
          'onboarding_next': 'التالي',
          'auth_title': 'سجّل الدخول للمتابعة',
          'auth_email': 'البريد الإلكتروني',
          'auth_password': 'كلمة المرور',
          'auth_sign_in': 'تسجيل الدخول',
          'auth_skip': 'المتابعة كضيف',
          'home_greeting': 'أهلاً ماكس',
          'search_hint': 'ابحث عن الطرود النيونية...',
          'category_featured': 'إصدارات مميزة',
          'category_live': 'يحدث الآن',
          'category_saved': 'الكبسولات المحفوظة',
          'shop_title': 'المتجر',
          'add_to_cart': 'أضف إلى السلة',
          'add_to_favorites': 'أضف إلى المفضلة',
          'detail_features': 'أهم المزايا',
          'detail_rating': 'تقييمك',
          'detail_description': 'الوصف',
          'community_title': 'اسم المتجر',
          'community_subtitle': 'قائمة الترقيات المستقبلية',
          'notification_favorite_title': 'مفضل: @name',
          'notification_favorite_body': 'تم الحفظ في قائمة النيون.',
          'notification_cart_title': 'السلة: @name',
          'notification_cart_body': 'تمت الإضافة إلى سلتك السريعة.',
          'lottie_success_title': 'تم الحفظ بإبداع!',
          'usage_reminder_title': 'حان وقت الاستراحة',
          'usage_reminder_body':
              'استكشفت التطبيق لمدة 30 دقيقة. تمطّع واشرب الماء.',
          'toggle_theme': 'الثيم',
          'toggle_language': 'EN',
          'nav_home': 'الرئيسية',
          'nav_shop': 'المتجر',
          'nav_updates': 'التحديثات',
          'empty_features': 'ترقيات إضافية قادمة قريباً.',
          'rating_label': 'عدّل التقييم',
          'price_label': 'السعر',
          'logout': 'تسجيل خروج',
          'refresh': 'تحديث',
        },
      };
}

class OnboardingPackage extends StatefulWidget {
  const OnboardingPackage({super.key});

  @override
  State<OnboardingPackage> createState() => _OnboardingPackageState();
}

class _OnboardingPackageState extends State<OnboardingPackage> {
  final PageController _pageController = PageController();
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AppController>();
    final palette = controller.palette;
    final slides = _slides(context.locale);
    return Scaffold(
      backgroundColor: palette.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: slides.length,
                onPageChanged: (value) {
                  setState(() => _index = value);
                },
                itemBuilder: (context, index) {
                  final slide = slides[index];
                  return Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Center(
                            child: CrouselView(
                              height: 320,
                              autoPlay: true,
                              images: slide.illustrations,
                              palette: palette,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          slide.title,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          slide.subtitle,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                color:
                                    palette.textOnSurface.withOpacity(0.76),
                              ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                slides.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  width: _index == i ? 32 : 12,
                  decoration: BoxDecoration(
                    color: _index == i
                        ? palette.highlight
                        : palette.textOnSurface.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
              child: Row(
                children: [
                  if (_index < slides.length - 1)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 320),
                            curve: Curves.easeOutCubic,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: palette.altSurface,
                          foregroundColor: palette.textOnSurface,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: Text('onboarding_next'.tr),
                      ),
                    )
                  else
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          await controller.completeOnboarding();
                          if (controller.isAuthenticated.value) {
                            Get.offAllNamed('/home');
                          } else {
                            Get.offAllNamed('/auth');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: palette.highlight,
                          foregroundColor: palette.textOnSurface,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text('onboarding_start'.tr),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<_OnboardingSlide> _slides(Locale locale) {
    return [
      _OnboardingSlide(
        title: 'onboarding_title_1'.tr,
        subtitle: 'onboarding_sub_1'.tr,
        illustrations: _illustrations('capsule'),
      ),
      _OnboardingSlide(
        title: 'onboarding_title_2'.tr,
        subtitle: 'onboarding_sub_2'.tr,
        illustrations: _illustrations('chat'),
      ),
      _OnboardingSlide(
        title: 'onboarding_title_3'.tr,
        subtitle: 'onboarding_sub_3'.tr,
        illustrations: _illustrations('duo'),
      ),
    ];
  }

  List<String> _illustrations(String seed) => [
        'https://picsum.photos/seed/${seed}_1/680/460',
        'https://picsum.photos/seed/${seed}_2/680/460',
        'https://picsum.photos/seed/${seed}_3/680/460',
      ];
}

class _OnboardingSlide {
  const _OnboardingSlide({
    required this.title,
    required this.subtitle,
    required this.illustrations,
  });

  final String title;
  final String subtitle;
  final List<String> illustrations;
}

class AuthPackage extends StatefulWidget {
  const AuthPackage({super.key});

  @override
  State<AuthPackage> createState() => _AuthPackageState();
}

class _AuthPackageState extends State<AuthPackage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AppController>();
    final palette = controller.palette;
    return Scaffold(
      backgroundColor: palette.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'auth_title'.tr,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 32),
                    _AuthField(
                      controller: _emailController,
                      label: 'auth_email'.tr,
                      palette: palette,
                      validator: (value) => (value == null || value.isEmpty)
                          ? 'auth_email'.tr
                          : null,
                    ),
                    const SizedBox(height: 18),
                    _AuthField(
                      controller: _passwordController,
                      label: 'auth_password'.tr,
                      palette: palette,
                      obscureText: true,
                      validator: (value) => (value == null || value.length < 4)
                          ? 'auth_password'.tr
                          : null,
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isSubmitting
                            ? null
                            : () async {
                                if (_formKey.currentState?.validate() ?? false) {
                                  setState(() => _isSubmitting = true);
                                  await controller.authenticate(
                                    _emailController.text,
                                    _passwordController.text,
                                  );
                                  setState(() => _isSubmitting = false);
                                  Get.offAllNamed('/home');
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: palette.highlight,
                          foregroundColor: palette.textOnSurface,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: _isSubmitting
                            ? CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(
                                  palette.textOnSurface,
                                ),
                              )
                            : Text('auth_sign_in'.tr),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        Get.offAllNamed('/home');
                      },
                      child: Text(
                        'auth_skip'.tr,
                        style: TextStyle(
                          color: palette.textOnSurface.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

class _AuthField extends StatelessWidget {
  const _AuthField({
    required this.controller,
    required this.label,
    required this.palette,
    this.obscureText = false,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final ColorPalette palette;
  final bool obscureText;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: palette.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AppController>();
    final palette = controller.palette;
    return Obx(
      () => Scaffold(
        backgroundColor: palette.background,
        appBar: AppBar(
          title: Text('home_greeting'.tr),
          actions: [
            IconButton(
              onPressed: controller.toggleTheme,
              icon: const Icon(Icons.invert_colors),
              tooltip: 'toggle_theme'.tr,
            ),
            IconButton(
              onPressed: controller.toggleLanguage,
              icon: const Icon(Icons.translate),
              tooltip: 'toggle_language'.tr,
            ),
            IconButton(
              onPressed: controller.signOut,
              icon: const Icon(Icons.logout),
              tooltip: 'logout'.tr,
            ),
          ],
        ),
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            controller.navIndex.value = index;
            controller.recordActivity();
          },
          children: const [
            HighlightsPage(),
            ShopPage(),
            CommunityPage(),
          ],
        ),
        bottomNavigationBar: _BottomNavBar(
          controller: controller,
          onTap: (index) {
            controller.navIndex.value = index;
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
            controller.recordActivity();
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({
    required this.controller,
    required this.onTap,
  });

  final AppController controller;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final palette = controller.palette;
    final items = [
      _BottomNavItemData(Icons.home_filled, 'nav_home'.tr),
      _BottomNavItemData(Icons.storefront, 'nav_shop'.tr),
      _BottomNavItemData(Icons.bolt, 'nav_updates'.tr),
    ];
    return Container(
      decoration: BoxDecoration(
        color: palette.navbar,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(items.length, (index) {
          final isActive = controller.navIndex.value == index;
          final data = items[index];
          return GestureDetector(
            onTap: () => onTap(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 260),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isActive
                    ? palette.highlight.withOpacity(0.9)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Icon(
                    data.icon,
                    color: isActive
                        ? palette.textOnSurface
                        : palette.textOnSurface.withOpacity(0.6),
                  ),
                  if (isActive) ...[
                    const SizedBox(width: 8),
                    Text(
                      data.label,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: palette.textOnSurface,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _BottomNavItemData {
  const _BottomNavItemData(this.icon, this.label);
  final IconData icon;
  final String label;
}

class HighlightsPage extends GetView<AppController> {
  const HighlightsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = controller.palette;
    final locale = controller.locale.value;
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 720;
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isWide ? constraints.maxWidth * 0.1 : 24,
            vertical: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                decoration: BoxDecoration(
                  color: palette.surface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'search_hint'.tr,
                    border: InputBorder.none,
                    icon: Icon(Icons.search, color: palette.textOnSurface),
                  ),
                  onTap: controller.recordActivity,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'category_featured'.tr,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 16),
              Obx(
                () => controller.products.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 48),
                          child: CircularProgressIndicator(
                            color: palette.accent,
                          ),
                        ),
                      )
                    : CrouselView(
                        height: isWide ? 360 : 280,
                        autoPlay: true,
                        images: controller.products
                            .take(5)
                            .map(
                              (product) => product.imageUrls.first,
                            )
                            .toList(),
                        palette: palette,
                        onImageTap: (index) {
                          final product = controller.products[index];
                          Get.toNamed('/detail', arguments: product);
                        },
                      ),
              ),
              const SizedBox(height: 32),
              Text(
                'category_live'.tr,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 16),
              Obx(
                () => Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: controller.products
                      .take(4)
                      .map(
                        (product) => _FeaturedCard(
                          product: product,
                          palette: palette,
                          locale: locale,
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  const _FeaturedCard({
    required this.product,
    required this.palette,
    required this.locale,
  });

  final Product product;
  final ColorPalette palette;
  final Locale locale;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      child: GestureDetector(
        onTap: () => Get.toNamed('/detail', arguments: product),
        child: FlipCard(
          front: Container(
            decoration: BoxDecoration(
              color: product.accentColor,
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Hero(
                    tag: product.heroTag,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.network(
                        product.imageUrls.first,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  product.localizedName(locale),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${'price_label'.tr}: \$${product.price.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          back: Container(
            decoration: BoxDecoration(
              color: palette.altSurface,
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.localizedName(locale),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ...product
                    .localizedFeatures(locale)
                    .take(3)
                    .map(
                      (feature) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Icon(Icons.check_circle,
                                color: palette.highlight, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                feature,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ],
            ),
          ),
        )
            .animate()
            .fadeIn(duration: const Duration(milliseconds: 520))
            .slideY(begin: 0.1, end: 0),
      ),
    );
  }
}

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    final controller = Get.find<AppController>();
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      controller.loadMoreProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AppController>();
    final palette = controller.palette;
    final locale = controller.locale.value;
    return RefreshIndicator(
      color: palette.highlight,
      backgroundColor: palette.surface,
      onRefresh: controller.refreshProducts,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = constraints.maxWidth > 1100
              ? 4
              : constraints.maxWidth > 720
                  ? 3
                  : 1;
          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: crossAxisCount == 1 ? 24 : 48,
                  vertical: 24,
                ),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    'shop_title'.tr,
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              Obx(
                () => SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: crossAxisCount == 1 ? 24 : 48,
                  ),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final product = controller.products[index];
                        return _ShopCard(
                          product: product,
                          palette: palette,
                          locale: locale,
                        );
                      },
                      childCount: controller.products.length,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 24,
                      crossAxisSpacing: 24,
                      childAspectRatio: 0.72,
                    ),
                  ),
                ),
              ),
              Obx(
                () => SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Column(
                      children: [
                        if (controller.isFetching.value)
                          CircularProgressIndicator(
                            color: palette.accent,
                          ),
                        if (!controller.isFetching.value &&
                            controller.hasMoreProducts.value)
                          ElevatedButton(
                            onPressed: controller.loadMoreProducts,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: palette.altSurface,
                              foregroundColor: palette.textOnSurface,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                            ),
                            child: Text('refresh'.tr),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class _ShopCard extends StatelessWidget {
  const _ShopCard({
    required this.product,
    required this.palette,
    required this.locale,
  });

  final Product product;
  final ColorPalette palette;
  final Locale locale;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AppController>();
    final isFavorite = controller.favoriteProductIds.contains(product.id);
    final isInCart = controller.cartProductIds.contains(product.id);
    return GestureDetector(
      onTap: () => Get.toNamed('/detail', arguments: product),
      child: FlipCard(
        front: Container(
          decoration: BoxDecoration(
            color: product.accentColor,
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Hero(
                  tag: product.heroTag,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.network(
                      product.imageUrls.first,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                product.localizedName(locale),
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  IconButton(
                    onPressed: () => controller.addToFavorites(product),
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite
                          ? palette.highlight
                          : palette.textOnSurface,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        back: Container(
          decoration: BoxDecoration(
            color: palette.surface,
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.localizedDescription(locale),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(height: 1.3),
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => controller.addToCart(product),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: palette.highlight,
                        foregroundColor: palette.textOnSurface,
                      ),
                      child: Text(
                        isInCart ? 'add_to_cart'.tr : 'add_to_cart'.tr,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )
          .animate()
          .fadeIn(duration: const Duration(milliseconds: 420))
          .moveY(begin: 24, end: 0, curve: Curves.easeOutCubic),
    );
  }
}

class CommunityPage extends GetView<AppController> {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = controller.palette;
    final suggestions = controller.featureIdeas(controller.locale.value);
    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontal = constraints.maxWidth > 900
            ? constraints.maxWidth * 0.2
            : 24.0;
        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(horizontal, 24, horizontal, 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: palette.altSurface,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'community_title'.tr,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'community_subtitle'.tr,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: palette.textOnSurface.withOpacity(0.8)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ...suggestions.map(
                (idea) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: palette.surface,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 42,
                        width: 42,
                        decoration: BoxDecoration(
                          color: palette.highlight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          idea.order.toString().padLeft(2, '0'),
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(
                                color: palette.textOnSurface,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          idea.description,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ProductDetailPage extends GetView<AppController> {
  const ProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final product = Get.arguments as Product;
    final palette = controller.palette;
    final locale = controller.locale.value;
    return Scaffold(
      backgroundColor: palette.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: product.heroTag,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: CrouselView(
                  height: 320,
                  autoPlay: true,
                  images: product.imageUrls,
                  palette: palette,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              product.localizedName(locale),
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            Text(
              '${'price_label'.tr}: \$${product.price.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'detail_description'.tr,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              product.localizedDescription(locale),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            Text(
              'detail_features'.tr,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...product.localizedFeatures(locale).map(
                  (feature) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Icon(Icons.star, color: palette.highlight, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            feature,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            const SizedBox(height: 24),
            Text(
              'detail_rating'.tr,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Obx(
              () => Row(
                children: [
                  Expanded(
                    child: Slider(
                      value: controller.ratingFor(product),
                      onChanged: (value) {
                        controller.updateRating(product, value);
                      },
                      min: 1,
                      max: 5,
                      divisions: 8,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    controller.ratingFor(product).toStringAsFixed(1),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => controller.addToCart(product),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: palette.highlight,
                      foregroundColor: palette.textOnSurface,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    icon: const Icon(Icons.shopping_bag),
                    label: Text('add_to_cart'.tr),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () => controller.addToFavorites(product),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: palette.altSurface,
                    foregroundColor: palette.textOnSurface,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  ),
                  child: const Icon(Icons.favorite),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CrouselView extends StatefulWidget {
  const CrouselView({
    super.key,
    required this.images,
    required this.palette,
    this.height = 240,
    this.autoPlay = false,
    this.onImageTap,
  });

  final List<String> images;
  final ColorPalette palette;
  final double height;
  final bool autoPlay;
  final ValueChanged<int>? onImageTap;

  @override
  State<CrouselView> createState() => _CrouselViewState();
}

class _CrouselViewState extends State<CrouselView> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CarouselSlider.builder(
          itemCount: widget.images.length,
          options: CarouselOptions(
            height: widget.height,
            autoPlay: widget.autoPlay,
            enlargeCenterPage: true,
            viewportFraction: 0.82,
            onPageChanged: (index, reason) {
              setState(() => _current = index);
            },
          ),
          itemBuilder: (context, index, realIndex) {
            final image = widget.images[index];
            return GestureDetector(
              onTap: widget.onImageTap == null
                  ? null
                  : () => widget.onImageTap!(index),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.network(
                  image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 6,
          children: List.generate(widget.images.length, (index) {
            final isActive = _current == index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 260),
              height: 10,
              width: isActive ? 28 : 12,
              decoration: BoxDecoration(
                color: isActive
                    ? widget.palette.highlight
                    : widget.palette.textOnSurface.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class FeatureIdea {
  const FeatureIdea({required this.order, required this.description});

  final int order;
  final String description;
}

class FeatureIdeaRepository {
  static List<FeatureIdea> localized(Locale locale) {
    final isArabic = locale.languageCode == 'ar';
    final List<String> en = [
      'Voice-controlled packing assistant',
      'Dynamic AR overlays for each box',
      'Predictive stock reminders',
      'Offline-first mode with sync queue',
      'Smart packing suggestions with AI',
      'Delivery route heat-map',
      'Collaborative wishlist boards',
      'Story mode for unboxing experience',
      'Customizable sound themes',
      'Real-time co-shopping sessions',
      'In-app tutorial studio',
      'Generative label designer',
      '360-degree product viewer',
      'Gesture navigation shortcuts',
      'Widget for tracking parcels',
      'Mini games while loading data',
      'Timeline view for price history',
      'Context-aware chatbot helper',
      'Inventory forecast timeline',
      'Quick scan via QR integration',
      'Social badges for curators',
      'Bulk edit mode for sellers',
      'Offline barcode generator',
      'AI-powered copywriting hints',
      'Live analytics for campaigns',
      'Split-screen comparison mode',
      'Exportable shopping journal',
      'Smart home integration hooks',
      'Multi-user presentation mode',
      'In-app design marketplace',
    ];

    final List<String> ar = [
      'مساعد تغليف بالصوت',
      'طبقات واقع معزز لكل صندوق',
      'تذكيرات ذكية بالمخزون',
      'وضع يعمل دون اتصال مع طابور مزامنة',
      'اقتراحات تعبئة ذكية بالذكاء الاصطناعي',
      'خريطة حرارية لمسار التوصيل',
      'لوحات أمنيات تعاونية',
      'وضع قصص لتجربة فتح الصندوق',
      'ثيمات صوتية قابلة للتخصيص',
      'جلسات تسوق مباشرة مشتركة',
      'استوديو شروحات داخل التطبيق',
      'مصمم بطاقات يولّدها الذكاء الاصطناعي',
      'عارض منتجات بزاوية ٣٦٠ درجة',
      'اختصارات تنقل بالإيماءات',
      'ويدجت لتتبع الطرود',
      'ألعاب صغيرة أثناء تحميل البيانات',
      'عرض زمني لتاريخ الأسعار',
      'مساعد ذكي حسب السياق',
      'مخطط توقعات للمخزون',
      'مسح سريع عبر دمج QR',
      'شارات اجتماعية للمنسقين',
      'وضع تحرير جماعي للبائعين',
      'مولّد باركود بدون اتصال',
      'اقتراحات كتابة تسويقية بالذكاء الاصطناعي',
      'تحليلات مباشرة للحملات',
      'وضع مقارنة بشاشتين',
      'مفكرة مشتريات قابلة للتصدير',
      'تكامل مع المنازل الذكية',
      'وضع عرض جماعي متعدد المستخدمين',
      'سوق تصميم داخل التطبيق',
    ];

    final source = isArabic ? ar : en;
    return List.generate(source.length, (index) {
      return FeatureIdea(order: index + 1, description: source[index]);
    });
  }
}
