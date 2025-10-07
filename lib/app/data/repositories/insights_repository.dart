import 'dart:math';

import '../models/emotion_reading.dart';

class InsightsRepository {
  final _positive = {
    'happy': 'joy',
    'excited': 'joy',
    'calm': 'calm',
    'peaceful': 'calm',
    'proud': 'joy',
    'grateful': 'joy',
  };

  final _negative = {
    'sad': 'sadness',
    'down': 'sadness',
    'angry': 'anger',
    'mad': 'anger',
    'stressed': 'anxiety',
    'worried': 'anxiety',
    'tired': 'sadness',
  };

  EmotionReading analyse(String input) {
    final tokens = input.toLowerCase().split(RegExp(r'[^a-zA-Z\u0600-\u06FF]+'));
    int joy = 5, sadness = 5, anger = 5, anxiety = 5, calm = 5;
    for (final token in tokens) {
      if (_positive.containsKey(token)) {
        switch (_positive[token]) {
          case 'joy':
            joy += 15;
            break;
          case 'calm':
            calm += 20;
            break;
        }
      }
      if (_negative.containsKey(token)) {
        switch (_negative[token]) {
          case 'sadness':
            sadness += 18;
            break;
          case 'anger':
            anger += 18;
            break;
          case 'anxiety':
            anxiety += 20;
            break;
        }
      }
    }
    calm = max(calm, 10);
    return EmotionReading(
      joy: joy.clamp(0, 100),
      sadness: sadness.clamp(0, 100),
      anger: anger.clamp(0, 100),
      anxiety: anxiety.clamp(0, 100),
      calm: calm.clamp(0, 100),
    );
  }
}
