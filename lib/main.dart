/*
README - Trend Electronics Store (Flutter GetX)
================================================
1. Install Flutter 3.19+ and run `flutter pub get`.
2. Run locally:
   - Mobile: `flutter run` (select device).
   - Web (Instagram optimized): `flutter run -d chrome --web-renderer html`.
3. Build release web:
   - `flutter build web --web-renderer html --release`
4. Build mobile release: standard `flutter build apk` / `flutter build ios`.
5. Mock data lives in assets/mock/*.json. Update freely.
6. Localization is handled via GetX translations in lib/core/translations/app_translations.dart.
7. Services and controllers are wired via GlobalBindings (GetX dependency injection).
8. Firebase / TensorFlow Lite integrations are stubbed with TODO comments in related services and controllers.
*/

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'core/bindings/global_bindings.dart';
import 'core/routing/app_pages.dart';
import 'core/routing/app_routes.dart';
import 'core/theme/glass_theme.dart';
import 'core/translations/app_translations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  final storage = GetStorage();
  final storedLocale = storage.read<String>('locale');
  final deviceLocale = Get.deviceLocale ?? const Locale('en');
  final locale = storedLocale != null
      ? Locale(storedLocale)
      : deviceLocale.languageCode == 'ar'
          ? const Locale('ar')
          : const Locale('en');
  final initialRoute = storage.read<bool>('onboarded') == true
      ? AppRoutes.home
      : AppRoutes.onboarding;

  // For Flutter web inside Instagram WebView ensure HTML renderer.
  // Build tip (release): flutter build web --web-renderer html --release
  runZonedGuarded(
    () => runApp(TrendElectronicsApp(
      initialLocale: locale,
      initialRoute: initialRoute,
    )),
    (error, stack) {
      if (kDebugMode) {
        debugPrint('Unhandled error: $error');
      }
    },
  );
}

class TrendElectronicsApp extends StatelessWidget {
  const TrendElectronicsApp({
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
      title: 'Trend Electronics',
      translations: AppTranslations(),
      locale: initialLocale,
      fallbackLocale: const Locale('en'),
      supportedLocales: const [Locale('en'), Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: GlassTheme.light,
      darkTheme: GlassTheme.dark,
      themeMode: ThemeMode.system,
      defaultTransition: Transition.cupertino,
      initialRoute: initialRoute,
      getPages: AppPages.routes,
      initialBinding: GlobalBindings(),
      routingCallback: (routing) {
        if (kDebugMode && routing?.current != null) {
          debugPrint('Navigated to: ${routing!.current}');
        }
      },
    );
  }
}
