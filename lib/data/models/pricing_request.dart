class PricingRequest {
  const PricingRequest({
    required this.id,
    required this.category,
    required this.brand,
    required this.model,
    required this.year,
    required this.condition,
    required this.market,
    required this.quantity,
    required this.location,
    required this.photoUrls,
    required this.description,
    required this.timeframe,
  });

  final int id;
  final String category;
  final String brand;
  final String model;
  final int year;
  final String condition;
  final String market;
  final int quantity;
  final String location;
  final List<String> photoUrls;
  final String description;
  final String timeframe;

  Map<String, dynamic> toMap() => {
        'id': id,
        'category': category,
        'brand': brand,
        'model': model,
        'year': year,
        'condition': condition,
        'market': market,
        'quantity': quantity,
        'location': location,
        'photoUrls': photoUrls.join('|'),
        'description': description,
        'timeframe': timeframe,
      };

  static PricingRequest fromMap(Map<String, dynamic> map) => PricingRequest(
        id: map['id'] as int,
        category: map['category'] as String,
        brand: map['brand'] as String,
        model: map['model'] as String,
        year: map['year'] as int,
        condition: map['condition'] as String,
        market: map['market'] as String,
        quantity: map['quantity'] as int,
        location: map['location'] as String,
        photoUrls: (map['photoUrls'] as String).split('|'),
        description: map['description'] as String,
        timeframe: map['timeframe'] as String,
      );
}
