import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:univ_go/src/features/home/services/top_campus_provider.dart';

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

  group('TopCampusProvider Tests', () {
    test('Response Api Should Return All Campus Types', () async {
      final provider = TopCampusProvider();
      var result = await provider.getAllCampuses();

      // Test PTN data
      print('\nPTN Campuses:');
      for (var campus in result.ptn) {
        print('\nCampus Details:');
        campus.toJson().forEach((key, value) {
          print('$key: $value');
        });
      }

      // Test Politeknik data
      print('\nPoliteknik Campuses:');
      for (var campus in result.politeknik) {
        print('\nCampus Details:');
        campus.toJson().forEach((key, value) {
          print('$key: $value');
        });
      }

      // Test Swasta data
      print('\nSwasta Campuses:');
      for (var campus in result.swasta) {
        print('\nCampus Details:');
        campus.toJson().forEach((key, value) {
          print('$key: $value');
        });
      }

      // Add assertions
      expect(result.ptn, isNotEmpty);
      expect(result.politeknik, isNotEmpty);
      expect(result.swasta, isNotEmpty);
    });
  });
}
