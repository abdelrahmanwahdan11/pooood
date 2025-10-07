class OceanScore {
  const OceanScore({
    required this.openness,
    required this.conscientiousness,
    required this.extraversion,
    required this.agreeableness,
    required this.neuroticism,
  });

  final int openness;
  final int conscientiousness;
  final int extraversion;
  final int agreeableness;
  final int neuroticism;

  OceanScore copyWith({
    int? openness,
    int? conscientiousness,
    int? extraversion,
    int? agreeableness,
    int? neuroticism,
  }) {
    return OceanScore(
      openness: openness ?? this.openness,
      conscientiousness: conscientiousness ?? this.conscientiousness,
      extraversion: extraversion ?? this.extraversion,
      agreeableness: agreeableness ?? this.agreeableness,
      neuroticism: neuroticism ?? this.neuroticism,
    );
  }

  Map<String, int> toMap() => {
        'O': openness,
        'C': conscientiousness,
        'E': extraversion,
        'A': agreeableness,
        'N': neuroticism,
      };
}
