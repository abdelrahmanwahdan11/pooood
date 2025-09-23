class PriceResult {
  const PriceResult({
    required this.estimate,
    required this.min,
    required this.max,
    required this.confidence,
    this.explanation,
  });

  final double estimate;
  final double min;
  final double max;
  final double confidence;
  final String? explanation;

  Map<String, dynamic> toJson() => {
        'estimate': estimate,
        'min': min,
        'max': max,
        'confidence': confidence,
        'explanation': explanation,
      };
}
