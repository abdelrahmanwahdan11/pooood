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

  static const demo = User(
    id: 'user_1',
    name: 'ليان الزهراني',
    avatarUrl:
        'https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg?auto=compress',
    location: GeoPoint(latitude: 24.7136, longitude: 46.6753),
  );
}
