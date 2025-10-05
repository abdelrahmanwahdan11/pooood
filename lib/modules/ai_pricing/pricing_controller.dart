import 'package:get/get.dart';

import '../../core/utils/time.dart';
import '../../data/models/auction.dart';
import '../../data/models/pricing_request.dart';
import '../../data/models/pricing_result.dart';
import '../../data/repositories/auctions_repo.dart';
import '../../data/repositories/settings_repo.dart';

class PricingController extends GetxController {
  PricingController(this.auctionsRepository, this.settingsRepository);

  final AuctionsRepository auctionsRepository;
  final SettingsRepository settingsRepository;

  final RxBool isCalculating = RxBool(false);
  final Rxn<PricingResult> result = Rxn<PricingResult>();
  final Rxn<PricingRequest> lastRequest = Rxn<PricingRequest>();

  static const Map<String, double> _basePriceTable = {
    'Electronics': 4200,
    'Luxury Watches': 38000,
    'Luxury Cars': 480000,
    'Electric Cars': 220000,
    'Jewelry': 15000,
    'Photography': 12000,
    'Real Estate': 1200000,
    'Home Decor': 8000,
    'Gaming': 9000,
    'Mobility': 6000,
  };

  Future<void> estimate(PricingRequest request) async {
    isCalculating.value = true;
    lastRequest.value = request;

    final auctions = await auctionsRepository.fetchAuctions();
    final productMap =
        await auctionsRepository.fetchProductsForAuctions(auctions.map((a) => a.productId));
    final relatedAuctions = auctions.where((auction) {
      final product = productMap[auction.productId];
      return product?.category.toLowerCase() == request.category.toLowerCase();
    }).toList();

    final base = _basePriceTable[request.category] ?? 6500;
    final conditionFactor = _conditionFactor(request.condition);
    final yearFactor = _yearFactor(request.year);
    final demandFactor = _demandFactor(relatedAuctions.length);
    final localMedian = _localMedian(relatedAuctions);
    final seasonalityFactor = _seasonalityFactor();
    final quantityFactor = 1 + ((request.quantity - 1) * 0.04);

    var estimate = base * conditionFactor * yearFactor * demandFactor;
    if (localMedian > 0) {
      estimate = (estimate * 0.6) + (localMedian * 0.4);
    }
    estimate *= seasonalityFactor * quantityFactor;

    final low = estimate * 0.9;
    final high = estimate * 1.12;
    final confidence = (70 + demandFactor * 20).clamp(50, 95).round();
    final bestTime = TimeUtils.bestSellingSlot(DateTime.now());
    final suggestedArea = request.location.isNotEmpty
        ? request.location
        : (relatedAuctions.isNotEmpty
            ? productMap[relatedAuctions.first.productId]?.location ?? 'City Center'
            : 'City Center');

    result.value = PricingResult(
      estimateLow: low,
      estimateHigh: high,
      confidence: confidence,
      bestTime: bestTime,
      suggestedArea: suggestedArea,
    );
    isCalculating.value = false;
  }

  double _conditionFactor(String condition) {
    switch (condition.toLowerCase()) {
      case 'new':
        return 1.1;
      case 'like new':
        return 1.05;
      case 'excellent':
        return 1.04;
      case 'good':
        return 0.95;
      case 'fair':
        return 0.85;
      default:
        return 1;
    }
  }

  double _yearFactor(int year) {
    final currentYear = DateTime.now().year;
    final age = (currentYear - year).clamp(0, 20);
    final depreciation = 1 - (age * 0.03);
    return depreciation.clamp(0.55, 1.2);
  }

  double _demandFactor(int listings) {
    final clamped = listings.clamp(0, 30);
    return 1 + (clamped / 30 * 0.3);
  }

  double _localMedian(List<Auction> auctions) {
    if (auctions.isEmpty) return 0;
    final prices = auctions.map((e) => e.currentPrice).toList()..sort();
    final middle = prices.length ~/ 2;
    if (prices.length.isOdd) {
      return prices[middle];
    }
    return (prices[middle - 1] + prices[middle]) / 2;
  }

  double _seasonalityFactor() {
    final month = DateTime.now().month;
    if (month >= 11 || month <= 1) {
      return 1.08; // holiday boost
    }
    if (month >= 6 && month <= 8) {
      return 0.96; // summer slowdown
    }
    return 1.0;
  }
}
