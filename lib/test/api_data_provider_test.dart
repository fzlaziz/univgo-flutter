import 'package:univ_go/api_data_provider.dart';
import 'package:test/test.dart';

void main() {
  test('Response Api Campus', () async {
    final provider = ApiDataProvider();
    var result = await provider.getCampus();
    for (var campus in result) {
      campus.toJson().forEach((key, value) {
        print('$key: $value');
      });
    }
  });
}
