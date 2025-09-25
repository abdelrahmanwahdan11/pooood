import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'core/bindings/initial_binding.dart';
import 'core/localization/translations.dart';
import 'core/routing/app_pages.dart';
import 'core/routing/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/app_repository_binding.dart';
import 'services/widget_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await WidgetService.initialize();

  final storage = GetStorage();
  final storedLocale = storage.read<String>('locale');
  final locale = storedLocale != null ? Locale(storedLocale) : const Locale('ar');
  final themeModeIndex = storage.read<int>('theme_mode') ?? ThemeMode.light.index;
  final normalizedIndex = themeModeIndex
      .clamp(0, ThemeMode.values.length - 1)
      .toInt();
  final themeMode = ThemeMode.values[normalizedIndex];

  runApp(BidGlassApp(initialLocale: locale, initialThemeMode: themeMode));
}

class BidGlassApp extends StatelessWidget {
  const BidGlassApp({super.key, required this.initialLocale, required this.initialThemeMode});

  final Locale initialLocale;
  final ThemeMode initialThemeMode;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'app_title'.tr,
      debugShowCheckedModeBanner: false,
      translations: AppTranslations(),
      locale: initialLocale,
      fallbackLocale: const Locale('en'),
      supportedLocales: const [Locale('ar'), Locale('en')],
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: initialThemeMode,
      initialRoute: AppRoutes.shell,
      getPages: AppPages.routes,
      initialBinding: InitialBinding(),
      defaultTransition: Transition.cupertino,
      smartManagement: SmartManagement.full,
    );
  }
}
