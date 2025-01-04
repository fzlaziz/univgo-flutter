import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

TopCampusList topCampusListFromJson(String str) =>
    TopCampusList.fromJson(json.decode(str));

String topCampusListToJson(TopCampusList data) => json.encode(data.toJson());

class TopCampusList {
  final List<Ptn> ptn;
  final List<Ptn> politeknik;
  final List<Ptn> swasta;

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
  final int id;
  final String name;
  String? logoPath;
  final int rankScore;
  final int campusTypeId;
  final CampusType campusType;

  Ptn({
    required this.id,
    required this.name,
    this.logoPath,
    required this.rankScore,
    required this.campusTypeId,
    required this.campusType,
  });

  factory Ptn.fromJson(Map<String, dynamic> json) => Ptn(
        id: json["id"],
        name: json["name"],
        logoPath: json["logo_path"],
        rankScore: json["rank_score"],
        campusTypeId: json["campus_type_id"],
        campusType: campusTypeValues.map[json["campus_type"]]!,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "logo_path": logoPath,
        "rank_score": rankScore,
        "campus_type_id": campusTypeId,
        "campus_type": campusTypeValues.reverse[campusType],
      };
}

enum CampusType { POLITEKNIK, PTN, SWASTA }

final campusTypeValues = EnumValues({
  "Politeknik": CampusType.POLITEKNIK,
  "PTN": CampusType.PTN,
  "Swasta": CampusType.SWASTA
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

class TopCampusProvider {
  String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost:8000';
  String awsUrl = dotenv.env['AWS_URL'] ?? 'http://localhost:8000';

  Future<TopCampusList> getAllCampuses() async {
    final response = await http.get(Uri.parse('$baseUrl/api/campuses/top-10'));

    if (response.statusCode == 200) {
      final data = topCampusListFromJson(response.body);

      for (var list in [data.ptn, data.politeknik, data.swasta]) {
        for (var campus in list) {
          if (campus.logoPath != null) {
            campus.logoPath = "$awsUrl/${campus.logoPath!}";
          }
        }
      }

      return data;
    } else {
      throw Exception('Failed to fetch campus data');
    }
  }
}
