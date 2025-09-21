class ComparableItem {
  ComparableItem({
    required this.id,
    required this.title,
    required this.price,
    this.image,
    this.source,
  });

  final String id;
  final String title;
  final double price;
  final String? image;
  final String? source;

  factory ComparableItem.fromJson(Map<String, dynamic> json) {
    return ComparableItem(
      id: json['id'] as String,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      image: json['image'] as String?,
      source: json['source'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'price': price,
        'image': image,
        'source': source,
      };
}

class PriceResult {
  PriceResult({
    required this.estimate,
    required this.min,
    required this.max,
    required this.confidence,
    this.currency = 'USD',
    this.comparableItems = const [],
  });

  final double estimate;
  final double min;
  final double max;
  final double confidence;
  final String currency;
  final List<ComparableItem> comparableItems;

  Map<String, dynamic> toJson() => {
        'estimate': estimate,
        'min': min,
        'max': max,
        'confidence': confidence,
        'currency': currency,
        'comparableItems': comparableItems.map((e) => e.toJson()).toList(),
      };
}
