class PricingResult {
  const PricingResult({
    required this.estimateLow,
    required this.estimateHigh,
    required this.confidence,
    required this.bestTime,
    required this.suggestedArea,
  });

  final double estimateLow;
  final double estimateHigh;
  final int confidence;
  final String bestTime;
  final String suggestedArea;
}
