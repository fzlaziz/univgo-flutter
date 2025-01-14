import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:univ_go/src/features/profile_campus/models/campus_detail.dart';
import 'package:univ_go/src/features/profile_campus/models/campus_review.dart';
import 'package:univ_go/src/features/profile_campus/models/study_program.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProfileCampusProvider {
  String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost:8000';
  String storageUrl = dotenv.env['STORAGE_URL'] ?? 'http://localhost:8000';

  Future<CampusDetailResponse> getCampusDetail(int campusId) async {
    var headers = <String, String>{
      "Content-Type": 'application/json; charset=UTF-8',
    };

    try {
      final response = await http
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
    headers["Content-Type"] = 'application/json; charset=UTF-8';

    final response = await http.get(
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

  Future<CampusReviews> getCampusReviews(int campusId,
      {bool preview = false}) async {
    var headers = <String, String>{};
    headers["Content-Type"] = 'application/json; charset=UTF-8';

    final uri = Uri.parse('$baseUrl/api/campus/$campusId/reviews')
        .replace(queryParameters: preview ? {'preview': 'true'} : null);

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final campusReviewsList = campusReviewsFromJson(response.body);
      return campusReviewsList;
    } else {
      throw Exception("Failed to load campus reviews.");
    }
  }

  Future<Map<String, dynamic>> addCampusReview(
      int campusId, int rating, String review) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('User not authenticated');
    }

    var headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };

    var body = json.encode({
      'rating': rating,
      'review': review,
    });

    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/api/campus_reviews/$campusId'),
            headers: headers,
            body: body,
          )
          .timeout(const Duration(seconds: 10));

      final responseData = json.decode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return {
          'success': true,
          'message': responseData['message'],
          'data': responseData['data'],
        };
      } else if (response.statusCode == 409) {
        return {
          'success': false,
          'message': 'Anda sudah memberikan ulasan untuk kampus ini.',
        };
      } else {
        throw Exception(responseData['message'] ?? 'Failed to add review');
      }
    } on SocketException {
      throw Exception('Tidak ada koneksi internet. Periksa jaringan Anda.');
    } on TimeoutException {
      throw Exception('Permintaan ke server timeout. Coba lagi nanti.');
    } catch (e) {
      throw Exception('Gagal menambahkan ulasan: $e');
    }
  }

  Future<Map<String, dynamic>> updateCampusReview(
      int reviewId, int rating, String review) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('User not authenticated');
    }

    var headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };

    var body = json.encode({
      'rating': rating,
      'review': review,
    });

    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/api/campus_reviews/$reviewId/edit'),
            headers: headers,
            body: body,
          )
          .timeout(const Duration(seconds: 10));

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': responseData['message'],
          'data': responseData['data'],
        };
      } else if (response.statusCode == 403) {
        return {
          'success': false,
          'message': 'Anda tidak memiliki akses untuk mengedit ulasan ini.',
        };
      } else {
        throw Exception(responseData['message'] ?? 'Failed to update review');
      }
    } on SocketException {
      throw Exception('Tidak ada koneksi internet. Periksa jaringan Anda.');
    } on TimeoutException {
      throw Exception('Permintaan ke server timeout. Coba lagi nanti.');
    } catch (e) {
      throw Exception('Gagal memperbarui ulasan: $e');
    }
  }

  Future<Map<String, dynamic>> deleteCampusReview(int reviewId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('User not authenticated');
    }

    var headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http
          .delete(
            Uri.parse('$baseUrl/api/campus_reviews/$reviewId'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 10));

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': responseData['message'],
        };
      } else if (response.statusCode == 403) {
        return {
          'success': false,
          'message': 'Anda tidak memiliki akses untuk menghapus ulasan ini.',
        };
      } else {
        throw Exception(responseData['message'] ?? 'Failed to delete review');
      }
    } on SocketException {
      throw Exception('Tidak ada koneksi internet. Periksa jaringan Anda.');
    } on TimeoutException {
      throw Exception('Permintaan ke server timeout. Coba lagi nanti.');
    } catch (e) {
      throw Exception('Gagal menghapus ulasan: $e');
    }
  }
}
