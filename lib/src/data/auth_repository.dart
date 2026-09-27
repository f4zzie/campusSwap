import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/models.dart';

class AuthRepository {
  AuthRepository(this._auth, this._firestore);

  static bool _googleInitialized = false;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signIn(String email, String password) =>
      _auth.signInWithEmailAndPassword(email: email.trim(), password: password);

  Future<UserCredential> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn.instance;
    if (!_googleInitialized) {
      await googleSignIn.initialize();
      _googleInitialized = true;
    }
    final GoogleSignInAccount googleUser;
    try {
      googleUser = await googleSignIn.authenticate();
    } on GoogleSignInException catch (error) {
      // Only a genuine user cancel is a "cancel"; anything else (a missing
      // OAuth client for this signing key, Play Services trouble, ...) keeps
      // its real code so the UI can say what actually failed instead of
      // blaming the student for cancelling.
      throw FirebaseAuthException(
        code: error.code == GoogleSignInExceptionCode.canceled
            ? 'cancelled'
            : 'google-sign-in-${error.code.name}',
        message: error.description ?? error.toString(),
      );
    }
    // Android only returns an ID token when the app's package name and signing
    // certificate are registered in the Firebase project. Without one there is
    // nothing to exchange for a Firebase session.
    final idToken = googleUser.authentication.idToken;
    if (idToken == null) {
      throw FirebaseAuthException(
        code: 'google-sign-in-missing-id-token',
        message: 'Google returned no ID token for this app.',
      );
    }
    final credential = GoogleAuthProvider.credential(idToken: idToken);
    final userCredential = await _auth.signInWithCredential(credential);
    final user = userCredential.user!;
    final existing = await _firestore.collection('users').doc(user.uid).get();
    if (!existing.exists) {
      final profile = UserProfile(
        id: user.uid,
        email: user.email ?? googleUser.email,
        displayName: user.displayName ?? googleUser.displayName ?? 'Student',
        university: '',
        photoUrl: user.photoURL,
        createdAt: DateTime.now(),
      );
      await _firestore.collection('users').doc(user.uid).set(profile.toJson());
    }
    return userCredential;
  }

  Future<UserCredential> register({
    required String email,
    required String password,
    required String displayName,
    required String university,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final user = credential.user!;
    await user.updateDisplayName(displayName.trim());
    await user.sendEmailVerification();
    final profile = UserProfile(
      id: user.uid,
      email: email.trim(),
      displayName: displayName.trim(),
      university: university.trim(),
      createdAt: DateTime.now(),
    );
    await _firestore.collection('users').doc(user.uid).set(profile.toJson());
    return credential;
  }

  Future<void> updateProfile(
    String uid, {
    String? displayName,
    String? university,
    String? bio,
    String? photoUrl,
  }) async {
    final data = <String, Object?>{
      if (displayName != null) 'displayName': displayName.trim(),
      if (university != null) 'university': university.trim(),
      if (bio != null) 'bio': bio.trim(),
      'photoUrl': ?photoUrl,
    };
    if (data.isEmpty) return;
    if (displayName != null) {
      await _auth.currentUser?.updateDisplayName(displayName.trim());
    }
    await _firestore.collection('users').doc(uid).update(data);
  }

  Future<void> resendVerification() async {
    await _auth.currentUser?.sendEmailVerification();
  }

  Future<void> resetPassword(String email) =>
      _auth.sendPasswordResetEmail(email: email.trim());

  Future<void> signOut() => _auth.signOut();

  Future<UserProfile?> getProfile(String uid) async {
    final snapshot = await _firestore.collection('users').doc(uid).get();
    final data = snapshot.data();
    return data == null ? null : UserProfile.fromJson(data);
  }

  Stream<UserProfile?> watchProfile(String uid) => _firestore
      .collection('users')
      .doc(uid)
      .snapshots()
      .map(
        (snapshot) => snapshot.data() == null
            ? null
            : UserProfile.fromJson(snapshot.data()!),
      );
}
