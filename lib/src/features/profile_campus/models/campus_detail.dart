import 'dart:convert';

import 'package:univ_go/src/features/profile_campus/models/campus_registration_records.dart';
import 'package:univ_go/src/features/profile_campus/models/degree_level.dart';
import 'package:univ_go/src/features/profile_campus/models/facility.dart';
import 'package:univ_go/src/features/profile_campus/models/gallery.dart';
import 'package:univ_go/src/features/news/models/campus_news.dart';
import 'package:univ_go/src/features/profile_campus/models/faculties.dart';
import 'package:univ_go/src/features/profile_campus/models/admission_routes.dart';

CampusDetailResponse campusDetailResponseFromJson(String str) =>
    CampusDetailResponse.fromJson(json.decode(str));

String campusDetailResponseToJson(CampusDetailResponse data) =>
    json.encode(data.toJson());

class CampusDetailResponse {
  final int id;
  final String name;
  final String description;
  final DateTime dateOfEstablishment;
  final String logoPath;
  final double addressLatitude;
  final double addressLongitude;
  final String webAddress;
  final String phoneNumber;
  final int numberOfGraduates;
  final int numberOfRegistrants;
  final int minSingleTuition;
  final int maxSingleTuition;
  final int accreditationId;
  final int districtId;
  final int campusTypeId;
  final dynamic deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<DegreeLevel>? degreeLevels;
  final List<AdmissionRoute>? admissionRoutes;
  final List<Faculty>? faculties;
  final String campusType;
  final String accreditation;
  final List<News>? news;
  List<Gallery>? galleries;
  List<Facility>? facilities;
  final List<dynamic>? admissionStatistitcs;
  List<CampusRegistrationRecord>? campusRegistrationRecords;
  final dynamic email;
  final dynamic youtube;
  final dynamic instagram;
  final int rankScore;

  CampusDetailResponse({
    required this.id,
    required this.name,
    required this.description,
    required this.dateOfEstablishment,
    required this.logoPath,
    required this.addressLatitude,
    required this.addressLongitude,
    required this.webAddress,
    required this.phoneNumber,
    required this.numberOfGraduates,
    required this.numberOfRegistrants,
    required this.minSingleTuition,
    required this.maxSingleTuition,
    required this.accreditationId,
    required this.districtId,
    required this.campusTypeId,
    required this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    this.degreeLevels,
    this.admissionRoutes,
    required this.faculties,
    required this.campusType,
    required this.accreditation,
    this.news,
    this.galleries,
    this.facilities,
    this.admissionStatistitcs,
    required this.email,
    required this.youtube,
    required this.instagram,
    this.campusRegistrationRecords,
    required this.rankScore,
  });

  factory CampusDetailResponse.fromJson(Map<String, dynamic> json) =>
      CampusDetailResponse(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        dateOfEstablishment: DateTime.parse(json["date_of_establishment"]),
        logoPath: json["logo_path"],
        rankScore: json["rank_score"] ?? 9999,
        addressLatitude: json["address_latitude"],
        addressLongitude: json["address_longitude"],
        webAddress: json["web_address"],
        phoneNumber: json["phone_number"],
        numberOfGraduates: json["number_of_graduates"],
        numberOfRegistrants: json["number_of_registrants"],
        minSingleTuition: json["min_single_tuition"],
        maxSingleTuition: json["max_single_tuition"],
        accreditationId: json["accreditation_id"],
        districtId: json["district_id"],
        campusTypeId: json["campus_type_id"],
        deletedAt: json["deleted_at"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        degreeLevels: json["degree_levels"] != null
            ? List<DegreeLevel>.from(
                json["degree_levels"].map((x) => DegreeLevel.fromJson(x)))
            : null,
        admissionRoutes: json["admission_routes"] != null
            ? List<AdmissionRoute>.from(
                json["admission_routes"].map((x) => AdmissionRoute.fromJson(x)))
            : null,
        faculties: List<Faculty>.from(
            json["faculties"].map((x) => Faculty.fromJson(x))),
        campusType: json["campus_type"],
        accreditation: json["accreditation"],
        news: json["news"] != null
            ? List<News>.from(json["news"].map((x) => News.fromJson(x)))
            : null,
        galleries: json["galleries"] != null
            ? List<Gallery>.from(
                json["galleries"].map((x) => Gallery.fromJson(x)))
            : null,
        facilities: json["facilities"] != null
            ? List<Facility>.from(
                json["facilities"].map((x) => Facility.fromJson(x)))
            : null,
        admissionStatistitcs: json["admission_statistitcs"] != null
            ? List<dynamic>.from(json["admission_statistitcs"].map((x) => x))
            : null,
        email: json["email"],
        youtube: json["youtube"],
        instagram: json["instagram"],
        campusRegistrationRecords: json["campus_registration_records"] != null
            ? List<CampusRegistrationRecord>.from(
                json["campus_registration_records"]
                    .map((x) => CampusRegistrationRecord.fromJson(x)))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "date_of_establishment":
            "${dateOfEstablishment.year.toString().padLeft(4, '0')}-${dateOfEstablishment.month.toString().padLeft(2, '0')}-${dateOfEstablishment.day.toString().padLeft(2, '0')}",
        "logo_path": logoPath,
        "address_latitude": addressLatitude,
        "address_longitude": addressLongitude,
        "web_address": webAddress,
        "phone_number": phoneNumber,
        "number_of_graduates": numberOfGraduates,
        "number_of_registrants": numberOfRegistrants,
        "min_single_tuition": minSingleTuition,
        "max_single_tuition": maxSingleTuition,
        "accreditation_id": accreditationId,
        "district_id": districtId,
        "campus_type_id": campusTypeId,
        "rank_score": rankScore,
        "deleted_at": deletedAt,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "degree_levels": degreeLevels != null
            ? List<dynamic>.from(degreeLevels!.map((x) => x.toJson()))
            : null,
        "admission_routes": admissionRoutes != null
            ? List<dynamic>.from(admissionRoutes!.map((x) => x.toJson()))
            : null,
        "faculties": List<dynamic>.from(faculties!.map((x) => x.toJson())),
        "campus_type": campusType,
        "accreditation": accreditation,
        "news": news != null
            ? List<dynamic>.from(news!.map((x) => x.toJson()))
            : null,
        "galleries": galleries != null
            ? List<dynamic>.from(galleries!.map((x) => x))
            : null,
        "facilities": facilities != null
            ? List<dynamic>.from(facilities!.map((x) => x))
            : null,
        "admission_statistitcs": admissionStatistitcs != null
            ? List<dynamic>.from(admissionStatistitcs!.map((x) => x))
            : null,
        "email": email,
        "youtube": youtube,
        "instagram": instagram,
        "campus_registration_records": campusRegistrationRecords != null
            ? List<dynamic>.from(
                campusRegistrationRecords!.map((x) => x.toJson()))
            : null,
      };
}
