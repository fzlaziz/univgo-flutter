import 'dart:convert';

import 'package:univ_go/src/features/profile_campus/models/degree_level.dart';
import 'package:univ_go/src/features/profile_campus/models/accreditation.dart';

StudyProgramList studyProgramListFromJson(String str) =>
    StudyProgramList.fromJson(json.decode(str));

String studyProgramListToJson(StudyProgramList data) =>
    json.encode(data.toJson());

class StudyProgramList {
  final Faculty faculty;
  final List<StudyProgram> studyPrograms;

  StudyProgramList({
    required this.faculty,
    required this.studyPrograms,
  });

  factory StudyProgramList.fromJson(Map<String, dynamic> json) =>
      StudyProgramList(
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

  Faculty({
    required this.id,
    required this.name,
    required this.description,
  });

  factory Faculty.fromJson(Map<String, dynamic> json) => Faculty(
        id: json["id"],
        name: json["name"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
      };
}

class StudyProgram {
  final int id;
  final String name;
  final String description;
  final DegreeLevel degreeLevel;
  final Accreditation accreditation;

  StudyProgram({
    required this.id,
    required this.name,
    required this.description,
    required this.degreeLevel,
    required this.accreditation,
  });

  factory StudyProgram.fromJson(Map<String, dynamic> json) => StudyProgram(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        degreeLevel: DegreeLevel.fromJson(json["degree_level"]),
        accreditation: Accreditation.fromJson(json["accreditation"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "degree_level": degreeLevel.toJson(),
        "accreditation": accreditation.toJson(),
      };
}
