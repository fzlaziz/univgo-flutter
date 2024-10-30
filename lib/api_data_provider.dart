import 'package:http/http.dart';
import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

class ApiDataProvider {
  Future<List<CampusResponse>> getCampus(String query,
      {String? sortBy, Map<String, List<int>>? selectedFilters}) async {
    await Future.delayed(const Duration(seconds: 0), () {});

    var headers = <String, String>{};
    Client client = Client();

    headers["Content-Type"] = 'application/json; charset=UTF-8';
    final response = await client.get(
        Uri.parse("http://192.168.1.5:8000/api/campuses"),
        headers: headers);

    if (response.statusCode == 200) {
      var jsonList = jsonDecode(response.body) as List;
      var campuses =
          jsonList.map((json) => CampusResponse.fromJson(json)).toList();

      final String baseUrl = "http://192.168.1.5:8000";
      for (var campus in campuses) {
        if (campus.logoPath != null && campus.logoPath!.startsWith('/')) {
          campus.logoPath = baseUrl + campus.logoPath!;
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

      return campuses;
    } else {
      throw Exception("Oops! Something went wrong");
    }
  }

  Future<List<StudyProgramResponse>> getStudyProgram(String query) async {
    await Future.delayed(const Duration(seconds: 0), () {});

    var headers = <String, String>{};
    Client client = Client();

    headers["Content-Type"] = 'application/json; charset=UTF-8';

    final response = await client.get(
        Uri.parse("http://192.168.1.5:8000/api/study_programs"),
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

      studyPrograms.sort((a, b) => a.name.compareTo(b.name));
      return studyPrograms;
    } else {
      throw Exception("Oops! Something went wrong");
    }
  }
}

double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const radius = 6371;
  double dLat = _toRadians(lat2 - lat1);
  double dLon = _toRadians(lon2 - lon1);
  double a = sin(dLat / 2) * sin(dLat / 2) +
      cos(_toRadians(lat1)) *
          cos(_toRadians(lat2)) *
          sin(dLon / 2) *
          sin(dLon / 2);
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));
  return radius * c;
}

double _toRadians(double degrees) {
  return degrees * pi / 180;
}

List<CampusResponse> campusResponseFromJson(String str) =>
    List<CampusResponse>.from(
        json.decode(str).map((x) => CampusResponse.fromJson(x)));

String campusResponseToJson(List<CampusResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CampusResponse {
  final int id;
  final String name;
  final String description;
  final DateTime date;
  String logoPath;
  final double addressLatitude;
  final double addressLongitude;
  final String webAddress;
  final String phoneNumber;
  final String province;
  final String city;
  final String district;
  final int rankScore;
  final int numberOfGraduates;
  final int numberOfRegistrants;
  final int accreditationId;
  final int minSingleTuition;
  final int maxSingleTuition;
  final int provinceId;
  final int cityId;
  final int districtId;
  final dynamic villageId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Accreditation accreditation;

  CampusResponse({
    required this.id,
    required this.name,
    required this.description,
    required this.logoPath,
    required this.date,
    required this.addressLatitude,
    required this.addressLongitude,
    required this.webAddress,
    required this.phoneNumber,
    required this.rankScore,
    required this.numberOfGraduates,
    required this.numberOfRegistrants,
    required this.accreditationId,
    required this.minSingleTuition,
    required this.maxSingleTuition,
    required this.villageId,
    required this.createdAt,
    required this.updatedAt,
    required this.accreditation,
    required this.province,
    required this.city,
    required this.district,
    required this.provinceId,
    required this.cityId,
    required this.districtId,
  });

  factory CampusResponse.fromJson(Map<String, dynamic> json) => CampusResponse(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        date: DateTime.parse(json["date"]),
        logoPath: json["logo_path"],
        addressLatitude: json["address_latitude"]?.toDouble(),
        addressLongitude: json["address_longitude"]?.toDouble(),
        webAddress: json["web_address"],
        phoneNumber: json["phone_number"],
        rankScore: json["rank_score"],
        numberOfGraduates: json["number_of_graduates"],
        numberOfRegistrants: json["number_of_registrants"],
        accreditationId: json["accreditation_id"],
        minSingleTuition: json["min_single_tuition"],
        maxSingleTuition: json["max_single_tuition"],
        province: json["province"],
        city: json["city"],
        district: json["district"],
        provinceId: json["province_id"],
        cityId: json["city_id"],
        districtId: json["district_id"],
        villageId: json["village_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        accreditation: Accreditation.fromJson(json["accreditation"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "logo_path": logoPath,
        "address_latitude": addressLatitude,
        "address_longitude": addressLongitude,
        "web_address": webAddress,
        "phone_number": phoneNumber,
        "rank_score": rankScore,
        "number_of_graduates": numberOfGraduates,
        "number_of_registrants": numberOfRegistrants,
        "accreditation_id": accreditationId,
        "min_single_tuition": minSingleTuition,
        "max_single_tuition": maxSingleTuition,
        "province": province,
        "city": city,
        "district": district,
        "province_id": provinceId,
        "city_id": cityId,
        "district_id": districtId,
        "village_id": villageId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "accreditation": accreditation.toJson(),
      };
}

class Accreditation {
  final int id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  Accreditation({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Accreditation.fromJson(Map<String, dynamic> json) => Accreditation(
        id: json["id"],
        name: json["name"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

List<StudyProgramResponse> studyProgramResponseFromJson(String str) =>
    List<StudyProgramResponse>.from(
        json.decode(str).map((x) => StudyProgramResponse.fromJson(x)));

String studyProgramResponseToJson(List<StudyProgramResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StudyProgramResponse {
  final int id;
  final String name;
  final String campus;
  final String degreeLevel;

  StudyProgramResponse({
    required this.id,
    required this.name,
    required this.campus,
    required this.degreeLevel,
  });

  factory StudyProgramResponse.fromJson(Map<String, dynamic> json) =>
      StudyProgramResponse(
        id: json["id"],
        name: json["name"],
        campus: json["campus"],
        degreeLevel: json["degree_level"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "campus": campus,
        "degree_level": degreeLevel,
      };
}
