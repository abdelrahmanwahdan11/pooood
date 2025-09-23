import 'package:get_storage/get_storage.dart';

class GetStorageDataSource {
  GetStorageDataSource(this._box);

  final GetStorage _box;

  T? read<T>(String key) => _box.read<T>(key);

  Future<void> write(String key, dynamic value) => _box.write(key, value);

  Future<void> erase(String key) => _box.remove(key);
}
