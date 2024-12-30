import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:univ_go/models/user/user.dart';

class Comment {
  final int id;
  final String text;
  final int newsId;
  final int userId;
  final DateTime? createdAt;
  final User user;

  Comment({
    required this.id,
    required this.text,
    required this.newsId,
    required this.userId,
    this.createdAt,
    required this.user,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    tz.initializeTimeZones();
    final jakarta = tz.getLocation('Asia/Jakarta');

    DateTime? jakartaTime;
    if (json['created_at'] != null) {
      final utcTime = DateTime.parse(json['created_at']);
      final jakartaDateTime = tz.TZDateTime.from(utcTime, jakarta);
      jakartaTime = DateTime(
        jakartaDateTime.year,
        jakartaDateTime.month,
        jakartaDateTime.day,
        jakartaDateTime.hour,
        jakartaDateTime.minute,
        jakartaDateTime.second,
        jakartaDateTime.millisecond,
        jakartaDateTime.microsecond,
      );
    }

    return Comment(
      id: json['id'],
      text: json['text'],
      newsId: json['news_id'],
      userId: json['user_id'],
      createdAt: jakartaTime,
      user: User.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'news_id': newsId,
      'user_id': userId,
      'created_at': createdAt?.toIso8601String(),
      'user': user.toJson(),
    };
  }
}
