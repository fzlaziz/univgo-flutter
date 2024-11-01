class Accreditation {
  final int id;
  final String name;

  Accreditation({
    required this.id,
    required this.name,
  });

  factory Accreditation.fromJson(Map<String, dynamic> json) => Accreditation(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
