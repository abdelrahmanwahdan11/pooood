import 'package:get/get.dart';

import '../../../data/models/ocean_score.dart';
import '../../../data/models/trait.dart';

class ResultsController extends GetxController {
  late final OceanScore score;
  late final List<TraitScore> items;

  @override
  void onInit() {
    super.onInit();
    score = Get.arguments as OceanScore? ?? const OceanScore(
      openness: 0,
      conscientiousness: 0,
      extraversion: 0,
      agreeableness: 0,
      neuroticism: 0,
    );
    items = [
      TraitScore(Trait.openness, score.openness),
      TraitScore(Trait.conscientiousness, score.conscientiousness),
      TraitScore(Trait.extraversion, score.extraversion),
      TraitScore(Trait.agreeableness, score.agreeableness),
      TraitScore(Trait.neuroticism, score.neuroticism),
    ];
  }
}

class TraitScore {
  TraitScore(this.trait, this.value);

  final Trait trait;
  final int value;
}
