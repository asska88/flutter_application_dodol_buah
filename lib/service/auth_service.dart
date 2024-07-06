import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

class AuthService {
  final user = FirebaseAuth.instance.currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final Logger _logger = Logger();
  Future<UserCredential?> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      _logger.d('Trying to register with email: $email');
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      _logger.d('Registration successful: ${userCredential.user?.uid}');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _logger.e('FirebaseAuthException: ${e.code}, ${e.message}');
        // Kata sandi terlalu lemah
        _logger.w('Kata sandi yang diberikan terlalu lemah.');
      } else if (e.code == 'email-already-in-use') {
        // Email sudah digunakan
        throw Exception('Akun sudah ada dengan email tersebut.');
      }
      return null;
    } catch (e) {
      // Error lain
      _logger.e('Other exception: $e');
      _logger.w(e);
      return null;
    }
  }

  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _logger.w('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        _logger.w('Wrong password provided for that user.');
      }
      return null;
    } catch (e) {
      _logger.e('Error during sign in: $e');
      return null;
    }
  }

  // Google Sign-In
Future<void> signInwithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print(e.message);
      }
      rethrow;
    }
  }

  Future<void> signOutFromGoogle() async{
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  Future<UserCredential?> signInAnonymously() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInAnonymously();
      return userCredential;
    } on FirebaseAuthException catch (e) {
      // Tangani error jika ada
      _logger.e('Error during sign in anonymously: $e');
      return null;
    }
  }

  User? _user;
  Map<String, dynamic>? _userData;

  Future<void> fetchUserData() async {
    _user = FirebaseAuth.instance.currentUser;
    if (_user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .get();
      if (userDoc.exists) {
        // ignore: unnecessary_cast
        _userData = userDoc.data() as Map<String, dynamic>?;
      }
    }
  }

  Map<String, dynamic>? getUserData() {
    // Method untuk mendapatkan userData
    return _userData;
  }

  Future<String?> getUserRole(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        return userDoc.get('role');
      } else {
        return null; // User document doesn't exist
      }
    } catch (e) {
      // Handle errors, e.g., log the error
      return null;
    }
  }

  
}
