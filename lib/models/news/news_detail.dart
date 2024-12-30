import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:univ_go/models/news/news_related.dart';

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

  factory DetailBerita.fromJson(Map<String, dynamic> json) {
    tz.initializeTimeZones();

    final jakarta = tz.getLocation('Asia/Jakarta');

    DateTime? convertToJakartaTime(String? dateString) {
      if (dateString == null) return null;
      final utcTime = DateTime.parse(dateString);
      final jakartaDateTime = tz.TZDateTime.from(utcTime, jakarta);
      return DateTime(
        jakartaDateTime.year,
        jakartaDateTime.month,
        jakartaDateTime.day,
        jakartaDateTime.hour,
        jakartaDateTime.minute,
        jakartaDateTime.second,
        jakartaDateTime.millisecond,
        jakartaDateTime.microsecond,
      );
    }

    return DetailBerita(
      id: json["news_detail"]["id"],
      title: json["news_detail"]["title"],
      slug: json["news_detail"]["slug"],
      excerpt: json["news_detail"]["excerpt"],
      content: json["news_detail"]["content"],
      attachment: json["news_detail"]["attachment"],
      campusId: json["news_detail"]["campus_id"],
      deletedAt: convertToJakartaTime(json["news_detail"]["deleted_at"]),
      createdAt: convertToJakartaTime(json["news_detail"]["created_at"]) ??
          DateTime.now(),
      updatedAt: convertToJakartaTime(json["news_detail"]["updated_at"]),
      relatedNews: List<BeritaTerkait>.from(
        json["related_news"].map((x) => BeritaTerkait.fromJson(x)),
      ),
    );
  }

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
