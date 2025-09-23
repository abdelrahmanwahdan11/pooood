import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreDataSource {
  FirestoreDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> collection(String path) =>
      _firestore.collection(path);

  Future<QuerySnapshot<Map<String, dynamic>>> getCollection(
    String path,
    Query<Map<String, dynamic>> Function(
      CollectionReference<Map<String, dynamic>> ref,
    )? queryBuilder,
  ) {
    final ref = collection(path);
    final query = queryBuilder != null ? queryBuilder(ref) : ref;
    return query.get();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamCollection(
    String path,
    Query<Map<String, dynamic>> Function(
      CollectionReference<Map<String, dynamic>> ref,
    )? queryBuilder,
  ) {
    final ref = collection(path);
    final query = queryBuilder != null ? queryBuilder(ref) : ref;
    return query.snapshots();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getDocument(
    String path,
  ) =>
      _firestore.doc(path).get();

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamDocument(
    String path,
  ) =>
      _firestore.doc(path).snapshots();
}
