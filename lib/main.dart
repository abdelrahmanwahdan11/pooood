import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import 'core/localization/translations.dart';
import 'core/routing/app_pages.dart';
import 'core/routing/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'data/db/app_db.dart';
import 'data/repositories/settings_repo.dart';
import 'data/repositories/watch_store_repo.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = await AppDatabase.instance.init();
  final settingsRepository = SettingsRepository(database: database);
  await settingsRepository.loadPreferences();

  runApp(LiquidBidApp(
    settingsRepository: settingsRepository,
  ));
}

class LiquidBidApp extends StatelessWidget {
  const LiquidBidApp({super.key, required this.settingsRepository});

  final SettingsRepository settingsRepository;

  @override
  Widget build(BuildContext context) {
    final locale = settingsRepository.currentLocale;
    final initialRoute = settingsRepository.hasCompletedOnboarding
        ? (settingsRepository.authToken != null || settingsRepository.isGuestMode
            ? AppRoutes.shell
            : AppRoutes.auth)
        : AppRoutes.onboarding;
    return GetMaterialApp(
      title: 'LiquidBid',
      translations: LiquidBidTranslations(),
      locale: locale,
      fallbackLocale: const Locale('en'),
      initialBinding: BindingsBuilder(() {
        if (!Get.isRegistered<SettingsRepository>()) {
          Get.put<SettingsRepository>(settingsRepository, permanent: true);
        }
        if (!Get.isRegistered<WatchStoreRepository>()) {
          Get.put(WatchStoreRepository(settingsRepository), permanent: true);
        }
      }),
      initialRoute: initialRoute,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.buildThemeData(settingsRepository),
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 240),
      smartManagement: SmartManagement.onlyBuilder,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ar'), Locale('en')],
    );
  }
}
