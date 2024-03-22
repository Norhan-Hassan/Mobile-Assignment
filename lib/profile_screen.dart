import 'package:flutter/material.dart';

import 'edit_profile_screen.dart';
class User
{
  final String imagePath;
  final String name;
  final String email;

  const User({
    required this.imagePath,
    required this.name,
    required this.email,
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
      home: ProfileScreen(user: User(
        name: "Norhan Hassan",
        email: "2020@stu-fci.edu.eg",
        imagePath:"assets/default.jpg",
      )),
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
          CircleAvatar(
            radius: 100,
            child: ClipOval(
              child: Image.asset(
                 user.imagePath,
                 fit: BoxFit.cover,
                 width: 200, // Adjust the width as needed
                 height: 200, // Adjust the height as needed
             ),
            ),
          ),
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