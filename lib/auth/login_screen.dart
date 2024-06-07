import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/auth/auth_service.dart';
import 'package:sign_in_button/sign_in_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailControler = TextEditingController();
  final TextEditingController _passwordControler = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

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
              'assets/images/logo.png',
              width: screenSize.width * 0.8,
              height: screenSize.height * 0.3,
            ),
            Padding(
              padding: EdgeInsets.only(top: screenSize.height * 0.01),
              child: Text(
                'Let’s You in',
                style: GoogleFonts.dmSans(
                    fontSize: screenSize.height * 0.055,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: screenSize.height * 0.02,
            ),
            SignInButtonBuilder(
                backgroundColor: Colors.white,
                onPressed: () {},
                text: 'Continue With Facebook',
                textColor: Colors.black,
                fontSize: screenSize.width * 0.05,
                icon: Icons.facebook,
                iconColor: Colors.blueAccent,
                width: screenSize.width * 0.8,
                height: screenSize.height * 0.07,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                    side: const BorderSide(width: 1.0))),
            SizedBox(
              height: screenSize.height * 0.02,
            ),
            SignInButtonBuilder(
                backgroundColor: Colors.white,
                onPressed: () {
                  Navigator.pushNamed(context, '/google');
                },
                text: 'Continue With Google',
                textColor: Colors.black,
                fontSize: screenSize.width * 0.05,
                image: Image.asset(
                  'assets/images/logo_google.png',
                  width: 21,
                  height: 18,
                ),
                width: screenSize.width * 0.8,
                height: screenSize.height * 0.07,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                    side: const BorderSide(width: 1.0))),
            SizedBox(
              height: screenSize.height * 0.02,
            ),
            SignInButtonBuilder(
                backgroundColor: Colors.white,
                onPressed: () {},
                text: 'Continue With Apple',
                textColor: Colors.black,
                fontSize: screenSize.width * 0.05,
                icon: Icons.apple,
                iconColor: Colors.black,
                width: screenSize.width * 0.8,
                height: screenSize.height * 0.07,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                    side: const BorderSide(width: 1.0))),
            Padding(
              padding: EdgeInsets.only(top: screenSize.height * 0.01),
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
                    'or',
                    style:
                        GoogleFonts.dmSans(fontSize: 30, letterSpacing: -0.4),
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
            ElevatedButton(
              // Tombol untuk sign in anonim
              onPressed: _isLoading
                  ? null
                  : () async {
                      setState(() => _isLoading = true);
                      UserCredential? userCredential =
                          await _authService.signInAnonymously();
                      setState(() => _isLoading = false);
                      if (userCredential != null) {
                        // ignore: use_build_context_synchronously
                        Navigator.pushReplacementNamed(context, '/home');
                      } else {
                        _errorMessage =
                            'Anonymous sign in failed.'; // Tambahkan pesan error jika diperlukan
                      }
                    },
              child: const Text('Masuk sebagai Tamu'),
            ),
            if (_errorMessage != null) Text(_errorMessage!),
            Padding(
              padding: EdgeInsets.only(top: screenSize.height * 0.01),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/sign');
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff9F57F9),
                      foregroundColor: Colors.white,
                      elevation: 10.0,
                      shadowColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      side: const BorderSide(width: 2),
                      fixedSize: Size(screenSize.width * 0.9, screenSize.height * 0.07)),
                  child: Text(
                    'Sign with Password',
                    style: GoogleFonts.dmSans(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  )),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Don’t have account',
                  style: GoogleFonts.dmSans(fontSize: screenSize.width * 0.05, color: Colors.black),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    style: TextButton.styleFrom(),
                    child: Text(
                      'Sign Up',
                      style: GoogleFonts.dmSans(
                          fontSize: screenSize.width * 0.05,
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
