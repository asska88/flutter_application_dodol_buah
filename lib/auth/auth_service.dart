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
}