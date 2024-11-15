class StudyProgramResponse {
  final int id;
  final String name;
  final String campus;
  final int campusTypeId;
  final String campusType;
  final String district;
  final int districtId;
  final int accreditationId;
  final String accreditation;
  final String degreeLevel;
  final int degreeLevelId;

  StudyProgramResponse({
    required this.id,
    required this.name,
    required this.campus,
    required this.campusTypeId,
    required this.campusType,
    required this.district,
    required this.districtId,
    required this.degreeLevel,
    required this.accreditationId,
    required this.accreditation,
    required this.degreeLevelId,
  });

  factory StudyProgramResponse.fromJson(Map<String, dynamic> json) =>
      StudyProgramResponse(
        id: json["id"],
        name: json["name"],
        campus: json["campus"],
        degreeLevel: json["degree_level"],
        campusTypeId: json["campus_type_id"],
        campusType: json["campus_type"],
        district: json["district"],
        districtId: json["district_id"],
        accreditationId: json["accreditation_id"],
        accreditation: json["accreditation"],
        degreeLevelId: json["degree_level_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "campus": campus,
        "degree_level": degreeLevel,
        "campus_type_id": campusTypeId,
        "campus_type": campusType,
        "district": district,
        "district_id": districtId,
        "accreditation_id": accreditationId,
        "accreditation": accreditation,
        "degree_level_id": degreeLevelId,
      };
}
