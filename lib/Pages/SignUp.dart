// ignore_for_file: file_names, use_build_context_synchronously, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pharmaco/Services/auth_services.dart';
import 'package:pharmaco/components/Signup_button.dart';
import 'package:pharmaco/components/square_tile.dart';
import 'package:pharmaco/components/username_textfeild.dart';
import 'package:pharmaco/Pages/login.dart';

class SignUp extends StatefulWidget {
  SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final useremailController = TextEditingController();

  final usernameController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmpasswordController = TextEditingController();

  postDetailsToFirestore(String email, String rool) async {
    FirebaseFirestore fire = FirebaseFirestore.instance;
    CollectionReference ref = fire.collection('Users');
    ref.doc(email).set({'email': email, 'role': rool});
  }

  void SignUserUp() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    try {
      if (passwordController.text == confirmpasswordController.text) {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: useremailController.text,
              password: passwordController.text,
            )
            .then((value) =>
                {postDetailsToFirestore(useremailController.text, 'patient')})
            .catchError((e) {});
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: Colors.red[200],
                title: const Text(
                  "Passwords Do Not Match!",
                  style: TextStyle(color: Colors.white),
                ),
              );
            });
      }
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 212, 227, 241),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  const Image(
                      image: AssetImage('lib/images/pharmacologo.png'),
                      height: 229,
                      width: 229),

                  //user email
                  mytextfeild(
                    controller: useremailController,
                    hintText: 'Email',
                    obscureText: false,
                  ),

                  const SizedBox(height: 20),
                  //password textfeild
                  mytextfeild(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),

                  //confirmpassword2
                  mytextfeild(
                    controller: confirmpasswordController,
                    hintText: 'Confirm Password',
                    obscureText: true,
                  ),

                  const SizedBox(height: 25),

                  //Signup button
                  SignUp_button(onTap: SignUserUp),

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
                        'Already have an account?',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const login()),
                          );
                        },
                        child: const Text(
                          'Sign In!',
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
