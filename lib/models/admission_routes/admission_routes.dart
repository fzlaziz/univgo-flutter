class AdmissionRoute {
    final int id;
    final String name;
    final String description;
    final DateTime createdAt;
    final DateTime updatedAt;
    final dynamic deletedAt;
    final AdmissionRoutePivot? pivot;
    final String? fileLocation;
    final int? campusId;
    final int? masterFacultyId;

    AdmissionRoute({
        required this.id,
        required this.name,
        required this.description,
        required this.createdAt,
        required this.updatedAt,
        required this.deletedAt,
        this.pivot,
        this.fileLocation,
        this.campusId,
        this.masterFacultyId,
    });

    factory AdmissionRoute.fromJson(Map<String, dynamic> json) => AdmissionRoute(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        pivot: json["pivot"] == null ? null : AdmissionRoutePivot.fromJson(json["pivot"]),
        fileLocation: json["file_location"],
        campusId: json["campus_id"],
        masterFacultyId: json["master_faculty_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
        "pivot": pivot?.toJson(),
        "file_location": fileLocation,
        "campus_id": campusId,
        "master_faculty_id": masterFacultyId,
    };
}

class AdmissionRoutePivot {
    final int campusId;
    final int admissionRouteId;

    AdmissionRoutePivot({
        required this.campusId,
        required this.admissionRouteId,
    });

    factory AdmissionRoutePivot.fromJson(Map<String, dynamic> json) => AdmissionRoutePivot(
        campusId: json["campus_id"],
        admissionRouteId: json["admission_route_id"],
    );

    Map<String, dynamic> toJson() => {
        "campus_id": campusId,
        "admission_route_id": admissionRouteId,
    };
}