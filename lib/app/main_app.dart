import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import 'core/bindings/initial_binding.dart';
import 'core/services/settings_service.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_pages.dart';
import 'translations/app_translations.dart';

class MindMirrorApp extends StatelessWidget {
  const MindMirrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Get.find<SettingsService>();
    return Obx(
      () => GetMaterialApp(
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
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: settings.themeMode,
        initialRoute: AppPages.initial,
        getPages: AppPages.routes,
        initialBinding: InitialBinding(),
        builder: (context, child) {
          final textScale = MediaQuery.of(context).textScaleFactor.clamp(1.0, 1.2);
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: textScale),
            child: child ?? const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}
