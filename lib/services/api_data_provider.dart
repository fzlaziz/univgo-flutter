import 'package:http/http.dart';
import 'dart:convert';
import 'package:univ_go/functions/calculate_distance.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:univ_go/models/study_program/study_programs_response.dart';
import 'package:univ_go/models/campus/campus_response.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiDataProvider {
  String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost:8000';
  String awsUrl = dotenv.env['AWS_URL'] ?? 'http://localhost:8000';
  Future<List<CampusResponse>> getCampus(String query,
      {String? sortBy, Map<String, List<int>>? selectedFilters}) async {
    await Future.delayed(const Duration(seconds: 0), () {});

    var headers = <String, String>{};
    Client client = Client();

    headers["Content-Type"] = 'application/json; charset=UTF-8';
    final response =
        await client.get(Uri.parse("$baseUrl/api/campuses"), headers: headers);

    if (response.statusCode == 200) {
      var jsonList = jsonDecode(response.body) as List;
      var campuses =
          jsonList.map((json) => CampusResponse.fromJson(json)).toList();

      for (var campus in campuses) {
        if (campus.logoPath != null && campus.logoPath!.isNotEmpty) {
          campus.logoPath = awsUrl + '/' + campus.logoPath!;
        }
      }
      // Filter by query
      if (query.isNotEmpty) {
        campuses = campuses
            .where((campus) =>
                campus.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }

      final prefs = await SharedPreferences.getInstance();
      double? userLatitude = prefs.getDouble('userLatitude');
      double? userLongitude = prefs.getDouble('userLongitude');

      if (sortBy == 'min_single_tuition') {
        campuses
            .sort((a, b) => a.minSingleTuition.compareTo(b.minSingleTuition));
      } else if (sortBy == 'max_single_tuition') {
        campuses
            .sort((a, b) => b.maxSingleTuition.compareTo(a.maxSingleTuition));
      } else if (sortBy == 'rank_score') {
        campuses.sort((a, b) => a.rankScore.compareTo(b.rankScore));
      } else if (sortBy == 'nearest') {
        if (userLatitude != null && userLongitude != null) {
          campuses.sort((a, b) {
            double distanceA = calculateDistance(userLatitude, userLongitude,
                a.addressLatitude, a.addressLongitude);
            double distanceB = calculateDistance(userLatitude, userLongitude,
                b.addressLatitude, b.addressLongitude);
            return distanceA.compareTo(distanceB);
          });
        }
      }

      if (selectedFilters != null && selectedFilters['location'] != null) {
        List<int> selectedLocationIds = selectedFilters['location']!;

        campuses = campuses
            .where((campus) => selectedLocationIds.contains(campus.districtId))
            .toList();
      }
      if (selectedFilters != null && selectedFilters['campus_type'] != null) {
        List<int> campusTypeIds = selectedFilters['campus_type']!;

        campuses = campuses
            .where((campus) => campusTypeIds.contains(campus.campusTypeId))
            .toList();
      }

      if (selectedFilters != null && selectedFilters['accreditation'] != null) {
        List<int> accreditationIds = selectedFilters['accreditation']!;

        campuses = campuses
            .where(
                (campus) => accreditationIds.contains(campus.accreditation.id))
            .toList();
      }

      if (selectedFilters != null && selectedFilters['degree_level'] != null) {
        List<int> degreeLevelIds = selectedFilters['degree_level']!;

        campuses = campuses
            .where((campus) => campus.degreeLevels
                .any((degreeLevel) => degreeLevelIds.contains(degreeLevel.id)))
            .toList();
      }

      return campuses;
    } else {
      throw Exception("Oops! Something went wrong");
    }
  }

  Future<List<StudyProgramResponse>> getStudyProgram(String query,
      {String? sortBy, Map<String, List<int>>? selectedFilters}) async {
    await Future.delayed(const Duration(seconds: 0), () {});

    var headers = <String, String>{};
    Client client = Client();

    headers["Content-Type"] = 'application/json; charset=UTF-8';

    final response = await client.get(Uri.parse("$baseUrl/api/study_programs"),
        headers: headers);

    if (response.statusCode == 200) {
      var jsonList = jsonDecode(response.body) as List;
      var studyPrograms =
          jsonList.map((json) => StudyProgramResponse.fromJson(json)).toList();

      if (query.isNotEmpty) {
        studyPrograms = studyPrograms
            .where((studyProgram) =>
                studyProgram.name.toLowerCase().contains(query.toLowerCase()) ||
                studyProgram.campus.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }

      if (selectedFilters != null && selectedFilters['location'] != null) {
        List<int> selectedLocationIds = selectedFilters['location']!;

        studyPrograms = studyPrograms
            .where((studyProgram) =>
                selectedLocationIds.contains(studyProgram.districtId))
            .toList();
      }

      if (selectedFilters != null && selectedFilters['campus_type'] != null) {
        List<int> campusTypeIds = selectedFilters['campus_type']!;

        studyPrograms = studyPrograms
            .where((studyProgram) =>
                campusTypeIds.contains(studyProgram.campusTypeId))
            .toList();
      }

      if (selectedFilters != null && selectedFilters['degree_level'] != null) {
        List<int> degreeLevelIds = selectedFilters['degree_level']!;

        studyPrograms = studyPrograms
            .where((studyProgram) =>
                degreeLevelIds.contains(studyProgram.degreeLevelId))
            .toList();
      }

      if (selectedFilters != null && selectedFilters['accreditation'] != null) {
        List<int> accreditationIds = selectedFilters['accreditation']!;

        studyPrograms = studyPrograms
            .where((studyProgram) =>
                accreditationIds.contains(studyProgram.accreditationId))
            .toList();
      }

      studyPrograms.sort((a, b) => a.name.compareTo(b.name));
      return studyPrograms;
    } else {
      throw Exception("Oops! Something went wrong");
    }
  }
}
