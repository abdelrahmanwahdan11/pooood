import 'dart:math';

import 'package:get/get.dart';

import '../data/models/price_request.dart';
import '../data/models/price_result.dart';
import '../data/repositories/pricing_repo.dart';

class PricingService extends GetxService {
  PricingService(this._repo);

  final PricingRepository _repo;

  Future<PricingService> init() async {
    await _repo.getSamples();
    return this;
  }

  Future<PriceResult> estimatePrice(PriceRequest request) async {
    final samples = await _repo.getSamples();
    final filtered = samples
        .where((sample) => sample.category == request.category)
        .where((sample) => sample.brand == request.brand)
        .toList();
    final relevant = filtered.isNotEmpty ? filtered : samples;

    double weightSum = 0;
    double priceSum = 0;
    final nowYear = DateTime.now().year;
    final comparableItems = <ComparableItem>[];

    for (final sample in relevant) {
      final conditionScore = _conditionScore(sample.condition, request.condition);
      final yearDiff = (sample.year - request.year).abs();
      final yearScore = max(0.2, 1 - (yearDiff * 0.1));
      final agePenalty = max(0.4, 1 - ((nowYear - sample.year).abs() * 0.05));
      final weight = conditionScore * yearScore * agePenalty;
      weightSum += weight;
      priceSum += sample.price * weight;

      comparableItems.add(
        ComparableItem(
          id: sample.id,
          title: sample.title ?? '${sample.brand} ${sample.model}',
          price: sample.price,
          image: sample.image,
          source: sample.currency,
        ),
      );
    }

    final average = weightSum == 0 ? 0 : priceSum / weightSum;
    comparableItems.sort(
      (a, b) => (a.price - average).abs().compareTo((b.price - average).abs()),
    );

    final sortedByPrice = List<ComparableItem>.from(comparableItems)
      ..sort((a, b) => a.price.compareTo(b.price));
    final min = sortedByPrice.isEmpty ? average : sortedByPrice.first.price * 0.95;
    final max = sortedByPrice.isEmpty ? average : sortedByPrice.last.price * 1.05;
    final confidence = weightSum == 0 ? 0.4 : (weightSum / relevant.length).clamp(0.3, 0.95);

    // TODO: TensorFlow Lite integration steps
    // 1) Train a regression model on historical pricing data.
    // 2) Convert the trained model to TFLite using `tf.lite.TFLiteConverter`.
    // 3) Add tflite_flutter to pubspec and place `model.tflite` under assets/tflite/.
    // 4) Load interpreter in this service and feed encoded features for predictions.
    // 5) Store preprocessing artifacts (scalers/encoders) and apply before inference.

    return PriceResult(
      estimate: average,
      min: min,
      max: max,
      confidence: confidence,
      currency: relevant.isNotEmpty ? relevant.first.currency : request.currency,
      comparableItems: comparableItems.take(4).toList(),
    );
  }

  double _conditionScore(String sampleCondition, String requestCondition) {
    if (sampleCondition.toLowerCase() == requestCondition.toLowerCase()) {
      return 1;
    }
    const order = ['new', 'like_new', 'excellent', 'good', 'fair', 'poor'];
    final sampleIndex = order.indexOf(sampleCondition.toLowerCase());
    final requestIndex = order.indexOf(requestCondition.toLowerCase());
    if (sampleIndex == -1 || requestIndex == -1) {
      return 0.6;
    }
    final diff = (sampleIndex - requestIndex).abs();
    return max(0.3, 1 - diff * 0.2);
  }
}
