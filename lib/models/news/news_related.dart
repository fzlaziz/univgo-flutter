
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
