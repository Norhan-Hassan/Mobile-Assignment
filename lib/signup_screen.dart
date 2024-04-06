import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'login_screen.dart';
import 'profile_screen.dart';

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
            'Signup',
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
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginForm()),
              );
            },
            child: Text(
              'Already have an account? Login',
              style: TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
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
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Name',
              hintText: 'Enter your name',
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(),
            ),
            validator: _validateName,
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Container(
              child: Row(
                // Use Row instead of Column
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.people,
                  ),
                  SizedBox(width: 10), // Adjust spacing between icon and text
                  Column(
                    // Wrap Gender label and Radio buttons in a Column
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Gender',
                        style: TextStyle(
                          //  color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: _genders.map((gender) {
                          return Row(
                            children: [
                              Radio<String>(
                                value: gender,
                                groupValue: _selectedGender ?? '',
                                onChanged: (value) {
                                  setState(() {
                                    _selectedGender = value;
                                  });
                                },
                                activeColor:
                                    Colors.teal, // Customize active radio color
                              ),
                              Text(
                                gender,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(
                                  width:
                                      50), // Adjust spacing between radio buttons
                            ],
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              hintText: 'Enter your email',
              prefixIcon: Icon(Icons.email),
              border: OutlineInputBorder(),
            ),
            validator: _validateEmail,
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: _studentIdController,
            decoration: InputDecoration(
              labelText: 'Student ID',
              hintText: 'Enter your student ID',
              prefixIcon: Icon(Icons.confirmation_number),
              border: OutlineInputBorder(),
            ),
            validator: _validateID,
          ),
          SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: _selectedLevel,
            onChanged: (value) {
              setState(() {
                _selectedLevel = value;
              });
            },
            items: _levels.map((level) {
              return DropdownMenuItem<String>(
                value: level,
                child: Text(level),
              );
            }).toList(),
            decoration: InputDecoration(
              labelText: 'Level',
              hintText: 'Select level',
              prefixIcon: Icon(Icons.format_list_numbered),
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Enter your password',
              prefixIcon: Icon(Icons.lock),
              border: OutlineInputBorder(),
            ),
            validator: _validatePassword,
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              hintText: 'Re-enter your password',
              prefixIcon: Icon(Icons.lock),
              border: OutlineInputBorder(),
            ),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35),
            child: MaterialButton(
              minWidth: double.infinity,
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  // If form is valid, save user data to database
                  bool result = await _saveUserData();
                  if (result) {
                    // Sign up successful
                    // Navigate to the appropriate screen
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Sign up successful !'),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  } else {
                    // Error handling
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Sign up failed. Please try again.'),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                }
              },
              child: Text('Signup'),
              color: Colors.teal,
              textColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _saveUserData() async {
    // Construct user data
    Map<String, dynamic> userData = {
      'name': _nameController.text,
      'email': _emailController.text,
      'gender': _selectedGender,
      'studentId': _studentIdController.text,
      'level': _selectedLevel,
      'password': _passwordController.text,
    };

    // Check if a user with the same email already exists
    bool userExists = await _checkUserExists(_emailController.text);
    if (userExists) {
      return false; // Reject the data if user already exists
    }

    // Save user data to the database
    try {
      int userId = await DatabaseHelper.instance.insert(userData);
      if (userId > 0) {
        // Sign up successful
        // Fetch the user data from the database
        Map<String, dynamic>? userFromDB =
        await DatabaseHelper.instance.getUserByName(_nameController.text);
        if (userFromDB != null) {
          // Navigate to the profile screen with user data
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileScreen(
                user: User(
                  // Pass the user data retrieved from the database
                  name: userFromDB['name'],
                  email: userFromDB['email'],
                  gender: userFromDB['gender'],
                  studentId: userFromDB['studentId'],
                  level: userFromDB['level'],
                  password: userFromDB['password']
                  // Add other user data fields here
                ),
              ),
            ),
          );
          return true;
        } else {
          return false; // User data not found
        }
      } else {
        return false; // Sign up failed
      }
    } catch (e) {
      print("Error saving user data: $e");
      return false; // Sign up failed due to an error
    }
  }
  Future<bool> _checkUserExists( String email) async {
    // Check if a user with the same  email exists in the database
    Map<String, dynamic>? userData = await DatabaseHelper.instance.getUserByName(email);
    return userData != null;
  }
}
