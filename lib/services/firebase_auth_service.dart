import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import '../models/user.dart';

class FirebaseAuthService {
  firebase_auth.FirebaseAuth? _firebaseAuth;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  FirebaseAuthService() {
    try {
      _firebaseAuth = firebase_auth.FirebaseAuth.instance;
    } catch (e) {
      debugPrint('FirebaseAuth initialization error: $e');
    }
  }

  // Get current Firebase user
  firebase_auth.User? get currentFirebaseUser => _firebaseAuth?.currentUser;

  // Sign in with Google
  Future<User?> signInWithGoogle() async {
    if (_firebaseAuth == null) {
      debugPrint('Firebase Auth not initialized');
      return null;
    }

    try {
      // Trigger the Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        // User cancelled the sign-in
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final firebase_auth.UserCredential userCredential = 
          await _firebaseAuth!.signInWithCredential(credential);

      final firebase_auth.User? firebaseUser = userCredential.user;
      
      if (firebaseUser == null) {
        return null;
      }

      // Convert Firebase user to app User model
      final user = User(
        name: firebaseUser.displayName ?? firebaseUser.email?.split('@')[0] ?? 'User',
        email: firebaseUser.email ?? '',
        password: '', // Google users don't have a password
        birthPlace: 'Google',
        treatment: 'Sr',
        age: 0,
        imagePath: firebaseUser.photoURL,
        role: UserRole.ordinary,
      );

      return user;
    } catch (e) {
      debugPrint('Error signing in with Google: $e');
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await Future.wait([
      if (_firebaseAuth != null) _firebaseAuth!.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  // Check if user is signed in with Google
  bool isSignedInWithGoogle() {
    return _firebaseAuth?.currentUser != null;
  }
}
