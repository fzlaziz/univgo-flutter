class Accreditation {
  final int id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  Accreditation({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Accreditation.fromJson(Map<String, dynamic> json) => Accreditation(
        id: json["id"],
        name: json["name"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
