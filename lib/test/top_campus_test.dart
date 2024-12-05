import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:univ_go/services/home/top_campus_provider.dart';

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

  test('Response Api PTN', () async {
    final provider = TopCampusProvider();
    var result = await provider.getSwasta();

    for (var campus in result) {
      campus.toJson().forEach((key, value) {
        print('$key: $value');
      });
    }
  });
}
