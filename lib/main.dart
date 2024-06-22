import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myapp/service/firebase_options.dart';
import 'package:myapp/screen/login_screen.dart';
import 'package:myapp/screen/sign_screen.dart';
import 'package:myapp/screen/signup_screen.dart';
import 'package:myapp/module/cart_provider.dart';
import 'package:myapp/module/favorite_provider.dart';
import 'package:myapp/screen/admin_screen.dart';
import 'package:myapp/screen/cart_screen.dart';
import 'package:myapp/screen/checkout_screen.dart';
import 'package:myapp/screen/detail_product_screen.dart';
import 'package:myapp/screen/home_screen.dart';
import 'package:myapp/screen/splash_screen.dart';
import 'package:myapp/widget/user_profile_widget.dart';
import 'package:provider/provider.dart'; // Add this line at the top of your main.dart file

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => FavoriteProvider())
      ],
      child: MaterialApp(
        theme: ThemeData(
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff9F57F9)))),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignupScreen(),
          '/sign': (context) => const SignScreen(),
          '/home': (context) => const HomeScreen(),
          '/detail': (context) => const DetailProductScreen(),
          '/cart': (context) => const CartScreen(),
          '/profile': (context) => const UserProfileWidget(),
          '/admin': (context) => const AdminScreen(),
          '/checkout': (context) => const CheckoutScreen(),
        },
      ),
    ),
  );
}
