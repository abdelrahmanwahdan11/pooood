import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import 'core/localization/translations.dart';
import 'core/routing/app_pages.dart';
import 'core/routing/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'data/db/app_db.dart';
import 'data/repositories/settings_repo.dart';
import 'modules/shell/shell_binding.dart';

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
    return GetMaterialApp(
      title: 'LiquidBid',
      translations: LiquidBidTranslations(),
      locale: locale,
      fallbackLocale: const Locale('en'),
      initialBinding: ShellBinding(settingsRepository: settingsRepository),
      initialRoute: AppRoutes.shell,
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
