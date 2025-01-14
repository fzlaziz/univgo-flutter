import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:univ_go/src/features/news/models/news.dart';
import 'package:univ_go/src/features/news/models/news_comment.dart';
import 'package:univ_go/src/features/news/models/news_detail.dart';

class NewsProvider {
  String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost:8000';
  String storageUrl = dotenv.env['STORAGE_URL'] ?? 'http://localhost:8000';
  Future<List<Berita>> getBerita() async {
    var headers = <String, String>{};

    headers["Content-Type"] = 'application/json; charset=UTF-8';
    final response =
        await http.get(Uri.parse("$baseUrl/api/news"), headers: headers);

    if (response.statusCode == 200) {
      var jsonList = jsonDecode(response.body) as List;
      var news = jsonList.map((json) => Berita.fromJson(json)).toList();

      return news;
    } else {
      throw Exception("Oops! Something went wrong");
    }
  }

  Future<DetailBerita> getDetailBerita(int newsId) async {
    var headers = <String, String>{
      "Content-Type": 'application/json; charset=UTF-8'
    };

    final response = await http.get(Uri.parse("$baseUrl/api/news/$newsId"),
        headers: headers);

    if (response.statusCode == 200) {
      var jsonMap = jsonDecode(response.body);
      return DetailBerita.fromJson(jsonMap);
    } else {
      throw Exception("Oops! Something went wrong");
    }
  }

  Future<List<Comment>> fetchComments(int newsId) async {
    var headers = <String, String>{
      "Content-Type": 'application/json; charset=UTF-8'
    };
    final response = await http.get(
      Uri.parse('$baseUrl/api/news/$newsId/comments'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> commentJson = json.decode(response.body);

      List<Comment> comments =
          commentJson.map((json) => Comment.fromJson(json)).toList();

      comments.sort((a, b) => (b.createdAt ?? DateTime.now())
          .compareTo(a.createdAt ?? DateTime.now()));
      return comments;
    } else {
      throw Exception('Gagal mengambil komentar');
    }
  }

  Future<void> addComment(int newsId, String commentContent) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    var headers = <String, String>{
      "Content-Type": 'application/json; charset=UTF-8',
      "Authorization": 'Bearer $token',
    };

    var body = json.encode({
      'news_id': newsId,
      'text': commentContent,
    });

    final client = http.Client();
    try {
      final response = await client
          .post(
            Uri.parse('$baseUrl/api/news/$newsId/comments'),
            headers: headers,
            body: body,
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      } else {
        throw Exception('Gagal mengirim komentar: ${response.body}');
      }
    } on SocketException {
      throw Exception("Tidak ada koneksi internet. Periksa jaringan Anda.");
    } on TimeoutException {
      throw Exception("Permintaan ke server timeout. Coba lagi nanti.");
    } catch (e) {
      throw Exception("Gagal mengirim komentar: $e");
    } finally {
      client.close();
    }
  }

  Future<Map<String, dynamic>> deleteComment(int commentId) async {
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
            Uri.parse('$baseUrl/api/news_comments/$commentId'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 10));

      final responseData = json.decode(response.body);
      print(responseData['message']);
      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': responseData['message'],
        };
      } else if (response.statusCode == 403) {
        return {
          'success': false,
          'message': 'Anda tidak memiliki akses untuk menghapus komentar ini.',
        };
      } else {
        throw Exception(responseData['message'] ?? 'Failed to delete comment');
      }
    } on SocketException {
      throw Exception('Tidak ada koneksi internet. Periksa jaringan Anda.');
    } on TimeoutException {
      throw Exception('Permintaan ke server timeout. Coba lagi nanti.');
    } catch (e) {
      throw Exception('Gagal menghapus komentar: $e');
    }
  }
}
