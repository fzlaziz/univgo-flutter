import 'package:http/http.dart';
import 'package:univ_go/models/campus_detail/campus_detail.dart';
import 'package:univ_go/models/campus_review/campus_review.dart';
import 'package:univ_go/models/study_program/study_program.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProfileCampusProvider {
  String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost:8000';
  String awsUrl = dotenv.env['AWS_URL'] ?? 'http://localhost:8000';

  Future<CampusDetailResponse> getCampusDetail(int campusId) async {
    var headers = <String, String>{
      "Content-Type": 'application/json; charset=UTF-8',
    };

    Client client = Client();

    try {
      final response = await client
          .get(Uri.parse('$baseUrl/api/campus/$campusId'), headers: headers);

      if (response.statusCode == 200) {
        // print('Response Body: ${response.body}'); // Debugging respons

        final campusDetailResponse =
            campusDetailResponseFromJson(response.body);

        return campusDetailResponse;
      } else {
        // print('Error Status Code: ${response.statusCode}');
        // print('Error Response Body: ${response.body}');
        throw Exception("Failed to load campus details");
      }
    } catch (e) {
      print('Exception Occurred: $e');
      throw Exception("Oops! Something went wrong");
    }
  }

  Future<StudyProgramList> getStudyPrograms(int facultyId) async {
    var headers = <String, String>{};
    Client client = Client();

    headers["Content-Type"] = 'application/json; charset=UTF-8';

    final response = await client.get(
      Uri.parse('$baseUrl/api/faculties/$facultyId/study_programs'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final studyProgramList = studyProgramListFromJson(response.body);

      return studyProgramList;
    } else {
      throw Exception("Failed to load study programs.");
    }
  }

  Future<CampusReviews> getCampusReviews(int campusId) async {
    var headers = <String, String>{};
    Client client = Client();

    headers["Content-Type"] = 'application/json; charset=UTF-8';

    final response = await client.get(
      Uri.parse('$baseUrl/api/campus/$campusId/reviews'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final campusReviewsList = campusReviewsFromJson(response.body);

      return campusReviewsList;
    } else {
      throw Exception("Failed to load campus reviews.");
    }
  }
}
