import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

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

  factory BeritaTerkait.fromJson(Map<String, dynamic> json) {
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

    return BeritaTerkait(
      id: json["id"],
      title: json["title"],
      slug: json["slug"],
      excerpt: json["excerpt"],
      content: json["content"],
      attachment: json["attachment"],
      campusId: json["campus_id"],
      deletedAt: convertToJakartaTime(json["deleted_at"]),
      createdAt: convertToJakartaTime(json["created_at"]) ?? DateTime.now(),
      updatedAt: convertToJakartaTime(json["updated_at"]),
    );
  }

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
