import 'dart:ui';
import 'package:provider/provider.dart';

import 'database_helper.dart';
class Store {
  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final String ImagePath;
  bool isFavorite; // Add isFavorite property


  Store({required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.ImagePath,
    this.isFavorite = false,
  });
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  // Convert a Store object into a Map object

// Update the Store class to include an optional parameter 'excludeId' in the toMap() method
  Map<String, dynamic> toMap({bool excludeId = false}) {
    var map = {
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'ImagePath': ImagePath,
    };
    if (!excludeId) {
      map['id'] = id;
    }
    return map;
  }
  // Convert a Map object into a Store object
  factory Store.fromMap(Map<String, dynamic> map) {
    return Store(
      id: map['id'],
      name: map['name'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      ImagePath: map['ImagePath']
    );
  }






}