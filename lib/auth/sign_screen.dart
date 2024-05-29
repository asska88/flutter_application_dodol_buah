import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/auth/auth_service.dart';
import 'package:passwordfield/passwordfield.dart';
import 'package:sign_button/sign_button.dart';

class SignScreen extends StatefulWidget {
  const SignScreen({super.key});

  @override
  State<SignScreen> createState() => _SignScreenState();
}

class _SignScreenState extends State<SignScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailControler = TextEditingController();
  final TextEditingController _passwordControler = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  void _signIn() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    UserCredential? userCredential =
        await _authService.signInWithEmailAndPassword(
            _emailControler.text, _passwordControler.text);
    setState(() {
      _isLoading = false;
      if (userCredential == null) {
        _errorMessage = 'Sign in failed. Please check your Email and Password.';
      } else {
        Navigator.pushReplacementNamed(context, '/home');
      }
    });
  }

  @override
  void dispose() {
    _emailControler.dispose();
    _passwordControler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Image.asset(
              'assets/images/logo_dengan_simbol_chameleon_dan_nama_logo_chameleon_png-fotor-bg-remover-2024052682742.png',
              width: 271,
              height: screenSize.height * 0.3,
            ),
            Text(
              'Sign In',
              style:
                  GoogleFonts.dmSans(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 37, right: 42),
              child: TextFormField(
                controller: _emailControler,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(screenSize.height * 0.01),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: const BorderSide(color: Colors.black38)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: const BorderSide(color: Colors.red)),
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
              ),
            ),
            SizedBox(
              height: screenSize.height * 0.03,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 37, right: 42),
              child: PasswordField(
                controller: _passwordControler,
                errorMessage: '''
          - A uppercase letter
          - A lowercase letter
          - A digit
          - A special character
          - A minimum length of 8 characters
           ''',
                passwordDecoration: PasswordDecoration(
                  inputPadding: const EdgeInsets.only(left: 25),
                  hintStyle:
                      GoogleFonts.dmSans(fontSize: 20, color: Colors.black38),
                ),
                border: PasswordBorder(
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(),
                        borderRadius: BorderRadius.circular(25)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black38),
                        borderRadius: BorderRadius.circular(25)),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide:
                            const BorderSide(color: Colors.red, width: 2))),
                hintText: 'Password',
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: screenSize.height * 0.02),
              child: ElevatedButton(
                  onPressed: _isLoading ? null : _signIn,
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
                      ? const CircularProgressIndicator()
                      : Text(
                          'Sign In',
                          style: GoogleFonts.dmSans(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        )),
                        
            ),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: GoogleFonts.dmSans(color: Colors.red),
              ),
              const SizedBox(height: 16.0),
            ElevatedButton( // Tombol untuk sign in anonim
              onPressed: _isLoading ? null : () async {
                setState(() => _isLoading = true);
                UserCredential? userCredential = await _authService.signInAnonymously();
                setState(() => _isLoading = false);
                if (userCredential != null) {
                  // ignore: use_build_context_synchronously
                  Navigator.pushReplacementNamed(context, '/home');
                } else {
                  _errorMessage = 'Anonymous sign in failed.'; // Tambahkan pesan error jika diperlukan
                }
              },
              child: const Text('Masuk sebagai Tamu'),
            ),
            if (_errorMessage != null) Text(_errorMessage!),
            Padding(
              padding: const EdgeInsets.only(top: 40),
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
            const SizedBox(
              height: 34,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SignInButton.mini(
                  buttonType: ButtonType.apple,
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  elevation: 0,
                ),
                SignInButton.mini(
                  buttonType: ButtonType.google,
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  elevation: 0,
                ),
                SignInButton.mini(
                  buttonType: ButtonType.facebook,
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  elevation: 0,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Don’t have account',
                  style: GoogleFonts.dmSans(fontSize: 20, color: Colors.black),
                ),
                TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(),
                    child: Text(
                      'Sign Up',
                      style: GoogleFonts.dmSans(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ))
              ],
            )
          ]),
        ),
      ),
    );
  }
}
