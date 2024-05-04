import 'dart:typed_data';

import 'package:assignment1/stores_model.dart';
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
      join(path, 'StudentDB.db'),
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
            imagePath TEXT
          )
          '''
        );
        await db.execute('''
          CREATE TABLE stores (
            id INTEGER PRIMARY KEY,
            name TEXT,
            ImagePath TEXT,
            latitude REAL,
            longitude REAL
          )
        ''');
        await db.execute('''
          CREATE TABLE favorite_stores(
            id INTEGER PRIMARY KEY,
            store_id INTEGER,
            FOREIGN KEY (store_id) REFERENCES stores(id)
          )
    ''');
      },
      version: 2,
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
        'users', // Correct table name
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
  Future<int> saveProfilePhotoPath(String name, String photoPath) async {
    try {
      Database db = await database;
      return await db.update(
        'users',
        {'imagePath': photoPath},
        where: 'name = ?',
        whereArgs: [name],
      );
    } catch (e) {
      print('Error saving profile photo path: $e');
      return -1;
    }
  }
  Future<String?> getProfilePhotoPath(String name) async {
    try {
      Database db = await database;
      List<Map<String, dynamic>> result = await db.query(
        'users',
        columns: ['imagePath'],
        where: 'name = ?',
        whereArgs: [name],
      );
      if (result.isNotEmpty) {
        return result.first['imagePath'];
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching profile photo path: $e');
      return null;
    }
  }

  Future<Uint8List?> getProfilePhoto(String name) async {
    try {
      Database db = await database;
      List<Map<String, dynamic>> result = await db.query(
        'users',
        columns: ['imagePath'],
        where: 'name = ?',
        whereArgs: [name],
      );
      if (result.isNotEmpty) {
        return result.first['imagePath'];
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
        where: 'email = ?',
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

  Future<int> insertStore(Store store) async {
    try {
      final Database db = await database;
      return await db.insert('stores', store.toMap(excludeId: true)); // Exclude 'id' from the map
    } catch (e) {
      print('Error inserting store into database: $e');
      return -1;
    }
  }

  void addStores(DatabaseHelper databaseHelper) async {
    List<Store> stores = [
      Store(id:1,name: 'Awlad Ragab', latitude: 123.456, longitude: 789.012,ImagePath:"assets/store.jpeg" ),
      Store(id:2,name: 'City Stars', latitude: 456.789, longitude: 123.456,ImagePath:"assets/store.jpeg" ),
      Store(id:3,name: 'Carrfour', latitude: 789.012, longitude: 456.789,ImagePath:"assets/store.jpeg" ),
      Store(id:4,name: 'IKEA', latitude: 59.3508, longitude: 17.8776,ImagePath:"assets/store.jpeg" ),
      Store(id:5,name: 'Target', latitude: 44.978 , longitude:- 93.2638 ,ImagePath:"assets/store.jpeg" ),
      Store(id:6,name: 'Apple Store', latitude:37.3317 , longitude:-122.0307 ,ImagePath:"assets/store.jpeg" ),
    ];

    for (Store store in stores) {
      bool exists = await databaseHelper.storeExists(store.id); // Check if store already exists
      if (!exists) {
        await databaseHelper.insertStore(store);
      }
    }
  }
  Future<bool> storeExists(int storeId) async {
    try {
      final Database db = await database;
      List<Map<String, dynamic>> result = await db.query(
        'stores',
        where: 'id = ?',
        whereArgs: [storeId],
      );
      return result.isNotEmpty;
    } catch (e) {
      print('Error checking if store exists: $e');
      return false; // Return false in case of any error
    }
  }

  Future<List<Store>> getStores() async {
    try {
      final Database db = await database;
      final List<Map<String, dynamic>> maps = await db.query('stores');
      return List.generate(maps.length, (i) {
        return Store(
          id: maps[i]['id'],
          name: maps[i]['name'],
          latitude: maps[i]['latitude'],
          longitude: maps[i]['longitude'],
          ImagePath: maps[i]['ImagePath'],
        );
      });
    } catch (e) {
      print('Error fetching stores: $e');
      return [];
    }
  }
  Future<int> insertFavoriteStore(Store store) async {
    final db = await database;
    return await db.insert('favorite_stores', {'store_id': store.id});
  }
  Future<List<Store>> getFavoriteStores() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('favorite_stores');
    final List<int> storeIds = maps.map<int>((e) => e['store_id']).toList();
    final List<Store> favoriteStores = [];
    for (int id in storeIds) {
      final store = await getStoreById(id);
      if (store != null) {
        favoriteStores.add(store);
      }
    }
    return favoriteStores;
  }
  Future<Store?> getStoreById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
    await db.query('stores', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Store(
        id: maps[0]['id'],
        name: maps[0]['name'],
        latitude: maps[0]['latitude'],
        longitude: maps[0]['longitude'],
        ImagePath: maps[0]['ImagePath'],
      );
    }
    return null;
  }
  Future<int> deleteFavoriteStore(int storeId) async {
    final db = await database;
    return await db
        .delete('favorite_stores', where: 'store_id = ?', whereArgs: [storeId]);
  }


}

