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
      appBar: AppBar(toolbarHeight: 10,),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/Modern_Black_Chair_PNG_Clipart 1.png',
            height: screenSize.height * 0.4,
            ),
            Padding(
              padding:  EdgeInsets.all(screenSize.height * 0.05),
              child: Text(
                '  Let’s fulfil your \ndaily needs with \n\t\t\t           us',
                style: GoogleFonts.dmSans(
                    fontSize: 40, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding:  EdgeInsets.only(top: screenSize.height * 0.05),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context,'/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff9F57F9),
                    foregroundColor: Colors.white,
                    elevation: 10.0,
                    fixedSize: const Size(201, 50)
                  ),
                  child: const Text('Get Started')),
            )
          ],
        ),
      ),
    );
  }
}
