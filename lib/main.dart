import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/core/bindings.dart';
import 'app/core/services/locale_service.dart';
import 'app/localization/translations.dart';
import 'app/routes/app_pages.dart';
import 'app/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  final translations = await AppTranslations.load();

  final localeService = Get.put(LocaleService(), permanent: true);
  await localeService.init();

  runApp(AppBootstrap(translations: translations));
}

class AppBootstrap extends StatelessWidget {
  const AppBootstrap({super.key, required this.translations});

  final AppTranslations translations;

  @override
  Widget build(BuildContext context) {
    final localeService = Get.find<LocaleService>();
    return Obx(
      () => GetMaterialApp(
        title: 'Nearby Auctions',
        debugShowCheckedModeBanner: false,
        translations: translations,
        locale: localeService.locale,
        fallbackLocale: AppTranslations.fallbackLocale,
        initialRoute: AppPages.initial,
        initialBinding: InitialBindings(),
        getPages: AppPages.routes,
        theme: AppTheme.lightTheme(localeService.locale),
        darkTheme: AppTheme.darkTheme(localeService.locale),
        themeMode: ThemeMode.system,
      ),
    );
  }
}
