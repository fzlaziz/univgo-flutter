import 'dart:convert';

CampusReviews campusReviewsFromJson(String str) =>
    CampusReviews.fromJson(json.decode(str));

String campusReviewsToJson(CampusReviews data) => json.encode(data.toJson());

class CampusReviews {
  final bool success;
  final Data data;

  CampusReviews({
    required this.success,
    required this.data,
  });

  factory CampusReviews.fromJson(Map<String, dynamic> json) => CampusReviews(
        success: json["success"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
      };
}

class Data {
  final int totalReviews;
  final num averageRating;
  final List<Review>? reviews;

  Data({
    required this.totalReviews,
    required this.averageRating,
    this.reviews,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        totalReviews: json["total_reviews"] ?? 0,
        averageRating: json["average_rating"] ?? 0,
        reviews: json["reviews"] != null
            ? List<Review>.from(json["reviews"].map((x) => Review.fromJson(x)))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "total_reviews": totalReviews,
        "average_rating": averageRating,
        "reviews": reviews != null
            ? List<dynamic>.from(reviews!.map((x) => x.toJson()))
            : [],
      };
}

class Review {
  final int id;
  final String user;
  final int userId;
  String? userProfileImage;
  final int rating;
  final String review;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.user,
    required this.userId,
    this.userProfileImage,
    required this.rating,
    required this.review,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json["id"],
        user: json["user"],
        userId: json["user_id"],
        userProfileImage: json["user_profile_image"],
        rating: json["rating"],
        review: json["review"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "user_id": userId,
        "user_profile_image": userProfileImage,
        "rating": rating,
        "review": review,
        "created_at": createdAt.toIso8601String(),
      };
}
