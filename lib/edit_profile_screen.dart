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
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'New Password'),
            ),
            TextField(
              controller: _levelController,
              decoration: InputDecoration(labelText: 'Level'),
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