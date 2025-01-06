class DegreeLevel {
  final int id;
  final String name;
  final int duration;

  DegreeLevel({
    required this.id,
    required this.name,
    required this.duration,
  });

  factory DegreeLevel.fromJson(Map<String, dynamic> json) => DegreeLevel(
        id: json["id"],
        name: json["name"],
        duration: json["duration"],
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "duration": duration,
      };
}
