import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import 'core/bindings/initial_binding.dart';
import 'core/services/feature_service.dart';
import 'core/services/settings_service.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_pages.dart';
import 'translations/app_translations.dart';

class MindMirrorApp extends StatelessWidget {
  const MindMirrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Get.find<SettingsService>();
    final features = Get.find<FeatureService>();
    return Obx(() {
      final toggles = features.toggles;
      final highContrast = toggles['high_contrast'] ?? false;
      final sleepMode = toggles['sleep_mode'] ?? false;
      return GetMaterialApp(
        title: 'Mind Mirror',
        debugShowCheckedModeBanner: false,
        defaultTransition: Transition.fadeIn,
        translations: AppTranslations(),
        locale: settings.locale,
        fallbackLocale: AppTranslations.fallbackLocale,
        supportedLocales: AppTranslations.supportedLocales,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: AppTheme.light(highContrast: highContrast),
        darkTheme: AppTheme.dark(highContrast: highContrast, sleepMode: sleepMode),
        themeMode: settings.themeMode,
        initialRoute: AppPages.initial,
        getPages: AppPages.routes,
        initialBinding: InitialBinding(),
        builder: (context, child) {
          final textScale = MediaQuery.of(context).textScaleFactor.clamp(1.0, toggles['data_control'] == true ? 1.0 : 1.2);
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: textScale),
            child: child ?? const SizedBox.shrink(),
          );
        },
      );
    });
  }
}
