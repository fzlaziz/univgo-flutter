import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:univ_go/services/api_data_provider.dart';
import 'dart:math';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await dotenv.load(fileName: ".env");

  test('Fetch Campuses with Random Location', () async {
    // Generate random latitude and longitude within Indonesia's approximate bounds
    // Indonesia roughly spans from:
    // Latitude: -11.0 to 6.0
    // Longitude: 95.0 to 141.0
    final random = Random();

    // Generate random coordinates within Indonesia
    double latitude = -11.0 + random.nextDouble() * (6.0 - (-11.0));
    double longitude = 95.0 + random.nextDouble() * (141.0 - 95.0);

    print('Testing with coordinates:');
    print('Latitude: $latitude');
    print('Longitude: $longitude');

    final campusService = ApiDataProvider();

    try {
      var campuses = await campusService.getCampusesNearby(
          latitude: latitude, longitude: longitude);

      print('Number of campuses found: ${campuses.length}');

      // Print details of each campus
      for (var campus in campuses) {
        print('\nCampus Details:');
        print('ID: ${campus.id}');
        print('Name: ${campus.name}');
        print('Distance: ${campus.distance ?? "N/A"}');
        print('Logo Path: ${campus.logoPath ?? "No logo"}');
        print('Address Latitude: ${campus.addressLatitude}');
        print('Address Longitude: ${campus.addressLongitude}');
      }

      // Basic assertions
      expect(campuses, isNotNull);
      expect(campuses.length, greaterThan(0));
    } catch (e) {
      print('Error fetching campuses: $e');
      fail('Failed to fetch campuses');
    }
  });
}
