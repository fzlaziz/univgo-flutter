import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationService {
  double? userLatitude;
  double? userLongitude;
  BuildContext? context;

  LocationService([this.context]);

  Future<bool> hasLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  Future<void> loadUserLocation() async {
    final prefs = await SharedPreferences.getInstance();
    userLatitude = prefs.getDouble('userLatitude');
    userLongitude = prefs.getDouble('userLongitude');

    if (userLatitude == null || userLongitude == null) {
      await _getCurrentPosition();
    }
  }

  Future<void> updateLocation() async {
    await _getCurrentPosition();
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;

    try {
      LocationSettings locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      );
      Position position = await Geolocator.getCurrentPosition(
          locationSettings: locationSettings);

      userLatitude = position.latitude;
      userLongitude = position.longitude;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('userLatitude', position.latitude);
      await prefs.setDouble('userLongitude', position.longitude);
    } catch (e) {
      debugPrint('Error getting current position: $e');
      rethrow;
    }
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled && context != null) {
        ScaffoldMessenger.of(context!).showSnackBar(const SnackBar(
            content:
                Text('Izin Lokasi dimatikan, mohon aktifkan izin lokasi.')));
        return false;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied && context != null) {
          ScaffoldMessenger.of(context!).showSnackBar(
              const SnackBar(content: Text('Izin Lokasi ditolak.')));
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever && context != null) {
        ScaffoldMessenger.of(context!).showSnackBar(const SnackBar(
            content: Text(
                'Izin Lokasi ditolak secara permanen, buka pengaturan untuk mengaktifkan izin lokasi.')));
        return false;
      }

      return permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always;
    } catch (e) {
      debugPrint('Error handling location permission: $e');
      return false;
    }
  }
}
