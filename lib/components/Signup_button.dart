import 'package:flutter/material.dart';

class SignUp_button extends StatelessWidget{
  
  final Function()? onTap;
  const SignUp_button( {super.key,required this.onTap});

  @override
  Widget build(BuildContext){
    return GestureDetector(
      onTap: onTap,
      child: Container(
      padding: const EdgeInsets.all(25),
      margin: const EdgeInsets.symmetric(horizontal: 25),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 3, 91, 224),
        borderRadius: BorderRadius.circular(8), 
        ),
      child: const Center(
        child: Text(
          "Sign Up",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            ),
        ),
      ),
    ),
    );
  }
}