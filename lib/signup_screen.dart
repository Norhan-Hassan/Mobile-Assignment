import 'package:flutter/material.dart';
import 'signup_screen.dart';
import 'login_screen.dart';
import 'profile_screen.dart';
import 'Components/buildTextFormField.dart';
import 'Components/buildGenderSelection.dart';
import 'Components/buildSignupButton.dart';
import 'Components/buildLevelDropdown.dart';
import 'database_helper.dart';

class SignupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SignupBody(),
    );
  }
}

class SignupBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 30),
          Text(
            'Sign up',
            style: TextStyle(
              fontSize: 35,
              color: Colors.teal,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SignupForm(),
          ),
          Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 18,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginForm()),
                        );
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.teal, 
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
          
          SizedBox(height: 50),
        ],
      ),
    );
  }
}

class SignupForm extends StatefulWidget {
  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _studentIdController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  String? _selectedGender;
  String? _selectedLevel;

  List<String> _genders = ['Male', 'Female'];
  List<String> _levels = ['1', '2', '3', '4'];

  String? _validateEmail(String? value) {
    final RegExp regex = RegExp(r'^\d+@stud\.fci-cu\.edu\.eg$');
    if (!regex.hasMatch(value!)) {
      return 'Enter a valid student email address';
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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildTextFormField(
            controller: _nameController,
            labelText: 'Name',
            hintText: 'Enter your name',
            prefixIcon: Icons.person,
            validator: _validateName,
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.people,
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      buildGenderSelection(
                        genders: _genders,
                        selectedGender: _selectedGender,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedGender = value;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          buildTextFormField(
            controller: _studentIdController,
            labelText: 'Student ID',
            hintText: 'Enter your student ID',
            prefixIcon: Icons.confirmation_number,
            validator: _validateID,
          ),
          SizedBox(height: 10),
          buildTextFormField(
            controller: _emailController,
            labelText: 'Email',
            hintText: 'Enter your email',
            prefixIcon: Icons.email,
            validator: _validateEmail,
          ),
          SizedBox(height: 10),
          buildLevelDropdown(
            levels: _levels,
            selectedLevel: _selectedLevel,
            onChanged: (String? value) {
              setState(() {
                _selectedLevel = value;
              });
            },
          ),
          SizedBox(height: 10),
          buildTextFormField(
            controller: _passwordController,
            obscureText: true,
            labelText: 'Password',
            hintText: 'Enter your password',
            prefixIcon: Icons.lock,
            validator: _validatePassword,
          ),
          SizedBox(height: 10),
          buildTextFormField(
            controller: _confirmPasswordController,
            obscureText: true,
            labelText: 'Confirm Password',
            hintText: 'Re-enter your password',
            prefixIcon: Icons.lock,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm password';
              }
              if (value != _passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          buildSignupButton(_signup),
        ],
      ),
    );
  }

  void _signup() async {
    if (_formKey.currentState!.validate()) {
      bool result = await _saveUserData();
      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sign up successful!'),
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sign up failed. Please try again.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<bool> _saveUserData() async {
    Map<String, dynamic> userData = {
      'name': _nameController.text,
      'email': _emailController.text,
      'gender': _selectedGender,
      'studentId': _studentIdController.text,
      'level': _selectedLevel,
      'password': _passwordController.text,
    };

    bool userExists = await _checkUserExists(_nameController.text);
    if (userExists) {
      return false;
    }

    try {
      int userId = await DatabaseHelper.instance.insert(userData);
      if (userId > 0) {
        Map<String, dynamic>? userFromDB =
            await DatabaseHelper.instance.getUserByName(_nameController.text);
        if (userFromDB != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileScreen(
                user: User(
                  name: userFromDB['name'],
                  email: userFromDB['email'],
                  gender: userFromDB['gender'],
                  studentId: userFromDB['studentId'],
                  level: userFromDB['level'],
                  password: userFromDB['password'],
                ),
              ),
            ),
          );
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      print("Error saving user data: $e");
      return false;
    }
  }

  Future<bool> _checkUserExists(String name) async {
    Map<String, dynamic>? userData =
        await DatabaseHelper.instance.getUserByName(name);
    return userData != null;
  }
}
