import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:passwordfield/passwordfield.dart';
import 'package:sign_button/sign_button.dart';

class SignScreen extends StatefulWidget {
  const SignScreen({super.key});

  @override
  State<SignScreen> createState() => _SignScreenState();
}

class _SignScreenState extends State<SignScreen> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset(
            'assets/images/buy-product-using-digital-wallet-2523247-2117423 1.png',
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
              controller: TextEditingController(),
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
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
              errorMessage: '''
- A uppercase letter
- A lowercase letter
- A digit
- A special character
- A minimum length of 8 characters
 ''',
              passwordDecoration: PasswordDecoration(
                hintStyle:
                    GoogleFonts.dmSans(fontSize: 20, color: Colors.black38),
              ),
              border: PasswordBorder(
                  border: OutlineInputBorder(
                      borderSide: const BorderSide(),
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
                onPressed: () {},
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
                child: Text(
                  'Sign In',
                  style: GoogleFonts.dmSans(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                )),
          ),
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
    );
  }
}
