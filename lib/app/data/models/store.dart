import 'item.dart';

class Store {
  Store({
    required this.id,
    required this.name,
    required this.country,
    required this.geo,
  });

  final String id;
  final String name;
  final String country;
  final ItemGeo geo;
}
