// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/auth/auth_service.dart';
import 'package:myapp/helper/keyboard.dart';
import 'package:sign_button/sign_button.dart';

class SignScreen extends StatefulWidget {
  const SignScreen({super.key});

  @override
  State<SignScreen> createState() => _SignScreenState();
}

class _SignScreenState extends State<SignScreen> {
  final AuthService _authService = AuthService();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final TextEditingController _emailControler = TextEditingController();
  final TextEditingController _passwordControler = TextEditingController();
  bool _obscureText = true; 

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
  bool _isLoading = false;
  String? _errorMessage;

  void _signIn() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      KeyboardUtil();
    });
    UserCredential? userCredential =
        await _authService.signInWithEmailAndPassword(
            _emailControler.text, _passwordControler.text);
    if (userCredential != null) {
      String? userRole =
          await _authService.getUserRole(userCredential.user!.uid);

      if (userRole == 'admin') {
        Navigator.pushReplacementNamed(
            context, '/admin');
      } else {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Sign in failed. Please check your Email and Password.';
      });
    }
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
              'assets/images/logo.png',
              width: screenSize.width * 0.8,
              height: screenSize.height * 0.3,
              fit: BoxFit.cover,
            ),
            Text(
              'Sign In',
              style:
                  GoogleFonts.dmSans(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: screenSize.height * 0.02,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 37, right: 42),
              child: _formEmail(screenSize),
            ),
            SizedBox(
              height: screenSize.height * 0.03,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 37, right: 42),
              child: _formPassword(),
            ),
            Padding(
              padding: EdgeInsets.only(top: screenSize.height * 0.03),
              child: _signButton(),
            ),
            SizedBox(
              height: screenSize.height * 0.01,
            ),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: GoogleFonts.dmSans(color: Colors.red),
              ),
            const SizedBox(height: 16.0),
            Padding(
              padding: EdgeInsets.only(top: screenSize.height * 0.05),
              child: _continueWith(),
            ),
            SizedBox(
              height: screenSize.height * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buttonLoginGoogle(context),
                _buttonLoginFB(context),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Don’t have account',
                  style: GoogleFonts.dmSans(fontSize: 20, color: Colors.black),
                ),
                _buttonSignUp(context)
              ],
            )
          ]),
        ),
      ),
    );
  }

  TextButton _buttonSignUp(BuildContext context) {
    return TextButton(
        onPressed: () {
          Navigator.pushNamed(context, '/signup');
        },
        style: TextButton.styleFrom(),
        child: Text(
          'Sign Up',
          style: GoogleFonts.dmSans(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ));
  }

  SignInButton _buttonLoginFB(BuildContext context) {
    return SignInButton.mini(
      buttonType: ButtonType.facebook,
      onPressed: () {
        Navigator.pushNamed(context, '/login');
      },
      elevation: 0,
    );
  }

  SignInButton _buttonLoginGoogle(BuildContext context) {
    return SignInButton.mini(
      buttonType: ButtonType.google,
      onPressed: () => _authService.signInwithGoogle(),
      elevation: 0,
    );
  }

  

  Row _continueWith() {
    return Row(
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
          style: GoogleFonts.dmSans(fontSize: 20, letterSpacing: -0.4),
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
    );
  }


  ElevatedButton _signButton() {
    return ElevatedButton(
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
              ));
  }

  TextFormField _formPassword() {
    var screenSize = MediaQuery.of(context).size;
    return TextFormField(
      focusNode: _passwordFocusNode,
      controller: _passwordControler,
      obscureText: _obscureText,
      obscuringCharacter: '*',
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) {
        _passwordFocusNode.unfocus();
        KeyboardUtil.hideKeyboard(context);
        _signIn();
      },
      decoration: InputDecoration(
        contentPadding:  EdgeInsets.all(screenSize.height * 0.01),
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
        labelStyle: GoogleFonts.dmSans(fontSize: 20, color: Colors.black38),
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

  TextFormField _formEmail(Size screenSize) {
    return TextFormField(
      focusNode: _emailFocusNode,
      controller: _emailControler,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) {
        _emailFocusNode.unfocus();
        FocusScope.of(context).requestFocus(_passwordFocusNode);
      },
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
          labelStyle: GoogleFonts.dmSans(fontSize: 20, color: Colors.black38),
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
}
