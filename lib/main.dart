import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'core/bindings/global_bindings.dart';
import 'core/routing/app_pages.dart';
import 'core/routing/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'core/translations/app_translations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await _maybeInitFirebase();
  await AppTranslations.ensureInitialized();

  final storage = GetStorage();
  final storedLocale = storage.read<String>('locale');
  final onboardingComplete = storage.read<bool>('onboarding_complete') ?? false;
  final Locale initialLocale = storedLocale != null
      ? Locale(storedLocale)
      : (Get.deviceLocale?.languageCode == 'ar'
          ? const Locale('ar')
          : const Locale('en'));
  final initialRoute = storedLocale == null
      ? AppRoutes.language
      : (onboardingComplete ? AppRoutes.home : AppRoutes.onboarding);

  runApp(GlassAuctionApp(
    initialLocale: initialLocale,
    initialRoute: initialRoute,
  ));
}

Future<void> _maybeInitFirebase() async {
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase not initialised. Run flutterfire configure to connect. Error: $e');
  }
}

class GlassAuctionApp extends StatelessWidget {
  const GlassAuctionApp({
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
      title: 'app_name'.tr,
      translations: AppTranslations(),
      locale: initialLocale,
      fallbackLocale: const Locale('en'),
      supportedLocales: const [Locale('en'), Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      initialRoute: initialRoute,
      getPages: AppPages.routes,
      initialBinding: GlobalBindings(),
      defaultTransition: Transition.cupertino,
    );
  }
}
