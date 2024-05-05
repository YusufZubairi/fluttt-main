// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pharmaco/Pages/SignUp.dart';

class forgot extends StatefulWidget {
  const forgot({super.key});

  @override
  State<forgot> createState() => _forgotState();
}

class _forgotState extends State<forgot> {
  TextEditingController mail = new TextEditingController();

  String email = "";

  final _formkey = GlobalKey<FormState>();

  resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
        "Password Reset Email has been sent. Please check your email!",
        style: TextStyle(fontSize: 19.0),
      )));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
          "No User was found!",
          style: TextStyle(fontSize: 19.0),
        )));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          const SizedBox(
            height: 30.0,
          ),
          Container(
            alignment: Alignment.topCenter,
            child: const Text("Password Recovery",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 50.0),
          const Text(
            "Enter Your Email",
            style: TextStyle(
                color: Colors.white,
                fontSize: 30.0,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40.0),
          Expanded(
              child: Form(
                key: _formkey,
                  child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: ListView(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 10.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white70, width: 2.0),
                      borderRadius: BorderRadius.circular(30)),
                  child: TextFormField(
                    controller: mail,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Email';
                      }
                      return null;
                    },
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                        hintText: "Email",
                        hintStyle:
                            TextStyle(fontSize: 18.0, color: Colors.white70),
                        prefixIcon: Icon(Icons.person,
                            color: Colors.white70, size: 30.0),
                        border: InputBorder.none),
                  ),
                ),
                const SizedBox(
                  height: 40.0,
                ),
                GestureDetector(
                  onTap: (){
                    if(_formkey.currentState!.validate()){
                      setState(() {
                        email = mail.text;
                      });
                      resetPassword();
                    }
                  },
                  child: Container(
                    width: 140,
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: const Center(
                      child: Text(
                        "Send Email",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(color: Colors.white54, fontSize: 18.0),
                    ),
                    const SizedBox(
                      width: 15.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUp()));
                      },
                      child: const Text(
                        "Create Now!",
                        style: TextStyle(
                            color: Color.fromARGB(225, 184, 166, 6),
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500),
                      ),
                    )
                  ],
                )
              ],
            ),
          ))),
          const SizedBox(height: 50.0),
        ],
      ),
    );
  }
}
