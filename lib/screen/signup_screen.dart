import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/service/auth_service.dart';
import 'package:myapp/helper/keyboard.dart';
import 'package:sign_button/sign_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController nameControler = TextEditingController();
  final TextEditingController emailControler = TextEditingController();
  final TextEditingController passwordControler = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  final FocusNode _passwordFocusNode = FocusNode();
  bool _obscureText = true;

  void _registerUser() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      UserCredential? userCredential =
          await _authService.registerWithEmailAndPassword(
              emailControler.text, passwordControler.text);
      if (userCredential != null) {
        try {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user!.uid)
              .set({
            'displayName': nameControler.text,
            'email': emailControler.text,
            'role': 'user'
          });
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/home');
          }
        } on FirebaseException catch (e) {
          setState(() {
            _errorMessage = 'Gagal menyimpan data pengguna: ${e.message}';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Registrasi gagal (auth). Silakan coba lagi.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Terjadi kesalahan: $e';
        _isLoading = false;
      });
    }
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void dispose() {
    super.dispose();
    emailControler.dispose();
    passwordControler.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Image.asset(
              'assets/images/logo.png',
              width: 271,
              height: screenSize.height * 0.3,
            ),
            Text(
              'Create your account',
              style:
                  GoogleFonts.dmSans(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: screenSize.height * 0.01,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 37, right: 42),
              child: _formNama(),
            ),
            SizedBox(
              height: screenSize.height * 0.02,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 37, right: 42),
              child: _formEmail(),
            ),
            SizedBox(
              height: screenSize.height * 0.02,
            ),
            Padding(
                padding: const EdgeInsets.only(left: 37, right: 42),
                child: _formPassword(context, screenSize)),
            Padding(
              padding: EdgeInsets.only(top: screenSize.height * 0.02),
              child: _buttonSignUp(),
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _errorMessage!,
                  style: GoogleFonts.dmSans(
                      color: Colors.red), // Atau gaya teks lain
                ),
              ),
            Padding(
              padding: EdgeInsets.only(top: screenSize.height * 0.03),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 29),
                      child: Divider(
                        color: Colors.black,
                        thickness: 1.0,
                      ),
                    ),
                  ),
                  Text(
                    'or continue with',
                    style:
                        GoogleFonts.dmSans(fontSize: 20, letterSpacing: -0.4),
                  ),
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: 29),
                      child: Divider(
                        thickness: 1.0,
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: screenSize.height * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SignInButton.mini(
                  buttonType: ButtonType.apple,
                  onPressed: () {
                    Navigator.pushNamed(context, '/home');
                  },
                  elevation: 0,
                ),
                SignInButton.mini(
                  buttonType: ButtonType.google,
                  onPressed: () {
                    Navigator.pushNamed(context, '/home');
                  },
                  elevation: 0,
                ),
                SignInButton.mini(
                  buttonType: ButtonType.facebook,
                  onPressed: () {
                    Navigator.pushNamed(context, '/home');
                  },
                  elevation: 0,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account?',
                  style: GoogleFonts.dmSans(fontSize: 20, color: Colors.black),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/sign');
                    },
                    style: TextButton.styleFrom(),
                    child: Text(
                      'Sign In',
                      style: GoogleFonts.dmSans(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    )),
              ],
            )
          ]),
        ),
      ),
    );
  }

  ElevatedButton _buttonSignUp() {
    return ElevatedButton(
                onPressed: _isLoading ? null : _registerUser,
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff9F57F9),
                    foregroundColor: Colors.white,
                    elevation: 10.0,
                    shadowColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    side: const BorderSide(width: 2),
                    fixedSize: const Size(339, 49)),
                child: _isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : Text(
                        'Sign Up',
                        style: GoogleFonts.dmSans(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ));
  }

  TextFormField _formPassword(BuildContext context, Size screenSize) {
    return TextFormField(
                focusNode: _passwordFocusNode,
                controller: passwordControler,
                obscureText: _obscureText,
                obscuringCharacter: '*',
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) {
                  _passwordFocusNode.unfocus();
                  KeyboardUtil.hideKeyboard(context);
                  _registerUser();
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(screenSize.height * 0.01),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(color: Colors.black38),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                  labelText: 'Password',
                  labelStyle:
                      GoogleFonts.dmSans(fontSize: 20, color: Colors.black38),
                  prefixIcon: const Icon(Icons.lock_outline),
                  prefixIconColor: Colors.black38,
                  suffixIcon: IconButton(
                    onPressed: () {
                      _toggleObscureText();
                    },
                    icon: const Icon(Icons.remove_red_eye_outlined),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harap masukkan password';
                  }

                  // Aturan validasi password
                  RegExp regex = RegExp(
                      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                  if (!regex.hasMatch(value)) {
                    return '''
Password harus mengandung:
- Minimal 1 huruf besar
- Minimal 1 huruf kecil
- Minimal 1 angka
- Minimal 1 karakter khusus (!@#\$&*~)
- Minimal 8 karakter
''';
                  }
                  return null;
                },
              );
  }

  TextFormField _formEmail() {
    return TextFormField(
              textInputAction: TextInputAction.next,
              controller: emailControler,
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(left: 30),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  labelText: 'Email',
                  labelStyle:
                      GoogleFonts.dmSans(fontSize: 20, color: Colors.black38),
                  prefixIcon: const Icon(Icons.email_outlined),
                  prefixIconColor: Colors.black38),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Harap masukan email';
                }
                if (!value.contains('@')) {
                  return 'Email harus menggunakan @';
                }
                return null;
              },
            );
  }

  TextFormField _formNama() {
    return TextFormField(
              textInputAction: TextInputAction.next,
              controller: nameControler,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(left: 30),
                prefixIcon: const Icon(Icons.person_outline),
                prefixIconColor: Colors.black38,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                labelText: 'Nama',
                labelStyle:
                    GoogleFonts.dmSans(fontSize: 20, color: Colors.black38),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Harap masukan Nama';
                }
                return null;
              },
            );
  }
}
