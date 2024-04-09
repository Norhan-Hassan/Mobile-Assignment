import 'package:flutter/material.dart';

Widget buildSigninButton(VoidCallback onPressed) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 35),
    child: MaterialButton(
      minWidth: double.infinity,
      onPressed: onPressed,
      child: Text('Login'),
      color: Colors.teal,
      textColor: Colors.white,
    ),
  );
}