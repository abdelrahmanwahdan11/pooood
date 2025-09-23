class GeoPointModel {
  const GeoPointModel({
    required this.latitude,
    required this.longitude,
    this.geohash,
  });

  final double latitude;
  final double longitude;
  final String? geohash;

  Map<String, dynamic> toJson() => {
        'lat': latitude,
        'lng': longitude,
        if (geohash != null) 'geohash': geohash,
      };

  factory GeoPointModel.fromJson(Map<String, dynamic> json) {
    return GeoPointModel(
      latitude: (json['lat'] ?? json['latitude'])?.toDouble() ?? 0,
      longitude: (json['lng'] ?? json['longitude'])?.toDouble() ?? 0,
      geohash: json['geohash'] as String?,
    );
  }
}
