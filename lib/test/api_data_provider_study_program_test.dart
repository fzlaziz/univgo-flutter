import 'package:univ_go/services/api_data_provider.dart';
import 'package:test/test.dart';

void main() {
  test('Response Api Study Program', () async {
    final provider = ApiDataProvider();
    var result = await provider.getStudyProgram("");
    for (var studyProgram in result) {
      studyProgram.toJson().forEach((key, value) {
        print('$key: $value');
      });
    }
  });
}
