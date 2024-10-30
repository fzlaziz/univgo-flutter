import 'package:univ_go/models/accreditation/accreditation.dart';

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
