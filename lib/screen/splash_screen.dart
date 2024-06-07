import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 10,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: screenSize.height * 0.3,
              width: screenSize.width * 0.9,
              fit: BoxFit.fitWidth,
            ),
            SizedBox(
              height: screenSize.height * 0.09,
            ),
            Container(
              alignment: Alignment.center,
              width: screenSize.width,
              height: screenSize.height * 0.2,
              child: Text(
                'Let’s fulfil your\ndaily needs with\nus',
                style: GoogleFonts.dmSans(
                  fontSize: screenSize.height * 0.05,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top: screenSize.height * 0.1),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff9F57F9),
                      foregroundColor: Colors.white,
                      elevation: 10.0,
                      fixedSize: const Size(201, 50)),
                  child: Text('Get Started',
                      style: GoogleFonts.dmSans(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )),
                ))
          ],
        ),
      ),
    );
  }
}
