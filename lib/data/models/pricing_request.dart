class PricingRequest {
  const PricingRequest({
    required this.id,
    required this.productName,
    required this.condition,
    required this.estimatedPrice,
    required this.recommendedTime,
    required this.recommendedArea,
  });

  final String id;
  final String productName;
  final String condition;
  final double estimatedPrice;
  final String recommendedTime;
  final String recommendedArea;
}
