import 'package:flutter/material.dart';
import '../database_helper.dart';
import '../stores_model.dart';

class StoreProvider extends ChangeNotifier {

  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  List<Store> _stores = []; // Initially empty list

  List<Store> get stores => _stores;

  List<Store> _favoriteStores = []; // New list for favorite stores

  List<Store> get favoriteStores => _favoriteStores;

  int? _userId; // User ID

  // Method to set the user ID
  void setUserId(int userId) {
    _userId = userId;
    // Fetch favorite stores for the user
    fetchFavoriteStores();
  }

  // Method to fetch stores from the database
  Future<void> fetchStores() async {
    // Fetch stores from the local database
    _stores = await _databaseHelper.getStores();
    notifyListeners();
  }

  // Method to fetch favorite stores from the database
  Future<void> fetchFavoriteStores() async {
    if (_userId != null) {
      _favoriteStores = await _databaseHelper.getFavoriteStores(_userId!);
      notifyListeners();
    }
  }

  // Method to add a store to favorites
  void addToFavorites(Store store) async {
    if (_userId != null) {
      await _databaseHelper.insertFavoriteStore(_userId!, store);
      fetchFavoriteStores(); // Fetch updated list of favorite stores
    }
  }

  // Method to remove a store from favorites
  void removeFromFavorites(Store store) async {
    if (_userId != null) {
      await _databaseHelper.deleteFavoriteStore(store.id, _userId!);
      fetchFavoriteStores(); // Fetch updated list of favorite stores
    }
  }

  // Method to toggle favorite status
  void toggleFavoriteStatus(Store store) {
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
