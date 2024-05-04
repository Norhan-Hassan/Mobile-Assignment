import 'package:assignment1/favourite_store_screen.dart';
import 'package:assignment1/stores_details_screen.dart';
import 'package:assignment1/stores_screen.dart';
import 'package:flutter/material.dart';
import 'ApiHandler.dart';
import 'database_helper.dart';
import 'profile_screen.dart';
import 'signup_screen.dart';
import 'Components/buildTextFormField.dart';
import 'Components/buildSigninButton.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(top: 100, left: 20, right: 20, bottom: 20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontSize: 35,
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                buildTextFormField(
                  controller: _nameController,
                  labelText: 'Name',
                  hintText: 'Enter your name',
                  prefixIcon: Icons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                buildTextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  prefixIcon: Icons.password,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 30),
                buildSigninButton(() async {
                  if (_formKey.currentState!.validate()) {
                      ApiHandler().sendLoginRequest(
                        name: _nameController.text,
                        password: _passwordController.text,
                      );
                    bool loggedIn = await DatabaseHelper.instance.login(
                      _nameController.text,
                      _passwordController.text,
                    );
                    if (loggedIn) {
                      Map<String, dynamic>? userData =
                          await DatabaseHelper.instance
                              .getUserByName(_nameController.text);
                      if (userData != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Login successful!'),
                            duration: Duration(seconds: 3),
                            backgroundColor: Colors.green, // Set color to green
                          ),
                        );
                        /*
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(
                              user: User(
                                  name: userData['name'],
                                  email: userData['email'],
                                  gender: userData['gender'],
                                  studentId: userData['studentId'],
                                  level: userData['level'],
                                  password: userData['password']),
                            ),
                          ),

                        );

                         */
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context)=> AllStoresScreen())
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('User data not found.'),
                            backgroundColor: Colors.red, // Set color to red
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Login failed. Please check your credentials.'),
                          backgroundColor: Colors.red, // Set color to red
                          duration: Duration(seconds: 3),
                        ),
                      );
                    }
                  }
                }),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Don\'t have an account? ',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 18,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignupScreen()),
                        );
                      },
                      child: const Text(
                        'Sign up',
                        style: TextStyle(
                          color: Colors.teal, // Change the color to teal
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
