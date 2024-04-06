import 'package:assignment1/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:assignment1/database_helper.dart';

// EditProfileScreen
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

  DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with user data
    _nameController.text = widget.user.name;
    _emailController.text = widget.user.email;
    _levelController.text = widget.user.level;
    _idController.text = widget.user.studentId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: _validateName,
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
                controller: _idController,
                decoration: InputDecoration(labelText: 'New ID'),
                validator: _validateID,
              ),
              TextFormField(
                obscureText: true,
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'New Password'),
                validator: _validatePassword,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Create a new User object with updated details
                  User updatedUser = User(
                    name: _nameController.text,
                    email: _emailController.text,
                    gender: widget.user.gender,
                    studentId: _idController.text,
                    level: _levelController.text,
                  );
                  // Call the onUpdate function to notify ProfileScreen
                  widget.onUpdate(updatedUser);
                  // Navigate back to the ProfileScreen
                  Navigator.pop(context);
                },
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

  String? _validateEmail(String? value) {
    final RegExp regex = RegExp(r'^\d+@stud\.fci-cu\.edu\.eg$');
    if (!regex.hasMatch(value!)) {
      return 'Enter a valid student email address';
    }
    return null;
  }

  String? _validateLevel(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter student level';
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
    if (value == null || value.isEmpty) {
      return 'Please enter password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

