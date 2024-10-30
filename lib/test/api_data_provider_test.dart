import 'dart:io';
import 'package:univ_go/api_data_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  test('Response Api Campus', () async {
    SharedPreferences.setMockInitialValues({
      'userLatitude': -7.053075,
      'userLongitude': 110.4347715,
    });

    final provider = ApiDataProvider();
    var result = await provider.getCampus("");

    for (var campus in result) {
      campus.toJson().forEach((key, value) {
        print('$key: $value');
      });
    }
  });
}
