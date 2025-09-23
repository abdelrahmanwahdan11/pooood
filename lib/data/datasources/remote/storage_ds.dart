import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageDataSource {
  StorageDataSource(this._storage);

  final FirebaseStorage _storage;

  Future<String> uploadFile({
    required String path,
    required File file,
    required String contentType,
  }) async {
    final ref = _storage.ref().child(path);
    final uploadTask = await ref.putFile(
      file,
      SettableMetadata(contentType: contentType),
    );
    return uploadTask.ref.getDownloadURL();
  }
}
