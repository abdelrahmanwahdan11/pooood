class GeoPoint {
  const GeoPoint({required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;

  factory GeoPoint.fromMap(Map<String, dynamic> map) {
    final lat = map['latitude'] ?? map['lat'];
    final lng = map['longitude'] ?? map['lng'];
    return GeoPoint(
      latitude: (lat as num?)?.toDouble() ?? 0,
      longitude: (lng as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
        'latitude': latitude,
        'longitude': longitude,
      };

  GeoPoint copyWith({double? latitude, double? longitude}) {
    return GeoPoint(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}
