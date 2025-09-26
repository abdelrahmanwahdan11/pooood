import 'geo_point.dart';

class User {
  const User({
    required this.id,
    required this.name,
    required this.avatarUrl,
    this.location,
  });

  final String id;
  final String name;
  final String avatarUrl;
  final GeoPoint? location;

  factory User.fromMap(Map<String, dynamic> map, {String? id}) {
    GeoPoint? parseLocation(dynamic value) {
      if (value is GeoPoint) return value;
      if (value is Map<String, dynamic>) {
        return GeoPoint.fromMap(value);
      }
      return null;
    }

    return User(
      id: id ?? map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      avatarUrl: map['avatarUrl'] as String? ?? '',
      location: parseLocation(map['location']),
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'avatarUrl': avatarUrl,
        if (location != null) 'location': location!.toMap(),
      };

  static const demo = User(
    id: 'user_1',
    name: 'ليان الزهراني',
    avatarUrl:
        'https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg?auto=compress',
    location: GeoPoint(latitude: 24.7136, longitude: 46.6753),
  );
}
