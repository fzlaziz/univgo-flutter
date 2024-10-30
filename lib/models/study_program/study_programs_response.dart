class StudyProgramResponse {
  final int id;
  final String name;
  final String campus;
  final String degreeLevel;

  StudyProgramResponse({
    required this.id,
    required this.name,
    required this.campus,
    required this.degreeLevel,
  });

  factory StudyProgramResponse.fromJson(Map<String, dynamic> json) =>
      StudyProgramResponse(
        id: json["id"],
        name: json["name"],
        campus: json["campus"],
        degreeLevel: json["degree_level"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "campus": campus,
        "degree_level": degreeLevel,
      };
}
