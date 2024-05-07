// distance_screen.dart
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_distanceInMeters != null)
              Text(
                'Distance to ${widget.favoriteStore.name}: ${(_distanceInMeters! / 1000).toStringAsFixed(2)} km',
                style: TextStyle(fontSize: 18),
              ),
            if (_distanceInMeters == null)
              CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
