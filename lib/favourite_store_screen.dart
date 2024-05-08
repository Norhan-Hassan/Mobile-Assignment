// favorite_stores_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Providers/store_provider.dart';
import 'stores_model.dart';
import 'Distancescreen.dart'; // Import the DistanceScreen

class FavoriteStoresScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Stores'),
      ),
      body: Consumer<StoreProvider>(
        builder: (context, storeProvider, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'Favorite Stores',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: storeProvider.favoriteStores.length,
                  itemBuilder: (context, index) {
                    final store = storeProvider.favoriteStores[index];
                    return ListTile(
                      title: Text(store.name),
                      subtitle: Text('Lat: ${store.latitude}, Long: ${store.longitude}'),
                      trailing: IconButton(
                        icon: const Icon(
                          //Icons.favorite,
                          Icons.location_on,
                          color: Colors.blue,
                          //color: Colors.red,
                        ),

                        onPressed: () {

                          // Navigate to the DistanceScreen when the favorite store is tapped
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DistanceScreen(favoriteStore: store),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
