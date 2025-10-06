/*
  هذا الملف يربط خرائط الترجمة بتطبيق GetX لتفعيل التعدد اللغوي.
  يمكن إضافة لغات جديدة بتعريف ملف خريطة جديد وتسجيله هنا.
*/
import 'package:get/get.dart';

import 'ar.dart';
import 'en.dart';

class AppTranslation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': en,
        'ar_SA': ar,
      };
}
