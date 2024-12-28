import 'dart:convert';

List<Berita> beritaFromJson(String str) =>
    List<Berita>.from(json.decode(str).map((x) => Berita.fromJson(x)));

String beritaToJson(List<Berita> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

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