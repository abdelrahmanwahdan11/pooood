import 'dart:math';

import '../data/models/product.dart';

class PricingService {
  double estimatePrice(Product product) {
    if (product.locations.isEmpty) {
      return product.priceApprox;
    }
    final prices = product.locations.map((e) => e.price).toList()..sort();
    final mid = prices.length ~/ 2;
    if (prices.length.isOdd) {
      return prices[mid];
    }
    return (prices[mid - 1] + prices[mid]) / 2;
  }

  double forecastPrice(List<double> historical) {
    if (historical.isEmpty) return 0;
    final trend = historical.reduce((a, b) => a + b) / historical.length;
    return (trend * 0.9) + Random().nextDouble() * 10;
  }

  // TODO: TensorFlow Lite
  // 1) تدريب نموذج price-regression باستخدام بيانات تاريخية للأسعار.
  // 2) تحويل النموذج إلى ملف .tflite عبر TFLiteConverter.
  // 3) وضع الملف داخل assets/tflite/price_model.tflite وتحديث pubspec.
  // 4) في PricingService استخدم حزمة tflite_flutter لتحميل النموذج واستدعاء `run` لتمرير المعطيات والحصول على التنبؤ.
}
