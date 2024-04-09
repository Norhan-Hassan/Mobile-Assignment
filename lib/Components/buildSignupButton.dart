import 'package:flutter/material.dart';

Widget buildSignupButton(VoidCallback onPressed) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 35),
    child: MaterialButton(
      minWidth: double.infinity,
      onPressed: onPressed,
      child: Text('Signup'),
      color: Colors.teal,
      textColor: Colors.white,
    ),
  );
}