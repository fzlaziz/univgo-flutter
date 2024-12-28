import 'package:univ_go/models/accreditation/accreditation.dart';
import 'package:univ_go/models/degree_level/degree_level.dart';

class CampusResponse {
  final int id;
  final String name;
  final String description;
  final DateTime dateOfEstablishment;
  String? logoPath;
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
  final int campusTypeId;
  final dynamic villageId;
  final Accreditation accreditation;
  final List<DegreeLevel> degreeLevels;
  double? distance;

  CampusResponse({
    required this.id,
    required this.name,
    required this.description,
    this.logoPath,
    required this.dateOfEstablishment,
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
    required this.accreditation,
    required this.province,
    required this.city,
    required this.district,
    required this.provinceId,
    required this.cityId,
    required this.districtId,
    required this.campusTypeId,
    required this.degreeLevels,
    this.distance,
  });

  factory CampusResponse.fromJson(Map<String, dynamic> json) {
    List<DegreeLevel> parsedDegreeLevels = json["degree_levels"] != null &&
            (json["degree_levels"] as List).isNotEmpty
        ? List<DegreeLevel>.from(
            json["degree_levels"].map((x) => DegreeLevel.fromJson(x)))
        : [
            DegreeLevel.fromJson({
              "id": 9999,
              "name": "Degree",
            })
          ];

    return CampusResponse(
      id: json["id"] ?? 0,
      name: json["name"] ?? "Unknown",
      description: json["description"] ?? "",
      dateOfEstablishment: json["date_of_establishment"] != null
          ? DateTime.parse(json["date_of_establishment"])
          : DateTime.now(),
      logoPath: json["logo_path"],
      addressLatitude: json["address_latitude"]?.toDouble() ?? 0.0,
      addressLongitude: json["address_longitude"]?.toDouble() ?? 0.0,
      webAddress: json["web_address"] ?? "",
      phoneNumber: json["phone_number"] ?? "",
      rankScore: json["rank_score"] ?? 100,
      numberOfGraduates: json["number_of_graduates"] ?? 0,
      numberOfRegistrants: json["number_of_registrants"] ?? 0,
      accreditationId: json["accreditation_id"] ?? 0,
      minSingleTuition: json["min_single_tuition"] ?? 0,
      maxSingleTuition: json["max_single_tuition"] ?? 0,
      province: json["province"] ?? "",
      city: json["city"] ?? "",
      district: json["district"] ?? "",
      provinceId: json["province_id"] ?? 0,
      cityId: json["city_id"] ?? 0,
      districtId: json["district_id"] ?? 0,
      campusTypeId: json["campus_type_id"] ?? 0,
      villageId: json["village_id"],
      degreeLevels: parsedDegreeLevels,
      accreditation: json["accreditation"] != null
          ? Accreditation.fromJson(json["accreditation"])
          : Accreditation.fromJson({"id": 9999, "name": "Unknown"}),
      distance: json['distance']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "date_of_establishment":
            "${dateOfEstablishment.year.toString().padLeft(4, '0')}-${dateOfEstablishment.month.toString().padLeft(2, '0')}-${dateOfEstablishment.day.toString().padLeft(2, '0')}",
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
        "campus_type_id": campusTypeId,
        "village_id": villageId,
        "accreditation": accreditation.toJson(),
        "degree_levels":
            List<dynamic>.from(degreeLevels.map((x) => x.toJson())),
        "distance": distance
      };
}
