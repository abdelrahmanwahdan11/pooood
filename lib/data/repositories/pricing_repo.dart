import '../datasources/local/mock_data_provider.dart';
import '../models/price_request.dart';
import '../models/price_result.dart';

class PricingRepository {
  PricingRepository({required this.mockProvider});

  final MockDataProvider mockProvider;

  Future<List<Map<String, dynamic>>> loadSamples() async {
    final list = await mockProvider.loadList('assets/mock/pricing_samples.json');
    return list.whereType<Map<String, dynamic>>().toList();
  }

  Future<PriceResult> heuristicEstimate(PriceRequest request) async {
    final samples = await loadSamples();
    final matching = samples.where((sample) {
      return sample['category'] == request.category &&
          sample['brand'] == request.brand;
    }).toList();

    if (matching.isEmpty) {
      final base = samples.isNotEmpty ? samples.first['price'] as num : 1000;
      final double estimate = base.toDouble() * 0.9;
      return PriceResult(
        estimate: estimate,
        min: estimate * 0.85,
        max: estimate * 1.1,
        confidence: 0.4,
        explanation: 'No similar records found, using heuristic baseline.',
      );
    }

    matching.sort((a, b) =>
        (a['price'] as num).compareTo(b['price'] as num));
    final median = matching[matching.length ~/ 2]['price'] as num;
    final ageFactor = (DateTime.now().year - request.year).clamp(0, 15);
    final conditionMultiplier = switch (request.condition.toLowerCase()) {
      'new' => 1.1,
      'excellent' => 1.05,
      'good' => 1.0,
      'fair' => 0.9,
      _ => 0.85,
    };
    final depreciation = 1 - (ageFactor * 0.03);
    final estimate = median.toDouble() * conditionMultiplier * depreciation;
    return PriceResult(
      estimate: estimate,
      min: estimate * 0.9,
      max: estimate * 1.1,
      confidence: 0.6,
      explanation:
          'Median adjusted by condition and age. Add more samples or deploy TFLite for higher accuracy.',
    );
  }
}
