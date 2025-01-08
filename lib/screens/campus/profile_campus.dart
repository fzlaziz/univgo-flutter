import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:univ_go/const/theme_color.dart';
import 'package:univ_go/screens/campus/campus_review.dart';
import 'package:univ_go/screens/campus/widgets/about_section.dart';
import 'package:univ_go/screens/campus/widgets/bar_chart_section.dart';
import 'package:univ_go/screens/campus/widgets/campus_news_section.dart';
import 'package:univ_go/screens/campus/widgets/campus_profile_carousel.dart';
import 'package:univ_go/screens/campus/widgets/carousel_container.dart';
import 'package:univ_go/screens/campus/widgets/info_section.dart';
import 'package:univ_go/screens/campus/widgets/review_section.dart';
import 'package:univ_go/services/profile_campus/profile_campus_provider.dart';

class ProfileCampus extends StatefulWidget {
  final int campusId;

  const ProfileCampus({super.key, required this.campusId});

  @override
  _ProfileCampusState createState() => _ProfileCampusState();
}

class _ProfileCampusState extends State<ProfileCampus> {
  final ProfileCampusProvider api = ProfileCampusProvider();

  final String awsUrl = '${dotenv.env['AWS_URL']}/';

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  Future<void> _refreshData() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: const Color(blueTheme),
        centerTitle: true,
        title: Text(
          "Profile Kampus",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: const Color(0xffffffff),
          ),
        ),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back()),
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refreshData,
        child: Center(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: FutureBuilder(
              future: Future.wait([
                api.getCampusDetail(widget.campusId),
                api.getCampusReviews(widget.campusId),
              ]),
              builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(
                    color: Color(blueTheme),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  final campusDetail = snapshot.data![0];
                  final campusReviews = snapshot.data![1];

                  return Column(
                    children: [
                      CampusProfileCarousel(
                          campusDetail: campusDetail, awsUrl: awsUrl),
                      LocationInfoCard(
                          snapshot: AsyncSnapshot.withData(
                              ConnectionState.done, campusDetail)),
                      AboutSection(
                          snapshot: AsyncSnapshot.withData(
                              ConnectionState.done, campusDetail),
                          campusId: widget.campusId),
                      const BarChartSection(),
                      ImageCarouselContainer(
                        title: 'Fasilitas',
                        imageUrls: (campusDetail.facilities ?? [])
                            .map(
                                (facility) => '$awsUrl${facility.fileLocation}')
                            .toList()
                            .cast<String>(),
                        height: 250.0,
                      ),
                      ImageCarouselContainer(
                        title: 'Galeri Kampus',
                        imageUrls: (campusDetail.galleries ?? [])
                            .map((gallery) => '$awsUrl${gallery.fileLocation}')
                            .toList()
                            .cast<String>(),
                        height: 240.0,
                      ),
                      CampusNewsContainer(
                          snapshot: AsyncSnapshot.withData(
                              ConnectionState.done, campusDetail)),
                      ReviewSection(
                        reviews: campusReviews.data.reviews ?? [],
                        totalReviews: campusReviews.data.totalReviews,
                        averageRating: campusReviews.data.averageRating,
                        campusId: widget.campusId,
                        onNavigateToReviews: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CampusReviewsPage(
                                campusId: widget.campusId,
                              ),
                            ),
                          );
                          _refreshData();
                        },
                      )
                    ],
                  );
                } else {
                  return const Text('No data available');
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
