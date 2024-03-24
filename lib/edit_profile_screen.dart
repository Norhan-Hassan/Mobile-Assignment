import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}
class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController= TextEditingController();
  TextEditingController _levelController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              obscureText: true,
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
                validator: _validateName,
            ),
            TextFormField(
              obscureText: true,
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              validator: _validateEmail,
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
                // Save profile changes
                saveProfile();
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
  String? _validateEmail(String? value) {
    final RegExp regex = RegExp(r'^\d+@stud\.fci-cu\.edu\.eg$');
    if (!regex.hasMatch(value!)) {
      return 'Enter a valid student email address';
    }
    return null;
  }
  String? _validateID(String? value)
  {
    if (value == null || value.isEmpty) {
      return 'Please enter student ID';
    }
    return null;
  }
  String? _validateName(String? value)
  {
    if (value == null || value.isEmpty) {
      return 'Please enter name';
    }
    return null;
  }
  String? _validatePassword(String? value)
  {
    if (value == null || value.isEmpty) {
      return 'Please enter password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }
  void saveProfile() {
    // Implement saving profile logic here
    String name = _nameController.text;
    String email = _emailController.text;
    String level = _levelController.text;
    String pass=_passwordController.text;

    // Perform actions to save the profile
    // For instance, you can make API calls to update the profile on the server

    // After saving, you might want to navigate back to the previous screen
    Navigator.pop(context);
  }
}