import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:univ_go/src/features/profile_campus/services/profile_campus_provider.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await dotenv.load(fileName: ".env");

  test('Fetch CampusReviews', () async {
    final campusService = ProfileCampusProvider();

    try {
      var campusReviews = await campusService.getCampusReviews(1);
      print('Total Reviews: ${campusReviews.data.totalReviews}');
      print('Total Reviews: ${campusReviews.data.averageRating}');
      print('--------------------------------');

      var reviews = campusReviews.data.reviews;

      if (reviews != null && reviews.isNotEmpty) {
        for (var review in reviews) {
          print('Review ID: ${review.id}');
          print('User: ${review.user}');
          print('Rating: ${review.rating}');
          print('Review: ${review.review}');
          print('Created At: ${review.createdAt}');
          print('--------------------------------');
        }
      } else {
        print('No reviews found.');
      }
    } catch (e) {
      print('Error fetching Campus Review: $e');
      fail('Failed to fetch Campus Review');
    }
  });
}
