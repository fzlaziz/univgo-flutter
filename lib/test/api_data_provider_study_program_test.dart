import 'package:univ_go/src/features/search/services/search_data_provider.dart';
import 'package:test/test.dart';

void main() {
  test('Response Api Study Program', () async {
    final provider = SearchDataProvider();
    var result = await provider.getStudyProgram("");
    for (var studyProgram in result) {
      studyProgram.toJson().forEach((key, value) {
        print('$key: $value');
      });
    }
  });
}
