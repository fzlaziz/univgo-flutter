import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

TopCampusList topCampusListFromJson(String str) =>
    TopCampusList.fromJson(json.decode(str));

String topCampusListToJson(TopCampusList data) => json.encode(data.toJson());

class TopCampusList {
  List<Ptn> ptn;
  List<Ptn> politeknik;
  List<Ptn> swasta;

  TopCampusList({
    required this.ptn,
    required this.politeknik,
    required this.swasta,
  });

  factory TopCampusList.fromJson(Map<String, dynamic> json) => TopCampusList(
        ptn: List<Ptn>.from(json["PTN"].map((x) => Ptn.fromJson(x))),
        politeknik:
            List<Ptn>.from(json["Politeknik"].map((x) => Ptn.fromJson(x))),
        swasta: List<Ptn>.from(json["Swasta"].map((x) => Ptn.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "PTN": List<dynamic>.from(ptn.map((x) => x.toJson())),
        "Politeknik": List<dynamic>.from(politeknik.map((x) => x.toJson())),
        "Swasta": List<dynamic>.from(swasta.map((x) => x.toJson())),
      };
}

class Ptn {
  int id;
  String name;
  String? logoPath;
  double addressLatitude;
  double addressLongitude;
  int rankScore;
  int accreditationId;
  String district;
  int districtId;
  String city;
  int cityId;
  String province;
  int provinceId;
  int campusTypeId;
  String campusType;
  Accreditation accreditation;

  Ptn({
    required this.id,
    required this.name,
    required this.logoPath,
    required this.addressLatitude,
    required this.addressLongitude,
    required this.rankScore,
    required this.accreditationId,
    required this.district,
    required this.districtId,
    required this.city,
    required this.cityId,
    required this.province,
    required this.provinceId,
    required this.campusTypeId,
    required this.campusType,
    required this.accreditation,
  });

  factory Ptn.fromJson(Map<String, dynamic> json) => Ptn(
        id: json["id"],
        name: json["name"],
        logoPath: json["logo_path"],
        addressLatitude: json["address_latitude"]?.toDouble(),
        addressLongitude: json["address_longitude"]?.toDouble(),
        rankScore: json["rank_score"],
        accreditationId: json["accreditation_id"],
        district: json["district"],
        districtId: json["district_id"],
        city: json["city"],
        cityId: json["city_id"],
        province: json["province"],
        provinceId: json["province_id"],
        campusTypeId: json["campus_type_id"],
        campusType: json["campus_type"],
        accreditation: Accreditation.fromJson(json["accreditation"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "logo_path": logoPath,
        "address_latitude": addressLatitude,
        "address_longitude": addressLongitude,
        "rank_score": rankScore,
        "accreditation_id": accreditationId,
        "district": district,
        "district_id": districtId,
        "city": city,
        "city_id": cityId,
        "province": province,
        "province_id": provinceId,
        "campus_type_id": campusTypeId,
        "campus_type": campusType,
        "accreditation": accreditation.toJson(),
      };
}

class Accreditation {
  int id;
  String name;

  Accreditation({
    required this.id,
    required this.name,
  });

  factory Accreditation.fromJson(Map<String, dynamic> json) => Accreditation(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class TopCampusProvider {
  String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost:8000';
  String awsUrl = dotenv.env['AWS_URL'] ?? 'http://localhost:8000';

  Future<List<Ptn>> getPtn() async {
    final response = await http.get(Uri.parse('$baseUrl/api/campuses/top-10'));
    if (response.statusCode == 200) {
      final data = topCampusListFromJson(response.body);
      data.ptn.forEach((campus) {
        if (campus.logoPath != null) {
          campus.logoPath = "$awsUrl/${campus.logoPath!}";
        }
      });
      return data.ptn;
    } else {
      throw Exception('Failed to fetch PTN data');
    }
  }

  Future<List<Ptn>> getPoliteknik() async {
    final response = await http.get(Uri.parse('$baseUrl/api/campuses/top-10'));
    if (response.statusCode == 200) {
      final data = topCampusListFromJson(response.body);
      data.politeknik.forEach((campus) {
        if (campus.logoPath != null) {
          campus.logoPath = "$awsUrl/${campus.logoPath!}";
        }
      });
      return data.politeknik;
    } else {
      throw Exception('Failed to fetch Politeknik data');
    }
  }

  Future<List<Ptn>> getSwasta() async {
    final response = await http.get(Uri.parse('$baseUrl/api/campuses/top-10'));
    if (response.statusCode == 200) {
      final data = topCampusListFromJson(response.body);
      data.swasta.forEach((campus) {
        if (campus.logoPath != null) {
          campus.logoPath = "$awsUrl/${campus.logoPath!}";
        }
      });
      return data.swasta;
    } else {
      throw Exception('Failed to fetch Swasta data');
    }
  }
}
