class Gallery {
    int id;
    String name;
    String description;
    String fileLocation;
    int campusId;
    dynamic deletedAt;
    DateTime createdAt;
    DateTime updatedAt;

    Gallery({
        required this.id,
        required this.name,
        required this.description,
        required this.fileLocation,
        required this.campusId,
        required this.deletedAt,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Gallery.fromJson(Map<String, dynamic> json) => Gallery(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        fileLocation: json["file_location"],
        campusId: json["campus_id"],
        deletedAt: json["deleted_at"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "file_location": fileLocation,
        "campus_id": campusId,
        "deleted_at": deletedAt,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };

    Gallery copyWith({
        int? id,
        String? name,
        String? description,
        String? fileLocation,
        String? url,
        int? campusId,
        dynamic deletedAt,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) {
        return Gallery(
            id: id ?? this.id,
            name: name ?? this.name,
            description: description ?? this.description,
            fileLocation: fileLocation ?? this.fileLocation,
            campusId: campusId ?? this.campusId,
            deletedAt: deletedAt ?? this.deletedAt,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );
    }
}
