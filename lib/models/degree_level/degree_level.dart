class DegreeLevel {
  final int id;
  final String name;

  DegreeLevel({
    required this.id,
    required this.name,
  });

  factory DegreeLevel.fromJson(Map<String, dynamic> json) => DegreeLevel(
        id: json["id"],
        name: json["name"],
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
