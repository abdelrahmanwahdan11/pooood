import 'geo_point.dart';

class WantedRequest {
  const WantedRequest({
    required this.id,
    required this.userId,
    required this.title,
    required this.targetPrice,
    required this.radiusKm,
    required this.location,
    required this.createdAt,
  });

  final String id;
  final String userId;
  final String title;
  final double targetPrice;
  final double radiusKm;
  final GeoPointModel location;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'title': title,
        'targetPrice': targetPrice,
        'radiusKm': radiusKm,
        'location': location.toJson(),
        'createdAt': createdAt.toIso8601String(),
      };

  factory WantedRequest.fromJson(String id, Map<String, dynamic> json) {
    return WantedRequest(
      id: id,
      userId: json['userId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      targetPrice: (json['targetPrice'] as num?)?.toDouble() ?? 0,
      radiusKm: (json['radiusKm'] as num?)?.toDouble() ?? 5,
      location: GeoPointModel.fromJson(
        (json['location'] as Map<String, dynamic>? ?? {}),
      ),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
