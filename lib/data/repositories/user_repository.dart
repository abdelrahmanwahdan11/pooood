import '../models/user.dart';

abstract class UserRepository {
  User get currentUser;
}

class InMemoryUserRepository implements UserRepository {
  InMemoryUserRepository();

  // Firebase integration placeholder:
  // Replace with FirebaseAuth and Firestore backed user lookups when ready.
  //
  // import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
  // import 'package:cloud_firestore/cloud_firestore.dart';
  //
  // class FirestoreUserRepository implements UserRepository {
  //   FirestoreUserRepository(this._auth, this._firestore);
  //
  //   final fb_auth.FirebaseAuth _auth;
  //   final FirebaseFirestore _firestore;
  //
  //   @override
  //   Future<User> get currentUser async {
  //      final fbUser = _auth.currentUser;
  //      if (fbUser == null) throw StateError('No user logged in');
  //      final doc = await _firestore.collection('users').doc(fbUser.uid).get();
  //      return User.fromMap(doc.data() ?? const <String, dynamic>{}, id: doc.id);
  //    }
  // }

  @override
  User get currentUser => User.demo;
}
