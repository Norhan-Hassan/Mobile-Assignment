import 'package:flutter/material.dart';
import '../database_helper.dart';
import '../stores_model.dart';

class StoreProvider extends ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  List<Store> _stores = []; // Initially empty list

  List<Store> get stores => _stores;


  List<Store> _favoriteStores = []; // New list for favorite stores

  List<Store> get favoriteStores => _favoriteStores;

  // Method to fetch stores from the database
  Future<void> fetchStores() async {
    // Fetch stores from the local database
    _stores = await _databaseHelper.getStores();
    _favoriteStores = await _databaseHelper.getFavoriteStores();
    notifyListeners();
  }
  // Method to add a store to favorites
  void addToFavorites(Store store) async {
    _favoriteStores.add(store);
    await _databaseHelper.insertFavoriteStore(store);
    notifyListeners();
  }
  void removeFromFavorites(Store store) async {
    _favoriteStores.remove(store);
    await _databaseHelper.deleteFavoriteStore(store.id);
    notifyListeners();
  }
  // Method to toggle favorite status
  void toggleFavoriteStatus(Store store) async {
    if (_favoriteStores.contains(store)) {
       removeFromFavorites(store);
    } else {
      addToFavorites(store);
      }
    }

  // Method to set the selected store
  Store? _selectedStore; // Define selected store

  Store? get selectedStore => _selectedStore; // Getter for selected store

  // Method to set the selected store and its distance
  void setSelectedStore(Store store) {
    _selectedStore = store;
    notifyListeners();
  }

}
