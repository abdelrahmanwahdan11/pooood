import '../models/discount_deal.dart';
import '../models/geo_point.dart';
import '../models/product.dart';

abstract class DiscountRepository {
  List<DiscountDeal> getDeals();
}

class InMemoryDiscountRepository implements DiscountRepository {
  InMemoryDiscountRepository();

  @override
  List<DiscountDeal> getDeals() {
    final now = DateTime.now();
    return [
      DiscountDeal(
        id: 'd1',
        product: const Product(
          id: 'p3',
          title: 'سماعات سوني WH-1000XM5',
          category: 'صوتيات',
          condition: 'جديدة',
          description: 'إلغاء ضجيج متقدم مع دعم بلوتوث متعدد الأجهزة.',
          imageUrls: [
            'https://images.pexels.com/photos/374870/pexels-photo-374870.jpeg',
          ],
        ),
        discountPercent: 25,
        priceAfter: 1100,
        storeName: 'متجر التقنية الذكية',
        expiresAt: now.add(const Duration(hours: 12)),
        location: const GeoPoint(latitude: 26.4207, longitude: 50.0888),
        distanceKm: 3.4,
      ),
      DiscountDeal(
        id: 'd2',
        product: const Product(
          id: 'p4',
          title: 'قلاية هوائية فيليبس',
          category: 'أجهزة منزلية',
          condition: 'جديدة',
          description: 'سعة عائلية مع تقنيات تسخين سريعة.',
          imageUrls: [
            'https://images.pexels.com/photos/4109137/pexels-photo-4109137.jpeg',
          ],
        ),
        discountPercent: 18,
        priceAfter: 699,
        storeName: 'مطبخ بلس',
        expiresAt: now.add(const Duration(days: 1)),
        location: const GeoPoint(latitude: 24.7743, longitude: 46.7386),
        distanceKm: 6.1,
      ),
    ];
  }
}
