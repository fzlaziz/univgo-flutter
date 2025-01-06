
import 'dart:convert';

List<AdmissionRouteCampus> admissionRouteCampusResponse(String str) => List<AdmissionRouteCampus>.from(json.decode(str).map((x) => AdmissionRouteCampus.fromJson(x)));

String admissionRouteCampusToJson(List<AdmissionRouteCampus> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AdmissionRouteCampus {
    final String id;
    final String campusId;
    final String admissionRouteId;
    final dynamic deletedAt;
    final DateTime createdAt;
    final DateTime updatedAt;

    AdmissionRouteCampus({
        required this.id,
        required this.campusId,
        required this.admissionRouteId,
        required this.deletedAt,
        required this.createdAt,
        required this.updatedAt,
    });

    factory AdmissionRouteCampus.fromJson(Map<String, dynamic> json) => AdmissionRouteCampus(
        id: json["id"],
        campusId: json["campus_id"],
        admissionRouteId: json["admission_route_id"],
        deletedAt: json["deleted_at"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "campus_id": campusId,
        "admission_route_id": admissionRouteId,
        "deleted_at": deletedAt,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
