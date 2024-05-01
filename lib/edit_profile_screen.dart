import 'dart:io';
import 'package:flutter/material.dart';
import 'package:assignment1/profile_screen.dart';
import 'package:assignment1/database_helper.dart';
import 'package:flutter/services.dart';
import 'ApiHandler.dart';

class EditProfileScreen extends StatefulWidget {
  final User user; // Accept the user object as a parameter
  final Function(User) onUpdate;
  EditProfileScreen({required this.user, required this.onUpdate});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _levelController = TextEditingController();
  TextEditingController _idController = TextEditingController();
  File? _image;
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  final ApiHandler _apiHandler = ApiHandler();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.user.name;
    _emailController.text = widget.user.email;
    _levelController.text = widget.user.level;
    _idController.text = widget.user.studentId;
    _passwordController.text = widget.user.password;
    _loadProfilePhoto();
  }

  Future<void> _loadProfilePhoto() async {
    String? photoPath = await _databaseHelper.getProfilePhotoPath(widget.user.name);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_image != null)
                  CircleAvatar(
                    radius: 80,
                    backgroundImage: FileImage(_image!),
                  ),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'New Name'),
                  validator: _validateName,
                ),
                TextFormField(
                  controller: _idController,
                  decoration: InputDecoration(labelText: 'New ID'),
                  validator: _validateID,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'New Email'),
                  validator: _validateEmail,
                ),
                TextFormField(
                  controller: _levelController,
                  decoration: InputDecoration(labelText: 'New Level'),
                  validator: _validateLevel,
                ),
                TextFormField(
                  obscureText: true,
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'New Password'),
                  validator: _validatePassword,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      User updatedUser = User(
                        name: _nameController.text,
                        email: _emailController.text,
                        gender: widget.user.gender,
                        studentId: _idController.text,
                        level: _levelController.text,
                        password: _passwordController.text,
                      );
                      // Update user data via API
                      try {
                        await _apiHandler.updateUser(updatedUser.name, updatedUser.toMap());
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Profile updated successfully!'),
                            duration: Duration(seconds: 3),
                            backgroundColor: Colors.green,
                          ),
                        );
                        // Update the local database after API update
                        await _databaseHelper.updateRecordByName(widget.user.name, updatedUser.toMap());
                        if (_image != null) {
                          await _databaseHelper.saveProfilePhotoPath(updatedUser.name, _image!.path);
                        }
                        widget.onUpdate(updatedUser);
                        Navigator.pop(context);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to update profile. Please try again.'),
                            duration: Duration(seconds: 3),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  child: Text(
                    'Save Changes',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.teal),
                    textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _validateEmail(String? value) {
    final RegExp regex = RegExp(r'^\d+@stud\.fci-cu\.edu\.eg$');
    if (!regex.hasMatch(value!) || !value.endsWith('@stud.fci-cu.edu.eg')) {
      return 'Email should be in the format: studentID@stud.fci-cu.edu.eg';
    }
    // Split the email address to get the part before @
    final emailParts = value.split('@');
    final studentIdFromEmail = emailParts[0];

    // Check if the part before @ matches the entered student ID
    if (studentIdFromEmail != _idController.text) {
      return 'please, write id part correctly';
    }
    return null;
  }

  String? _validateLevel(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter level';
    }
    int level;
    try {
      level = int.parse(value);
    } catch (e) {
      return 'Invalid level';
    }
    if (level < 1 || level > 4) {
      return 'Level must be between 1 and 4';
    }
    return null;
  }

  String? _validateID(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter student ID';
    }
    return null;
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter name';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value!.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }
}
