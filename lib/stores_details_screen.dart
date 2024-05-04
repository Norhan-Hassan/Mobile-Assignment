import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Providers/store_provider.dart';
import 'package:assignment1/stores_model.dart';

class StoreDetailScreen extends StatelessWidget {
  final Store store;

  const StoreDetailScreen({Key? key, required this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final storeProvider = Provider.of<StoreProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(store.name),
      ),
      body: Center( // Center the column vertically
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              store.ImagePath,
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            Text(
              store.name,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
                'Lat: ${store.latitude}, Long: ${store.longitude}',
              style: TextStyle(
                fontSize: 17,
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Check if the store is already in the favorite list
                bool isFavorite = storeProvider.favoriteStores.any((favStore) => favStore.id == store.id);
                if (isFavorite) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('This store is already in favorites'),
                        backgroundColor: Colors.red, // Set color to red
                    ),
                  );
                } else {
                  // Add the store to favorites if not already in the list
                  storeProvider.addToFavorites(store);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Added to Favorites'),
                        backgroundColor: Colors.green, // Set color to red
                    ),
                  );
                }
              },
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.teal),
              ),
              child: Text(
                  'Add to Favorites',
                style: TextStyle(
                  fontSize: 20
                ),
              ),
           ),
          ]
        ),
      )
    );
  }
}
