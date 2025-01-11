class CampusRegistrationRecord {
  final int id;
  final int totalRegistrants;
  final int year;
  final int campusId;

  CampusRegistrationRecord({
    required this.id,
    required this.totalRegistrants,
    required this.year,
    required this.campusId,
  });

  factory CampusRegistrationRecord.fromJson(Map<String, dynamic> json) {
    return CampusRegistrationRecord(
      id: json['id'] as int,
      totalRegistrants: json['total_registrants'] as int,
      year: json['year'] as int,
      campusId: json['campus_id'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'total_registrants': totalRegistrants,
      'year': year,
      'campus_id': campusId,
    };
  }
}
