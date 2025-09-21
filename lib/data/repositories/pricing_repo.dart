import '../datasources/remote/stub_api_ds.dart';

class PricingSample {
  PricingSample({
    required this.id,
    required this.category,
    required this.brand,
    required this.model,
    required this.condition,
    required this.year,
    required this.price,
    required this.currency,
    this.confidence = 0.7,
    this.title,
    this.image,
  });

  final String id;
  final String category;
  final String brand;
  final String model;
  final String condition;
  final int year;
  final double price;
  final String currency;
  final double confidence;
  final String? title;
  final String? image;

  factory PricingSample.fromJson(Map<String, dynamic> json) {
    return PricingSample(
      id: json['id'] as String,
      category: json['category'] as String,
      brand: json['brand'] as String,
      model: json['model'] as String,
      condition: json['condition'] as String,
      year: json['year'] as int,
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'USD',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.7,
      title: json['title'] as String?,
      image: json['image'] as String?,
    );
  }
}

class PricingRepository {
  PricingRepository(this._remote);

  final StubApiDataSource _remote;
  List<PricingSample>? _cache;

  Future<List<PricingSample>> getSamples() async {
    _cache ??= (await _remote.fetchPricingSamples())
        .map((e) => PricingSample.fromJson(e))
        .toList();
    return _cache!;
  }
}
