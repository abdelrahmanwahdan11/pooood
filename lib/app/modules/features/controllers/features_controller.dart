import 'package:get/get.dart';

import '../../../core/services/feature_service.dart';
import '../../../data/models/experience_feature.dart';

class FeaturesController extends GetxController {
  FeaturesController(this._featureService);

  final FeatureService _featureService;

  List<ExperienceFeature> get features => _featureService.features;
  RxMap<String, bool> get toggles => _featureService.toggles;

  Future<void> toggleFeature(ExperienceFeature feature, bool value) {
    return _featureService.toggle(feature.id, value);
  }
}
