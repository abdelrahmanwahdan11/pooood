/*
  هذا الملف هو نقطة الدخول للتطبيق ويهيئ الخدمات الأساسية والثيم والترجمة.
  يمكن توسيعه لإضافة إعدادات أولية أو مزامنة بيانات قبل تشغيل التطبيق.
*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/localization/app_translation.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_service.dart' as core_theme;
import 'data/services/ai_service.dart';
import 'data/services/auth_service.dart';
import 'data/services/storage_service.dart';
import 'data/services/theme_service.dart' as data_theme;
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  await initServices();
  runApp(const ThmaniApp());
}

Future<void> initServices() async {
  await Get.putAsync(() => StorageService().init());
  Get.put(data_theme.ThemePreferencesService());
  await Get.putAsync(() => core_theme.ThemeService().init());
  Get.put(AuthService());
  Get.put(AiService());
}

class ThmaniApp extends StatelessWidget {
  const ThmaniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final themeService = Get.find<core_theme.ThemeService>();
      final settings = StorageService.to.getSettings();
      final localeCode = settings['locale'] as String?;
      final locale = localeCode == 'en'
          ? const Locale('en', 'US')
          : const Locale('ar', 'SA');
      return GetMaterialApp(
        title: 'Thmani Auctions',
        debugShowCheckedModeBanner: false,
        translations: AppTranslation(),
        locale: locale,
        fallbackLocale: const Locale('en', 'US'),
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeService.themeMode,
        initialRoute: AppRoutes.splash,
        getPages: AppPages.routes,
        defaultTransition: Transition.fadeIn,
      );
    });
  }
}
