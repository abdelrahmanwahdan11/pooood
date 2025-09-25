import '../models/pricing_request.dart';

abstract class PricingRepository {
  PricingRequest submitEstimate({
    required String productName,
    required String condition,
    required double basePrice,
  });
}

class InMemoryPricingRepository implements PricingRepository {
  @override
  PricingRequest submitEstimate({
    required String productName,
    required String condition,
    required double basePrice,
  }) {
    final adjustment = condition.toLowerCase().contains('جديد') ? 1.12 : 0.84;
    final estimated = basePrice * adjustment;
    return PricingRequest(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      productName: productName,
      condition: condition,
      estimatedPrice: estimated,
      recommendedTime: 'مساء الخميس',
      recommendedArea: 'واجهة الرياض',
    );
  }
}
