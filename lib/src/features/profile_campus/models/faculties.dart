import 'dart:convert';
import 'package:univ_go/src/features/profile_campus/models/accreditation.dart';

FacultyClass facultyClassFromJson(String str) =>
    FacultyClass.fromJson(json.decode(str));

String facultyClassToJson(FacultyClass data) => json.encode(data.toJson());

class FacultyClass {
  final Faculty faculty;
  final List<StudyProgram> studyPrograms;

  FacultyClass({
    required this.faculty,
    required this.studyPrograms,
  });

  factory FacultyClass.fromJson(Map<String, dynamic> json) => FacultyClass(
        faculty: Faculty.fromJson(json["faculty"]),
        studyPrograms: List<StudyProgram>.from(
            json["study_programs"].map((x) => StudyProgram.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "faculty": faculty.toJson(),
        "study_programs":
            List<dynamic>.from(studyPrograms.map((x) => x.toJson())),
      };
}

class Faculty {
  final int id;
  final String name;
  final String description;
  final int campusId;
  final int masterFacultyId;
  final dynamic deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  Faculty({
    required this.id,
    required this.name,
    required this.description,
    required this.campusId,
    required this.masterFacultyId,
    required this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Faculty.fromJson(Map<String, dynamic> json) => Faculty(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        campusId: json["campus_id"],
        masterFacultyId: json["master_faculty_id"],
        deletedAt: json["deleted_at"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "campus_id": campusId,
        "master_faculty_id": masterFacultyId,
        "deleted_at": deletedAt,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class StudyProgram {
  final int id;
  final String name;
  final String description;
  final int campusId;
  final int accreditationId;
  final int degreeLevelId;
  final int facultyId;
  final int masterStudyProgramId;
  final dynamic deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Accreditation accreditation;

  StudyProgram({
    required this.id,
    required this.name,
    required this.description,
    required this.campusId,
    required this.accreditationId,
    required this.degreeLevelId,
    required this.facultyId,
    required this.masterStudyProgramId,
    required this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.accreditation,
  });

  factory StudyProgram.fromJson(Map<String, dynamic> json) => StudyProgram(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        campusId: json["campus_id"],
        accreditationId: json["accreditation_id"],
        degreeLevelId: json["degree_level_id"],
        facultyId: json["faculty_id"],
        masterStudyProgramId: json["master_study_program_id"],
        deletedAt: json["deleted_at"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        accreditation: Accreditation.fromJson(json["accreditation"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "campus_id": campusId,
        "accreditation_id": accreditationId,
        "degree_level_id": degreeLevelId,
        "faculty_id": facultyId,
        "master_study_program_id": masterStudyProgramId,
        "deleted_at": deletedAt,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "accreditation": accreditation.toJson(),
      };
}
