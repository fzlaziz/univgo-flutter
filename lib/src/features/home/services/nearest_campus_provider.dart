import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:univ_go/src/features/home/models/nearest_campus_response.dart';

class NearestCampusProvider {
  String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost:8000';
  String storageUrl = dotenv.env['STORAGE_URL'] ?? 'http://localhost:8000';

  Future<List<NearestCampusResponse>> getCampusesNearby(
      {required double latitude, required double longitude}) async {
    var headers = <String, String>{};
    Client client = Client();
    headers["Content-Type"] = 'application/json; charset=UTF-8';

    final response = await client.get(
        Uri.parse(
            "$baseUrl/api/campuses-nearest?latitude=$latitude&longitude=$longitude"),
        headers: headers);

    if (response.statusCode == 200) {
      var jsonList = jsonDecode(response.body) as List;
      var campuses =
          jsonList.map((json) => NearestCampusResponse.fromJson(json)).toList();

      // Process logo paths
      for (var campus in campuses) {
        if (campus.logoPath != null && campus.logoPath!.isNotEmpty) {
          campus.logoPath = "$storageUrl/${campus.logoPath!}";
        }
      }

      return campuses;
    } else {
      throw Exception("Oops! Something went wrong");
    }
  }
}
