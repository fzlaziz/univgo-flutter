import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Fungsi untuk mengonversi data JSON ke objek Berita
List<Berita> beritaFromJson(String str) =>
    List<Berita>.from(json.decode(str).map((x) => Berita.fromJson(x)));

// Fungsi untuk mengonversi objek Berita ke format JSON
String beritaToJson(List<Berita> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NewsProvider {
  String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost:8000';
  String awsUrl = dotenv.env['AWS_URL'] ?? 'http://localhost:8000';
  // Fungsi untuk mendapatkan daftar berita
  Future<List<Berita>> getBerita() async {
    var headers = <String, String>{};
    Client client = Client();

    headers["Content-Type"] = 'application/json; charset=UTF-8';
    final response =
        await client.get(Uri.parse("$baseUrl/api/news"), headers: headers);

    if (response.statusCode == 200) {
      var jsonList = jsonDecode(response.body) as List;
      var news = jsonList.map((json) => Berita.fromJson(json)).toList();

      return news;
    } else {
      throw Exception("Oops! Something went wrong");
    }
  }

  // Fungsi untuk mendapatkan detail berita
  Future<DetailBerita> getDetailBerita(int newsId) async {
    var headers = <String, String>{
      "Content-Type": 'application/json; charset=UTF-8'
    };
    Client client = Client();

    final response = await client.get(Uri.parse("$baseUrl/api/news/$newsId"),
        headers: headers);

    if (response.statusCode == 200) {
      var jsonMap = jsonDecode(response.body);
      return DetailBerita.fromJson(jsonMap);
    } else {
      throw Exception("Oops! Something went wrong");
    }
  }

  // Fungsi untuk mendapatkan komentar dengan bearer token
  Future<List<Comment>> fetchComments(int newsId) async {
    var headers = <String, String>{
      "Content-Type": 'application/json; charset=UTF-8'
    };
    Client client = Client();
    final response = await client.get(
      Uri.parse('$baseUrl/api/news/$newsId/comments'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      // Jika server memberikan respons OK, parse data JSON
      final List<dynamic> commentJson = json.decode(response.body);
      return commentJson.map((json) => Comment.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mengambil komentar');
    }
  }

  // Fungsi untuk menambahkan komentar ke server
  Future<void> addComment(int newsId, String commentContent) async {
    // Header untuk request
    var headers = <String, String>{
      "Content-Type": 'application/json; charset=UTF-8',
      "Authorization":
          "Bearer 35|cck2JpWGmoQaSrISt7VjKMhlvsOVbRkdacPHc0Fpeed0620c", // Sesuaikan token Anda
    };

    // Body untuk request
    var body = json.encode({
      'news_id': newsId,
      'text': commentContent,
    });

    // Client untuk melakukan request
    Client client = Client();

    try {
      // Request POST ke API
      final response = await client
          .post(
            Uri.parse('$baseUrl/api/news/$newsId/comments'),
            headers: headers,
            body: body,
          )
          .timeout(const Duration(seconds: 10)); // Timeout untuk request

      // Periksa status kode respons
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Berhasil, tidak ada tindakan tambahan
        return;
      } else {
        // Jika status kode bukan 200/201, lempar Exception
        throw Exception('Gagal mengirim komentar: ${response.body}');
      }
    } on SocketException {
      // Jika tidak ada koneksi internet
      throw Exception("Tidak ada koneksi internet. Periksa jaringan Anda.");
    } on TimeoutException {
      // Jika request timeout
      throw Exception("Permintaan ke server timeout. Coba lagi nanti.");
    } catch (e) {
      // Tangkap error lain yang tidak terduga
      throw Exception("Gagal mengirim komentar: $e");
    } finally {
      // Pastikan client ditutup untuk menghindari memory leak
      client.close();
    }
  }
}

class Berita {
  int id;
  String title;
  String excerpt;
  String? attachment;
  DateTime createdAt;

  Berita({
    required this.id,
    required this.title,
    required this.excerpt,
    this.attachment,
    required this.createdAt,
  });

  factory Berita.fromJson(Map<String, dynamic> json) => Berita(
        id: json["id"],
        title: json["title"],
        excerpt: json["excerpt"],
        attachment: json["attachment"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "excerpt": excerpt,
        "attachment": attachment,
        "created_at": createdAt.toIso8601String(),
      };
}

class DetailBerita {
  int id;
  String title;
  String slug;
  String excerpt;
  String content;
  String? attachment;
  int campusId;
  DateTime? deletedAt;
  DateTime createdAt;
  DateTime? updatedAt;
  List<BeritaTerkait> relatedNews;

  DetailBerita({
    required this.id,
    required this.title,
    required this.slug,
    required this.excerpt,
    required this.content,
    this.attachment,
    required this.campusId,
    this.deletedAt,
    required this.createdAt,
    this.updatedAt,
    required this.relatedNews,
  });

  factory DetailBerita.fromJson(Map<String, dynamic> json) => DetailBerita(
        id: json["news_detail"]["id"],
        title: json["news_detail"]["title"],
        slug: json["news_detail"]["slug"],
        excerpt: json["news_detail"]["excerpt"],
        content: json["news_detail"]["content"],
        attachment: json["news_detail"]["attachment"],
        campusId: json["news_detail"]["campus_id"],
        deletedAt: json["news_detail"]["deleted_at"] != null
            ? DateTime.parse(json["news_detail"]["deleted_at"])
            : null,
        createdAt: DateTime.parse(json["news_detail"]["created_at"]),
        updatedAt: json["news_detail"]["updated_at"] != null
            ? DateTime.parse(json["news_detail"]["updated_at"])
            : null,
        relatedNews: List<BeritaTerkait>.from(
          json["related_news"].map((x) => BeritaTerkait.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
        "news_detail": {
          "id": id,
          "title": title,
          "slug": slug,
          "excerpt": excerpt,
          "content": content,
          "attachment": attachment,
          "campus_id": campusId,
          "deleted_at": deletedAt?.toIso8601String(),
          "created_at": createdAt.toIso8601String(),
          "updated_at": updatedAt?.toIso8601String(),
        },
        "related_news": List<dynamic>.from(relatedNews.map((x) => x.toJson())),
      };
}

class Comment {
  final int id;
  final String text;
  final int newsId;
  final int userId;
  final DateTime? createdAt;
  final User user;

  Comment({
    required this.id,
    required this.text,
    required this.newsId,
    required this.userId,
    this.createdAt,
    required this.user,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      text: json['text'],
      newsId: json['news_id'],
      userId: json['user_id'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      user: User.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'news_id': newsId,
      'user_id': userId,
      'created_at': createdAt?.toIso8601String(),
      'user': user.toJson(),
    };
  }
}

class User {
  final int id;
  final String name;
  final String email;

  User({
    required this.id,
    required this.name,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}

class BeritaTerkait {
  int id;
  String title;
  String slug;
  String excerpt;
  String content;
  String? attachment;
  int campusId;
  DateTime? deletedAt;
  DateTime createdAt;
  DateTime? updatedAt;

  BeritaTerkait({
    required this.id,
    required this.title,
    required this.slug,
    required this.excerpt,
    required this.content,
    this.attachment,
    required this.campusId,
    this.deletedAt,
    required this.createdAt,
    this.updatedAt,
  });

  factory BeritaTerkait.fromJson(Map<String, dynamic> json) => BeritaTerkait(
        id: json["id"],
        title: json["title"],
        slug: json["slug"],
        excerpt: json["excerpt"],
        content: json["content"],
        attachment: json["attachment"],
        campusId: json["campus_id"],
        deletedAt: json["deleted_at"] != null
            ? DateTime.parse(json["deleted_at"])
            : null,
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "slug": slug,
        "excerpt": excerpt,
        "content": content,
        "attachment": attachment,
        "campus_id": campusId,
        "deleted_at": deletedAt?.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
