import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myapp/auth/firebase_options.dart';
import 'package:myapp/auth/login_screen.dart';
import 'package:myapp/auth/sign_screen.dart';
import 'package:myapp/auth/signup_screen.dart';
import 'package:myapp/module/cart_provider.dart';
import 'package:myapp/screen/admin_screen.dart';
import 'package:myapp/screen/detail_product_screen.dart';
import 'package:myapp/screen/home_screen.dart';
import 'package:myapp/screen/splash_screen.dart';
import 'package:myapp/widget/user_profile_widget.dart';
import 'package:provider/provider.dart'; // Add this line at the top of your main.dart file

void main () async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp( ChangeNotifierProvider(
    create: (context) => CartProvider(),
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {'/' : (context)=> const SplashScreen(),
      '/login' : (context)=> const LoginScreen(),
      '/signup' : (context)=>  const SignupScreen(),
      '/sign' : (context)=> const SignScreen(),
      '/home' : (context)=> const HomeScreen(),
      '/detail' : (context)=>  const DetailProductScreen(),
      '/profile' : (context)=>  const UserProfileWidget(),
      '/admin' : (context)=>  const AdminScreen(),
      },
      
    ),
  ));
}
