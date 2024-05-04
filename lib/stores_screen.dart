import 'package:assignment1/stores_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Providers/store_provider.dart';
import 'favourite_store_screen.dart';

class AllStoresScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final storeProvider = Provider.of<StoreProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Stores'),
        actions: [
          IconButton(
            icon: const Icon(
                Icons.favorite,
                color: Colors.black
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoriteStoresScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: storeProvider.fetchStores(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return ListView.builder(
              itemCount: storeProvider.stores.length,
              itemBuilder: (context, index) {
                final store = storeProvider.stores[index];
                return ListTile(
                  leading: Image.asset(
                    store.ImagePath,
                    width: 70,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                  title: Text(store.name),
                  subtitle: Text(
                    'Lat: ${store.latitude}, Long: ${store.longitude}',
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            StoreDetailScreen(store: store),
                      ),
                    );
                  },
                  trailing: IconButton(
                    icon: store.isFavorite
                        ? const Icon(
                        Icons.favorite,
                        color: Colors.red,
                        )
                        : const Icon(
                      Icons.favorite_border,
                      color: Colors.red,
                        ),
                    onPressed: () {
                      storeProvider.toggleFavoriteStatus(store);
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
