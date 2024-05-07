
import 'package:assignment1/stores_details_screen.dart';
import 'package:assignment1/stores_screen.dart';

import 'Providers/store_provider.dart';
import 'database_helper.dart';
import 'favourite_store_screen.dart';
import 'profile_screen.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  _databaseHelper.addStores(_databaseHelper);

  runApp(
    ChangeNotifierProvider(
      create: (context) => StoreProvider(), // Provide the StoreProvider
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home:  LoginForm(),
      routes: {
        '/signup': (context) => SignupScreen(),
        //'/store': (context) => AllStoresScreen(),
        //'/favorite_stores': (context) => FavoriteStoresScreen(),
      },
    );
  }
}