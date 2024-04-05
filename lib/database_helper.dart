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
            password TEXT
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
}