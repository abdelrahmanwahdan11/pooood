import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/core/bindings/initial_binding.dart';
import 'app/core/services/feature_service.dart';
import 'app/core/services/settings_service.dart';
import 'app/main_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync<SettingsService>(() => SettingsService().init());
  await Get.putAsync<FeatureService>(() => FeatureService().init());
  runApp(const MindMirrorApp());
}
