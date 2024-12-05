import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:univ_go/services/news/news_provider.dart';

class NewsLatest {
  String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost:8000';
  String awsUrl = dotenv.env['AWS_URL'] ?? 'http://localhost:8000';
  // Fungsi untuk mendapatkan daftar berita
  Future<List<Berita>> getBerita() async {
    var headers = <String, String>{};
    Client client = Client();

    headers["Content-Type"] = 'application/json; charset=UTF-8';
    final response = await client.get(Uri.parse("$baseUrl/api/news/latest"),
        headers: headers);

    if (response.statusCode == 200) {
      var jsonList = jsonDecode(response.body) as List;
      var news = jsonList.map((json) {
        var berita = Berita.fromJson(json);
        if (berita.attachment != null) {
          berita.attachment = "$awsUrl/${berita.attachment!}";
        }
        return berita;
      }).toList();

      return news;
    } else {
      throw Exception("Oops! Something went wrong");
    }
  }
}
