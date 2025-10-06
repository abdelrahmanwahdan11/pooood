class EmotionReading {
  EmotionReading({
    required this.joy,
    required this.sadness,
    required this.anger,
    required this.anxiety,
    required this.calm,
  });

  final int joy;
  final int sadness;
  final int anger;
  final int anxiety;
  final int calm;

  List<int> toList() => [joy, sadness, anger, anxiety, calm];
}
