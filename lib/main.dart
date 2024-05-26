import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myapp/auth/firebase_options.dart';
import 'package:myapp/auth/login_screen.dart';
import 'package:myapp/auth/sign_screen.dart';
import 'package:myapp/auth/signup_screen.dart';
import 'package:myapp/screen/home_screen.dart';
import 'package:myapp/screen/splash_screen.dart';

void main () async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp( MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {'/' : (context)=> const SplashScreen(),
    '/login' : (context)=> const LoginScreen(),
    '/signup' : (context)=>  const SignupScreen(),
    '/sign' : (context)=> const SignScreen(),
    '/home' : (context)=> const HomeScreen(),
    },
    
  ));
}
