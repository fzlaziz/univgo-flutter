class StudyProgramResponse {
  final int id;
  final String name;
  final String campus;
  final int campusTypeId;
  final int campusId;
  final String campusType;
  final String district;
  final int districtId;
  final int accreditationId;
  final String accreditation;
  final String degreeLevel;
  final int degreeLevelId;
  final int rankScore;
  final int provinceId;
  final int cityId;
  final double addressLatitude;
  final double addressLongitude;
  final int minSingleTuition;
  final int maxSingleTuition;

  StudyProgramResponse({
    required this.id,
    required this.name,
    required this.campus,
    required this.campusTypeId,
    required this.campusType,
    required this.campusId,
    required this.district,
    required this.districtId,
    required this.degreeLevel,
    required this.accreditationId,
    required this.accreditation,
    required this.degreeLevelId,
    required this.rankScore,
    required this.provinceId,
    required this.cityId,
    required this.addressLatitude,
    required this.addressLongitude,
    required this.minSingleTuition,
    required this.maxSingleTuition,
  });

  factory StudyProgramResponse.fromJson(Map<String, dynamic> json) =>
      StudyProgramResponse(
        id: json["id"],
        name: json["name"],
        campus: json["campus"],
        degreeLevel: json["degree_level"],
        campusTypeId: json["campus_type_id"],
        campusId: json["campus_id"],
        campusType: json["campus_type"],
        district: json["district"],
        districtId: json["district_id"],
        accreditationId: json["accreditation_id"],
        accreditation: json["accreditation"],
        degreeLevelId: json["degree_level_id"],
        rankScore: json["rank_score"],
        provinceId: json["province_id"],
        cityId: json["city_id"],
        addressLatitude: json["address_latitude"],
        addressLongitude: json["address_longitude"],
        minSingleTuition: json["min_single_tuition"],
        maxSingleTuition: json["max_single_tuition"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "campus": campus,
        "degree_level": degreeLevel,
        "campus_type_id": campusTypeId,
        "campus_type": campusType,
        "campus_id": campusId,
        "district": district,
        "district_id": districtId,
        "accreditation_id": accreditationId,
        "accreditation": accreditation,
        "degree_level_id": degreeLevelId,
        "rank_score": rankScore,
        "province_id": provinceId,
        "city_id": cityId,
        "address_latitude": addressLatitude,
        "address_longitude": addressLongitude,
        "min_single_tuition": minSingleTuition,
        "max_single_tuition": maxSingleTuition,
      };
}
