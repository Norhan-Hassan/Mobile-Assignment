import 'dart:io';

import 'package:assignment1/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'edit_profile_screen.dart';

class User {
  final String name;
  final String email;
  final String gender;
  final String studentId;
  final String level;

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
        primarySwatch: Colors.indigo,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.indigo),
            textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(fontSize: 20, color: Colors.white)),
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(horizontal: 40, vertical: 12)),
          ),
        ),
      ),
      home: ProfileScreen(
        user: const User(
          name: "John Doe",
          email: "john.doe@example.com",
          gender: "Male",
          studentId: "123456",
          level: "3",
        ),
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  final User user;

  ProfileScreen({required this.user});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late User _currentUser;
  File? _image;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.user;
  }

  Future<void> _getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: source);

    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void updateUser(User newUser) {
    setState(() {
      _currentUser = newUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Profile'),
      ),
      body: ProfileBody(user: _currentUser, onUpdate: updateUser, image: _image, getImage: _getImage),
    );
  }
}

class ProfileBody extends StatelessWidget {
  final User user;
  final Function(User) onUpdate;
  final File? image;
  final Function(ImageSource) getImage;

  ProfileBody({required this.user, required this.onUpdate, required this.image, required this.getImage});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (image != null)
            CircleAvatar(
              radius: 50,
              backgroundImage: FileImage(image!),
            ),
          Text(
            'Name: ${user.name}',
            style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Email: ${user.email}',
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
          SizedBox(height: 8),
          Text(
            'Gender: ${user.gender}',
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
          SizedBox(height: 8),
          Text(
            'Student ID: ${user.studentId}',
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
          SizedBox(height: 8),
          Text(
            'Level: ${user.level}',
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Select Image Source'),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: [
                          GestureDetector(
                            child: Text('Gallery'),
                            onTap: () {
                              getImage(ImageSource.gallery);
                              Navigator.of(context).pop();
                            },
                          ),
                          SizedBox(height: 20),
                          GestureDetector(
                            child: Text('Camera'),
                            onTap: () {
                              getImage(ImageSource.camera);
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            child: Text(
              'Change Profile Photo',
              style: TextStyle(fontSize: 20),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfileScreen(user: user, onUpdate: onUpdate)),
              );
            },
            child: Text(
              'Edit Profile',
              style: TextStyle(fontSize: 20),
            ),
          ),
          SizedBox(height: 20), // Add spacing before the "Edit Profile" button
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SignupScreen()), // Navigate to SignupScreen
              );
            },
            child: Text(
              'Sign Up Again', // Change button text
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}