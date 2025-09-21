/*
README - Green Auction App (Flutter + GetX)
=========================================
1. Install Flutter 3.19+ and run `flutter pub get`.
2. Run on devices:
   - Android/iOS: `flutter run` (select device or emulator).
   - Web (Instagram optimized): `flutter run -d chrome --web-renderer html`.
3. Build release web:
   - `flutter build web --web-renderer html --release`
4. Build mobile release:
   - `flutter build apk --release` / `flutter build ios --release`
5. Mock data lives in assets/mock/*.json and assets/i18n for translations.
6. All state management, routing, and localization is powered by GetX.
7. Firebase / TensorFlow integrations are documented via TODO comments inside the relevant services and controllers.
*/

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'core/bindings/global_bindings.dart';
import 'core/routing/app_pages.dart';
import 'core/routing/app_routes.dart';
import 'core/theme/green_theme.dart';
import 'core/translations/app_translations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  final storage = GetStorage();
  final storedLocale = storage.read<String>('locale');
  final deviceLocale = Get.deviceLocale ?? const Locale('en');
  final Locale initialLocale;
  if (storedLocale != null) {
    initialLocale = Locale(storedLocale);
  } else {
    initialLocale = deviceLocale.languageCode == 'ar'
        ? const Locale('ar')
        : const Locale('en');
  }
  final initialRoute = storage.read<bool>('onboarding_complete') == true
      ? AppRoutes.home
      : AppRoutes.onboarding;

  // BUILD WEB: flutter build web --web-renderer html --release
  runApp(
    GreenAuctionApp(
      initialLocale: initialLocale,
      initialRoute: initialRoute,
    ),
  );
}

class GreenAuctionApp extends StatelessWidget {
  const GreenAuctionApp({
    super.key,
    required this.initialLocale,
    required this.initialRoute,
  });

  final Locale initialLocale;
  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Green Auction',
      translations: AppTranslations(),
      locale: initialLocale,
      fallbackLocale: const Locale('en'),
      supportedLocales: const [Locale('en'), Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: GreenTheme.light,
      darkTheme: GreenTheme.dark,
      themeMode: ThemeMode.system,
      initialRoute: initialRoute,
      getPages: AppPages.routes,
      initialBinding: GlobalBindings(),
      defaultTransition: Transition.cupertino,
    );
  }
}
