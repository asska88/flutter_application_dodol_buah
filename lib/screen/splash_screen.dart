import 'dart:async';
import 'package:flutter/material.dart';
import 'package:myapp/screen/splash_screen_2.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Delay selama 3 detik (sesuaikan sesuai kebutuhan)
    Timer(
      const Duration(seconds: 3),
      () => Navigator.pushReplacement(
        context, 
        MaterialPageRoute(
          builder: (context) => const SplashScreen2(), // Ganti dengan halaman utama Anda
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white, 
        child: Center(
          child: Image.asset('assets/images/logo.png'),
        ),
      ),
    );
  }
}
