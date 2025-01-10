class News {
  final int id;
  final String title;
  final String slug;
  final String excerpt;
  final String content;
  final dynamic attachment;
  final int campusId;
  final dynamic deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  News({
    required this.id,
    required this.title,
    required this.slug,
    required this.excerpt,
    required this.content,
    required this.attachment,
    required this.campusId,
    required this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory News.fromJson(Map<String, dynamic> json) => News(
        id: json["id"],
        title: json["title"],
        slug: json["slug"],
        excerpt: json["excerpt"],
        content: json["content"],
        attachment: json["attachment"],
        campusId: json["campus_id"],
        deletedAt: json["deleted_at"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "slug": slug,
        "excerpt": excerpt,
        "content": content,
        "attachment": attachment,
        "campus_id": campusId,
        "deleted_at": deletedAt,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
