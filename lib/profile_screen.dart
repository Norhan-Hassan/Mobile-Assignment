import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'database_helper.dart';
import 'edit_profile_screen.dart';
import 'signup_screen.dart';

class User {
  final String name;
  final String email;
  final String gender;
  final String studentId;
  final String level;
  final String password;
  final String? imagePath;

  const User({
    required this.name,
    required this.email,
    required this.gender,
    required this.studentId,
    required this.level,
    required this.password,
    this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'gender': gender,
      'studentId': studentId,
      'level': level,
      'password': password,
    };
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Profile',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: ProfileScreen(
        user: const User(
          name: "John Doe",
          email: "john.doe@example.com",
          gender: "Male",
          studentId: "123456",
          level: "3",
          password: "12345678",
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
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.user;
    _loadProfilePhoto();
  }

  Future<void> _loadProfilePhoto() async {
    String? photoPath =
        await _databaseHelper.getProfilePhotoPath(_currentUser.name);
    if (photoPath != null) {
      setState(() {
        _image = File(photoPath);
      });
    } else {
      setState(() {
        _image = File('assets/default.png');
      });
    }
  }

  Future<void> _getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: source);

    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
        _saveProfilePhoto();
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _saveProfilePhoto() async {
    if (_image != null) {
      String imagePath = _image!.path;
      await _databaseHelper.saveProfilePhotoPath(_currentUser.name, imagePath);
    }
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
      body: ProfileBody(
        user: _currentUser,
        onUpdate: updateUser,
        image: _image,
        getImage: _getImage,
      ),
    );
  }
}
class ProfileBody extends StatelessWidget {
  final User user;
  final Function(User) onUpdate;
  final File? image;
  final Function(ImageSource) getImage;

  ProfileBody({
    required this.user,
    required this.onUpdate,
    required this.image,
    required this.getImage,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                if (image != null)
                  CircleAvatar(
                    radius: 70,
                    backgroundImage: FileImage(image!),
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
                    'Change Photo',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          _buildProfileInfo('Name', user.name),
          _buildProfileInfo('Email', user.email),
          _buildProfileInfo('Gender', user.gender),
          _buildProfileInfo('Student ID', user.studentId),
          _buildProfileInfo('Level', user.level),
          SizedBox(height: 20),
          MyCustomButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      EditProfileScreen(user: user, onUpdate: onUpdate),
                ),
              );
            },
            text: 'Edit Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }
}

class MyCustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  MyCustomButton({required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: MaterialButton(
        minWidth: double.infinity,
        onPressed: onPressed,
        child: Text(text),
        color: Colors.teal,
        textColor: Colors.white,
      ),
    );
  }
}
