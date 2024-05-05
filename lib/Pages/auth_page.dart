// ignore_for_file: camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pharmaco/Pages/SignUp.dart';
import 'package:pharmaco/components/BottomNav.dart';
import 'package:pharmaco/components/PharmaNav.dart';
import 'package:pharmaco/components/splash_screen.dart';

class auth_page extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const auth_page({Key? key});

  @override
  State<auth_page> createState() => _auth_pageState();
}

class _auth_pageState extends State<auth_page> {
  void route(BuildContext context, User user) {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(user.email)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        if (documentSnapshot.get('role') == "Pharmacist") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const splash(nextScreen: PharmaNav()),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const splash(nextScreen: BottomNav()),
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // User logged in?
          if (snapshot.hasData) {
            User user = snapshot.data!;
            route(context, user);
          } else if (snapshot.hasError) {
            // Weird error
            return const Center(child: Text('Error Has Occurred!'));
          }
          // User not logged in, show SignUp page
          return SignUp();
        },
      ),
    );
  }
}
