
import 'package:assignment1/profile_screen.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'signup_screen.dart'; // Import the signup screen file

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Assignment 1',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      home: LoginScreen(),
      routes: {
        '/signup': (context) => SignupScreen(),
        '/profile': (context) => ProfileScreen(user: User(
          name: "Norhan Hassan",
          email: "2020@stu-fci.edu.eg",
          imagePath: "assets/default.jpg",
        )),
      },
    );
  }
}