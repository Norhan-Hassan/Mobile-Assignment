import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'stores_model.dart';

class DistanceScreen extends StatefulWidget {
  final Store favoriteStore;

  DistanceScreen({required this.favoriteStore});

  @override
  _DistanceScreenState createState() => _DistanceScreenState();
}

class _DistanceScreenState extends State<DistanceScreen> {
  Position? _currentPosition;
  double? _distanceInMeters;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _currentPosition = position;
      _calculateDistance();
    });
  }

  void _calculateDistance() {
    if (_currentPosition != null &&
        widget.favoriteStore.latitude != null &&
        widget.favoriteStore.longitude != null) {
      double distance = Geolocator.distanceBetween(
        _currentPosition!.latitude!,
        _currentPosition!.longitude!,
        widget.favoriteStore.latitude!,
        widget.favoriteStore.longitude!,
      );
      setState(() {
        _distanceInMeters = distance;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Distance to Favorite Store'),
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/location.jpg',
                width: 200,
                height: 300,
                fit: BoxFit.cover, // Ensure the image covers the entire container
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  _distanceInMeters != null
                      ? 'Distance to ${widget.favoriteStore.name}: ${(_distanceInMeters! / 1000).toStringAsFixed(2)} km'
                      : 'Calculating distance...',
                  style: TextStyle(
                    fontSize: 19,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
