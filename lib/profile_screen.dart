import 'package:flutter/material.dart';

import 'edit_profile_screen.dart';

class User {
  final String name;
  final String email;
  final String gender; // Add gender field
  final String studentId; // Add student ID field
  final String level; // Add level field

  const User({
    required this.name,
    required this.email,
    required this.gender,
    required this.studentId,
    required this.level,
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Profile',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProfileScreen(
        user: const User(
          name: "Norhan Hassan",
          email: "2020@stu-fci.edu.eg",
          gender: "Female", // Add gender data
          studentId: "123456", // Add student ID data
          level: "3", // Add level data
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  final User user;

  ProfileScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Profile'),
      ),
      body: ProfileBody(user: user),
    );
  }
}

class ProfileBody extends StatelessWidget {
  final User user;

  ProfileBody({required this.user});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Text(
            user.name,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            user.email,
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 10),
          Text(
            'Gender: ${user.gender}', // Display gender
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 10),
          Text(
            'Student ID: ${user.studentId}', // Display student ID
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 10),
          Text(
            'Level: ${user.level}', // Display level
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfileScreen()),
              );
            },
            child: Text(
              'Edit Profile',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              textStyle: TextStyle(fontSize: 20),
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
