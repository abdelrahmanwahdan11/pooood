import 'package:get/get.dart';

import '../../../core/services/locale_service.dart';
import '../controllers/language_select_controller.dart';

class LanguageSelectBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LanguageSelectController>(
      () => LanguageSelectController(localeService: Get.find<LocaleService>()),
    );
  }
}
