class StoreLocation {
  StoreLocation({
    required this.id,
    required this.name,
    required this.lat,
    required this.lng,
    required this.availability,
    required this.price,
  });

  final String id;
  final String name;
  final double lat;
  final double lng;
  final bool availability;
  final double price;

  factory StoreLocation.fromJson(Map<String, dynamic> json) {
    return StoreLocation(
      id: json['id'] as String,
      name: json['name'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      availability: json['availability'] as bool,
      price: (json['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'lat': lat,
        'lng': lng,
        'availability': availability,
        'price': price,
      };
}
