import 'package:http/http.dart';
import 'dart:convert';

class ApiDataProvider {
  Future<List<CampusResponse>> getCampus() async {
    await Future.delayed(const Duration(seconds: 2), () {});

    var headers = <String, String>{};
    Client client = Client();

    headers["Content-Type"] = 'application/json; charset=UTF-8';

    final response = await client.get(
        Uri.parse("http://192.168.1.5:8000/api/campuses"),
        headers: headers);

    if (response.statusCode == 200) {
      var jsonList = jsonDecode(response.body) as List;
      var campuses = jsonList.map((json) => CampusResponse.fromJson(json)).toList();

      return campuses;
    } else {
      throw Exception("Oops! Something went wrong");
    }
  }
}

List<CampusResponse> campusResponseFromJson(String str) => List<CampusResponse>.from(json.decode(str).map((x) => CampusResponse.fromJson(x)));

String campusResponseToJson(List<CampusResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CampusResponse {
    final int id;
    final String name;
    final String description;
    final DateTime date;
    final double addressLatitude;
    final double addressLongitude;
    final String webAddress;
    final String phoneNumber;
    final int rankScore;
    final int numberOfGraduates;
    final int numberOfRegistrants;
    final int accreditationId;
    final dynamic villageId;
    final DateTime createdAt;
    final DateTime updatedAt;
    final Accreditation accreditation;

    CampusResponse({
        required this.id,
        required this.name,
        required this.description,
        required this.date,
        required this.addressLatitude,
        required this.addressLongitude,
        required this.webAddress,
        required this.phoneNumber,
        required this.rankScore,
        required this.numberOfGraduates,
        required this.numberOfRegistrants,
        required this.accreditationId,
        required this.villageId,
        required this.createdAt,
        required this.updatedAt,
        required this.accreditation,
    });

    factory CampusResponse.fromJson(Map<String, dynamic> json) => CampusResponse(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        date: DateTime.parse(json["date"]),
        addressLatitude: json["address_latitude"]?.toDouble(),
        addressLongitude: json["address_longitude"]?.toDouble(),
        webAddress: json["web_address"],
        phoneNumber: json["phone_number"],
        rankScore: json["rank_score"],
        numberOfGraduates: json["number_of_graduates"],
        numberOfRegistrants: json["number_of_registrants"],
        accreditationId: json["accreditation_id"],
        villageId: json["village_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        accreditation: Accreditation.fromJson(json["accreditation"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "address_latitude": addressLatitude,
        "address_longitude": addressLongitude,
        "web_address": webAddress,
        "phone_number": phoneNumber,
        "rank_score": rankScore,
        "number_of_graduates": numberOfGraduates,
        "number_of_registrants": numberOfRegistrants,
        "accreditation_id": accreditationId,
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

