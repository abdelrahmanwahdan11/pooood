import 'package:get/get.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import '../data/models/price_request.dart';
import '../data/models/price_result.dart';
import '../data/repositories/pricing_repo.dart';

class PricingService extends GetxService {
  PricingService({required this.pricingRepository});

  final PricingRepository pricingRepository;
  Interpreter? _interpreter;

  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('tflite/model.tflite');
      Get.log('TFLite model loaded');
    } on Exception catch (e) {
      Get.log('TFLite model not loaded: $e');
    }
  }

  Future<PriceResult> estimatePrice(PriceRequest request) async {
    if (_interpreter == null) {
      await loadModel();
    }
    if (_interpreter == null) {
      return pricingRepository.heuristicEstimate(request);
    }

    try {
      final input = _encode(request);
      final output = List.generate(1, (_) => List.filled(3, 0.0));
      _interpreter!.run(input, output);
      final estimate = output[0][0];
      final min = output[0][1];
      final max = output[0][2];
      return PriceResult(
        estimate: estimate,
        min: min,
        max: max,
        confidence: 0.8,
        explanation:
            'Estimated using TensorFlow Lite model. Ensure model metadata matches training pipeline.',
      );
    } on Exception catch (e) {
      Get.log('TFLite inference failed: $e');
      return pricingRepository.heuristicEstimate(request);
    }
  }

  List<List<double>> _encode(PriceRequest request) {
    // TODO: Align encoding with training pipeline (one-hot/normalization). Currently simplified.
    final year = request.year.toDouble();
    final conditionScore = switch (request.condition.toLowerCase()) {
      'new' => 1.0,
      'excellent' => 0.9,
      'good' => 0.8,
      'fair' => 0.6,
      _ => 0.5,
    };
    return [
      [year, conditionScore, request.category.hashCode.toDouble().abs() % 1000]
    ];
  }
}

extension on double {
  double abs() => this < 0 ? -this : this;
}
