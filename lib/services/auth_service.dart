import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import '../core/constants/app_constants.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ✅ GOOGLE SIGN-IN (FIXED)
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser =
      await _googleSignIn.signIn();

      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
      await _auth.signInWithCredential(credential);

      final user = userCredential.user;

      if (user != null) {
        // 🔥 Non-blocking Firestore call
        _createUserIfNotExists(user);
      }

      return user;
    } catch (e) {
      debugPrint("Google Sign-In Error: $e");
      rethrow;
    }
  }

  // ✅ SAFE FIRESTORE USER CREATION
  Future<void> _createUserIfNotExists(User user) async {
    try {
      final docRef = _firestore
          .collection(AppConstants.usersCollection)
          .doc(user.uid);

      final doc =
      await docRef.get().timeout(const Duration(seconds: 5));

      if (!doc.exists) {
        await docRef.set({
          'name': user.displayName ?? 'Google User',
          'email': user.email,
          'createdAt': FieldValue.serverTimestamp(),
        }).timeout(const Duration(seconds: 5));
      }
    } catch (e) {
      debugPrint("Firestore skipped: $e");
      // ❗ Do NOT throw
    }
  }

  // ✅ SIGN UP (FIXED LOADING ISSUE)
  Future<User?> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final credential =
      await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (credential.user != null) {
        await credential.user!.updateDisplayName(name.trim());

        try {
          await _firestore
              .collection(AppConstants.usersCollection)
              .doc(credential.user!.uid)
              .set({
            'name': name.trim(),
            'email': email.trim(),
            'createdAt': FieldValue.serverTimestamp(),
          })
              .timeout(const Duration(seconds: 5));
        } catch (e) {
          debugPrint("Firestore signup skipped: $e");
        }
      }

      return credential.user;
    } on FirebaseAuthException catch (e) {
      debugPrint('Auth Signup Error: ${e.code}');
      rethrow;
    }
  }

  // SIGN IN
  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential =
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return credential.user;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  String get userName =>
      currentUser?.displayName ??
          currentUser?.email?.split('@').first ??
          'User';

  String get userEmail => currentUser?.email ?? '';

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }
}