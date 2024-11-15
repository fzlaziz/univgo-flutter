import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationService {
  double? userLatitude;
  double? userLongitude;
  BuildContext context;

  LocationService(this.context);

  Future<void> loadUserLocation() async {
    final prefs = await SharedPreferences.getInstance();
    userLatitude = prefs.getDouble('userLatitude');
    userLongitude = prefs.getDouble('userLongitude');

    if (userLatitude == null || userLongitude == null) {
      await _getCurrentPosition();
      userLatitude = prefs.getDouble('userLatitude');
      userLongitude = prefs.getDouble('userLongitude');
    }
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;

    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      userLatitude = position.latitude;
      userLongitude = position.longitude;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('userLatitude', position.latitude);
      await prefs.setDouble('userLongitude', position.longitude);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Izin Lokasi dimatikan, mohon aktifkan izin lokasi.')));
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Izin Lokasi ditolak.')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Izin Lokasi ditolak secara permanen, buka pengaturan untuk mengaktifkan izin lokasi.')));
      return false;
    }
    return true;
  }
}
