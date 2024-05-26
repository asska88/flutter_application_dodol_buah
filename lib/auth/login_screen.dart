import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sign_in_button/sign_in_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Image.asset(
              'assets/images/logo_dengan_simbol_chameleon_dan_nama_logo_chameleon_png-fotor-bg-remover-2024052682742.png',
              width: screenSize.width * 0.8,
              height: screenSize.height * 0.3,
            ),
            Padding(
              padding:  EdgeInsets.only(top: screenSize.height * 0.02),
              child: Text(
                'Let’s You in',
                style:
                    GoogleFonts.dmSans(fontSize: screenSize.height * 0.055, fontWeight: FontWeight.bold),
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
                fontSize: 20,
                icon: Icons.facebook,
                iconColor: Colors.blueAccent,
                width: 296,
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
                fontSize: 20,
                image: Image.asset(
                  'assets/images/logo_google.png',
                  width: 21,
                  height: 18,
                ),
                width: 296,
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
                fontSize: 20,
                icon: Icons.apple,
                iconColor: Colors.black,
                width: 296,
                height: screenSize.height * 0.07,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                    side: const BorderSide(width: 1.0))),
            Padding(
              padding:  EdgeInsets.only(top: screenSize.height * 0.02),
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
                    style: GoogleFonts.dmSans(fontSize: 30, letterSpacing: -0.4),
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
            Padding(
              padding:  EdgeInsets.only(top: screenSize.height * 0.02),
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
                      fixedSize:  Size(339, screenSize.height * 0.07)),
                  child: Text(
                    'Sign with Password',
                    style: GoogleFonts.dmSans(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  )),
            ),
             SizedBox(
              height: screenSize.height * 0.01,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Don’t have account',
                  style: GoogleFonts.dmSans(fontSize: 20, color: Colors.black),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/signup');
                    },
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
