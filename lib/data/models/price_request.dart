class PriceRequest {
  PriceRequest({
    required this.category,
    required this.brand,
    required this.model,
    required this.year,
    required this.condition,
    required this.specs,
    this.currency = 'USD',
  });

  final String category;
  final String brand;
  final String model;
  final int year;
  final String condition;
  final List<String> specs;
  final String currency;

  Map<String, dynamic> toJson() => {
        'category': category,
        'brand': brand,
        'model': model,
        'year': year,
        'condition': condition,
        'specs': specs,
        'currency': currency,
      };

  factory PriceRequest.fromJson(Map<String, dynamic> json) {
    return PriceRequest(
      category: json['category'] as String,
      brand: json['brand'] as String,
      model: json['model'] as String,
      year: json['year'] as int,
      condition: json['condition'] as String,
      specs: (json['specs'] as List<dynamic>).cast<String>(),
      currency: json['currency'] as String? ?? 'USD',
    );
  }
}
