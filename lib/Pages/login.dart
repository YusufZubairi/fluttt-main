// ignore_for_file: camel_case_types, non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pharmaco/Pages/forgot.dart';
import 'package:pharmaco/Services/auth_services.dart';
import 'package:pharmaco/Pages/SignUp.dart';
import 'package:pharmaco/components/login_button.dart';
import 'package:pharmaco/components/square_tile.dart';
import 'package:pharmaco/components/username_textfeild.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void loguserin(BuildContext context) async {
    String email = emailController.text;
    String password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      // Call the empty() function if email or password is null or empty
      empty();
      return;
    }

    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'invalid-credential') {
        WrongEmailMessage();
      } else if (e.code == 'invalid-email') {
        WrongPasswordMessage();
      } else if (e.code == 'missing-password') {
        MissingPasswordMessage();
      }
    }
  }

  void WrongEmailMessage() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.red[200],
            title: const Text(
              "Incorrect Credentials Entered!",
              style: TextStyle(color: Colors.white),
            ),
          );
        });
  }

  void empty() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.red[200],
            title: const Text(
              "Email & Password cannot be empty!",
              style: TextStyle(color: Colors.white),
            ),
          );
        });
  }

  void WrongPasswordMessage() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.red[200],
            title: const Text(
              "Incorrect email address!",
              style: TextStyle(color: Colors.white),
            ),
          );
        });
  }

  void MissingPasswordMessage() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.red[200],
            title: const Text(
              "Password missing!",
              style: TextStyle(color: Colors.white),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor:Color.fromARGB(255, 217, 226, 235),
        backgroundColor: const Color.fromARGB(255, 212, 227, 241),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),

                  // const Icon(
                  //   Icons.lock,
                  //   size: 100,
                  // ),
                  const Image(
                      image: AssetImage('lib/images/pharmacologo.png'),
                      height: 229,
                      width: 229),

                  //Welcome Text
                  // Text(
                  //   'Welcome Back FUCKER',
                  //   style: TextStyle(
                  //     color: Colors.grey[700],
                  //     fontSize: 8,
                  //   ),
                  // ),
                  //username text feild
                  mytextfeild(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                  ),

                  const SizedBox(height: 10),
                  //password textfeild
                  mytextfeild(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),

                  //forgot password
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const forgot()));
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'forgot password?',
                          )
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  //Login button
                  LoginButton(onTap: () => loguserin(context)),

                  const SizedBox(height: 20),

                  // OR CONTINUE WITH
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'Or continue with',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  //Google Sign Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Square_tile(
                          onTap: () async {
                            AuthService().SignInWithGoogle();
                          },
                          imagePath: 'lib/images/GoogleLogo.png'),
                    ],
                  ),

                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Not a Member?',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignUp()),
                          );
                        },
                        child: const Text(
                          'Register Now!',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
