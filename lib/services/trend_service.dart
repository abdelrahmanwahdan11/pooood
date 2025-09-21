import '../data/models/product.dart';
import '../data/repositories/product_repo.dart';
import '../data/repositories/trend_repo.dart';

class TrendService {
  TrendService({
    required this.trendRepository,
    required this.productRepository,
  });

  final TrendRepository trendRepository;
  final ProductRepository productRepository;

  Future<List<Product>> trendingProducts({String? categoryId}) async {
    final products = await trendRepository.trendingProducts(productRepository, categoryId: categoryId);
    return products..sort((a, b) => b.trendingScore.compareTo(a.trendingScore));
  }

  Future<List<Product>> topSelling({int limit = 6}) async {
    final products = await trendingProducts();
    return products.take(limit).toList();
  }

  // TODO: Firebase / BigQuery / TensorFlow
  // الخيار A: Firebase + BigQuery
  // 1) إرسال بيانات المبيعات إلى BigQuery عبر Firebase Extensions.
  // 2) إنشاء Cloud Function مجدولة تحسب score الترند لكل فئة وتخزنه في Firestore.
  // 3) يقوم TrendService بقراءة مجموعة Firestore `trends/{category}/items` واستخدامها بدلاً من ملفات JSON.
  // الخيار B: TensorFlow Lite على الجهاز
  // 1) تدريب نموذج تنبؤ الطلب بناءً على ميزات المنتج والوقت.
  // 2) تحويله إلى .tflite ووضعه ضمن assets/tflite/.
  // 3) استدعاء النموذج في TrendService لتحديث score محلياً وإرسال telemetry مجهولة المصدر عند الحاجة.
}
