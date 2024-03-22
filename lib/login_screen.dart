
import 'package:flutter/material.dart';
import 'signup_screen.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(
      // title: Text('Login Screen'),
      // ),
      body: LoginBody(),
    );
  }
}

class LoginBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Login',
          style: TextStyle(
            fontSize: 35,
            color: Colors.teal,
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: LoginForm(),
        ),
        SizedBox(height: 10),
        TextButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/signup'); // Navigate to signup screen
          },
          child: Text('Don\'t have an account? Create one'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/profile'); // Navigate to profile screen
          },
          child: Text('Show your profile'),
        ),
      ],
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter email';
                }
                return null;
              },
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  prefixIcon: Icon(Icons.password),
                  border: OutlineInputBorder(),
                ),
                validator: (value)
                {
                  if (value == null || value.isEmpty) {
                    return 'Please enter password';
                  }
                }
            ),
          ),
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35),
            child: MaterialButton(
              minWidth: double.infinity,
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Perform login
                  // You can access email and password using _emailController.text and _passwordController.text
                }
              },
              child: Text('Login'),
              color: Colors.teal,
              textColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}