class PriceRequest {
  const PriceRequest({
    required this.category,
    required this.brand,
    required this.model,
    required this.year,
    required this.condition,
    required this.specs,
    required this.city,
  });

  final String category;
  final String brand;
  final String model;
  final int year;
  final String condition;
  final String specs;
  final String city;

  Map<String, dynamic> toFeatureMap() => {
        'category': category,
        'brand': brand,
        'model': model,
        'year': year,
        'condition': condition,
        'specs': specs,
        'city': city,
      };
}
