import 'package:flutter/material.dart';
import 'edit_profile_screen.dart';

class User {
  final String name;
  final String email;
  final String gender;
  final String studentId;
  final String level;
  //final String password;


  const User({
    required this.name,
    required this.email,
    required this.gender,
    required this.studentId,
    required this.level,
    //required this.password,
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Profile',
      theme: ThemeData(
        primarySwatch: Colors.indigo, // Change primary color to indigo
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.indigo), // Set button background color
            textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(fontSize: 20, color: Colors.white)), // Set button text style
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(horizontal: 40, vertical: 12)),
          ),
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

  @override
  void initState() {
    super.initState();
    _currentUser = widget.user;
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
      body: ProfileBody(user: _currentUser, onUpdate: updateUser),
    );
  }
}

class ProfileBody extends StatelessWidget {
  final User user;
  final Function(User) onUpdate;

  ProfileBody({required this.user, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Name: ${user.name}',
            style: TextStyle(fontSize: 20, color: Colors.black), // Larger font size, indigo color, bold
          ),
          SizedBox(height: 8),
          Text(
            'Email: ${user.email}',
            style: TextStyle(fontSize: 18, color: Colors.black), // Smaller font size, indigo color
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfileScreen(user: user, onUpdate: onUpdate)),
              );
            },
            child: Text(
              'Edit Profile',
              style: TextStyle(fontSize: 20), // Larger font size for button text
            ),
          ),
        ],
      ),
    );
  }
}
