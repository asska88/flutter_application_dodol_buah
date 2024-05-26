import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

class AuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Logger _logger  = Logger();
  Future<UserCredential?> registerWithEmailAndPassword(String email, String password) async {
  try {
    _logger.d('Trying to register with email: $email');
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
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
      _logger.w('Akun sudah ada dengan email tersebut.');
    }
    return null; // Atau tangani error dengan cara lain
  } catch (e) {
    // Error lain
    _logger.e('Other exception: $e');
    _logger.w(e);
    return null; // Atau tangani error dengan cara lain
  }
}
Future<UserCredential?> signInWithEmailAndPassword(String email, String password) async {
  try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential;
// Suggested code may be subject to a license. Learn more: ~LicenseLog:2670102031.
  }on FirebaseAuthException catch (e){
// Suggested code may be subject to a license. Learn more: ~LicenseLog:3219128634.
    if (e.code == 'user-not-found') {
      _logger.w('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      _logger.w('Wrong password provided for that user.');
    }
    return null;
  } 
  catch (e) {
    _logger.e('Error during sign in: $e');
    return null ;
  }
}
}