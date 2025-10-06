import 'dart:math';

import '../models/compare_profile.dart';
import '../models/ocean_score.dart';

class CompareRepository {
  final _random = Random();
  final Map<String, CompareProfile> _profiles = {
    '123456': CompareProfile(
      code: '123456',
      displayName: 'Ahmad',
      scores: const OceanScore(
        openness: 72,
        conscientiousness: 64,
        extraversion: 55,
        agreeableness: 81,
        neuroticism: 40,
      ),
    ),
    '654321': CompareProfile(
      code: '654321',
      displayName: 'Rula',
      scores: const OceanScore(
        openness: 60,
        conscientiousness: 78,
        extraversion: 62,
        agreeableness: 74,
        neuroticism: 35,
      ),
    ),
  };

  CompareProfile saveProfile(CompareProfile profile) {
    _profiles[profile.code] = profile;
    return profile;
  }

  CompareProfile? getByCode(String code) => _profiles[code];

  String generateCode() {
    final code = List<int>.generate(6, (_) => _random.nextInt(10)).join();
    if (_profiles.containsKey(code)) {
      return generateCode();
    }
    return code;
  }
}
