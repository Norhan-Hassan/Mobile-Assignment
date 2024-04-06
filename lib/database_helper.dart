import 'dart:typed_data';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._privateConstructor();
  DatabaseHelper._privateConstructor();
  static DatabaseHelper get instance => _instance;

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = await getDatabasesPath();
    return await openDatabase(
      join(path, 'your_database_name.db'),
      onCreate: (db, version) async {
        await db.execute(
          '''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY,
            name TEXT,
            email TEXT,
            gender TEXT,
            studentId TEXT,
            level TEXT,
            password TEXT,
            photo BLOB
          )
          '''
        );
      },
      version: 1,
    );
  }

  Future<int> insert(Map<String, dynamic> row) async {
    try {
      Database db = await database;
      return await db.insert('users', row);
    } catch (e) {
      print('Error inserting into database: $e');
      return -1;
    }
  }
  Future<int> updateRecordByName(String name, Map<String, dynamic> updatedRecord) async {
    try {
      Database db = await database;

      // Execute the update query
      int rowsAffected = await db.update(
        'student', // table name
        updatedRecord, // updated record data
        where: 'name = ?', // where clause to find the record to update
        whereArgs: [name], // arguments for where clause
      );

      return rowsAffected; // return the number of affected rows
    } catch (e) {
      print('Error updating record: $e');
      return -1; // return -1 to indicate error
    }
  }
  Future<int> saveProfilePhoto(String name, Uint8List photo) async {
    try {
      Database db = await database;
      return await db.update(
        'users',
        {'photo': photo},
        where: 'name = ?',
        whereArgs: [name],
      );
    } catch (e) {
      print('Error saving profile photo: $e');
      return -1;
    }
  }

  Future<Uint8List?> getProfilePhoto(String name) async {
    try {
      Database db = await database;
      List<Map<String, dynamic>> result = await db.query(
        'users',
        columns: ['photo'],
        where: 'name = ?',
        whereArgs: [name],
      );
      if (result.isNotEmpty) {
        return result.first['photo'];
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching profile photo: $e');
      return null;
    }
  }


  Future<bool> login(String name, String password) async {
    try {
      Database db = await database;
      List<Map<String, dynamic>> result = await db.query(
        'users',
        where: 'name = ? AND password = ?',
        whereArgs: [name, password],
      );
      return result.isNotEmpty;
    } catch (e) {
      print('Error during login: $e');
      return false;
    }
  }
  Future<Map<String, dynamic>?> getUserByName(String name) async {
  try {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'name = ?',
      whereArgs: [name],
    );
    if (result.isNotEmpty) {
      // User found, return user data
      return result.first;
    } else {
      return null; // User not found
    }
  } catch (e) {
    print('Error fetching user by name: $e');
    return null; // Return null in case of any error
  }
}
  Future<Map<String, dynamic>?> getUserByMail(String email) async {
    try {
      Database db = await database;
      List<Map<String, dynamic>> result = await db.query(
        'users',
        where: 'name = ?',
        whereArgs: [email],
      );
      if (result.isNotEmpty) {
        // User found, return user data
        return result.first;
      } else {
        return null; // User not found
      }
    } catch (e) {
      print('Error fetching user by email: $e');
      return null; // Return null in case of any error
    }
  }
}