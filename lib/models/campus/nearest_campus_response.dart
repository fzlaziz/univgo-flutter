class NearestCampusResponse {
    final int id;
    final String name;
    String? logoPath;
    final double addressLatitude;
    final double addressLongitude;
    double? distance;

    NearestCampusResponse({
        required this.id,
        required this.name,
        this.logoPath,
        required this.addressLatitude,
        required this.addressLongitude,
        this.distance,
    });

    factory NearestCampusResponse.fromJson(Map<String, dynamic> json) => NearestCampusResponse(
        id: json["id"],
        name: json["name"],
        logoPath: json["logo_path"],
        addressLatitude: json["address_latitude"]?.toDouble(),
        addressLongitude: json["address_longitude"]?.toDouble(),
        distance: json["distance"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "logo_path": logoPath,
        "address_latitude": addressLatitude,
        "address_longitude": addressLongitude,
        "distance": distance,
    };
}
