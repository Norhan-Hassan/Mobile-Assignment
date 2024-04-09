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
      ), debugShowCheckedModeBanner: false,
      home: ProfileScreen(
        user: const User(
          name: "John Doe",
          email: "123456@stud.fci-cu.edu.eg",
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
        _image = File('assets/default.jpg');
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

          Column(
            children: [
              SizedBox(height: 20),
              _buildProfileInfo('Name', user.name),
              SizedBox(height: 20),
              _buildProfileInfo('Email', user.email),
              SizedBox(height: 20),
              _buildProfileInfo('Gender', user.gender),
              SizedBox(height: 20),
              _buildProfileInfo('Student ID', user.studentId),
              SizedBox(height: 20),
              _buildProfileInfo('Level', user.level),
              SizedBox(height: 20),
            ],
          ),

          /*
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
          //

           */
          Center(
            child: SizedBox(
              width: double.infinity, // Make button take the full width of the screen
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EditProfileScreen(user: user, onUpdate: onUpdate),
                    ),
                  );
                },
                child: Text(
                  'Edit Profile',
                  style: TextStyle(color: Colors.white), // Set font color to white
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal, // Set background color to teal
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          // Link to return to sign up screen
          Center(
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignupScreen(), // Navigate to signup screen
                  ),
                );
              },
              child: Text(
                'Return to Sign Up',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildProfileInfo(String label, String value) {
    return Row(
      children: [
        Text(
          label + ': ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ],
    );
  }


/*
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
  */
  //


}
/*
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
*/