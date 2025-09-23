import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthService extends GetxService {
  AuthService(this._auth);

  final FirebaseAuth _auth;

  final Rxn<User> firebaseUser = Rxn<User>();

  @override
  void onInit() {
    firebaseUser.bindStream(_auth.authStateChanges());
    super.onInit();
  }

  bool get isLoggedIn => firebaseUser.value != null;

  Future<UserCredential> signInWithEmail(String email, String password) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> signUpWithEmail(String email, String password) {
    return _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() => _auth.signOut();

  Future<void> updateDisplayName(String name) async {
    await firebaseUser.value?.updateDisplayName(name);
    await firebaseUser.value?.reload();
  }

  Future<void> signInWithPhone(String phoneNumber, Duration timeout) async {
    final completer = Completer<void>();
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: timeout,
      verificationCompleted: (credential) async {
        await _auth.signInWithCredential(credential);
        completer.complete();
      },
      verificationFailed: (exception) {
        completer.completeError(exception);
      },
      codeSent: (verificationId, resendToken) {
        // TODO: show UI prompt to input SMS code, then call signInWithCredential.
        Get.log('Verification ID: $verificationId');
      },
      codeAutoRetrievalTimeout: (verificationId) {
        Get.log('Auto retrieval timeout for $verificationId');
      },
    );
    return completer.future;
  }

  Future<void> signInWithGoogle() async {
    // TODO: Configure google_sign_in for mobile/web and link with FirebaseAuth.
    Get.log('Google Sign-In not implemented. Configure google_sign_in and call signInWithCredential.');
  }

  Future<void> signInWithApple() async {
    // TODO: Use sign_in_with_apple for iOS/macOS and link credential to FirebaseAuth.
    Get.log('Apple Sign-In not implemented. Configure sign_in_with_apple and call signInWithCredential.');
  }
}
