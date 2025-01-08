import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:univ_go/const/theme_color.dart';
import 'package:univ_go/screens/campus/widgets/about_section.dart';
import 'package:univ_go/screens/campus/widgets/bar_chart_container.dart';
import 'package:univ_go/screens/campus/widgets/campus_news_section.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
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
      body: Center(
        child: SingleChildScrollView(
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
                    Stack(
                      children: [
                        if (campusDetail.facilities == null ||
                            campusDetail.facilities!.isEmpty)
                          CarouselSlider(
                            items: [
                              Image.asset(
                                'assets/images/campus_placeholder.jpg',
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ],
                            options: CarouselOptions(
                              height: 180.0,
                              autoPlay: false,
                              enlargeCenterPage: true,
                              viewportFraction: 1.0,
                            ),
                          )
                        else
                          CarouselSlider(
                            items: campusDetail.facilities!
                                .map<Widget>((facility) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Image.network(
                                    '$awsUrl${facility.fileLocation}',
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Center(
                                        child: Icon(Icons.error),
                                      );
                                    },
                                  );
                                },
                              );
                            }).toList(),
                            options: CarouselOptions(
                              height: 180.0,
                              autoPlay: true,
                              autoPlayInterval: const Duration(seconds: 5),
                              enlargeCenterPage: true,
                              viewportFraction: 1.0,
                            ),
                          ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: Image.network(
                            '$awsUrl${campusDetail.logoPath}',
                            width: MediaQuery.of(context).size.width / 9,
                            height: MediaQuery.of(context).size.width / 9,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/images/campus_placeholder_circle2.png',
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width / 9,
                                height: MediaQuery.of(context).size.width / 9,
                              );
                            },
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            color: Colors.black.withOpacity(0.6),
                            padding: const EdgeInsets.only(top: 8, bottom: 8),
                            child: Text(
                              campusDetail.name,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    LocationInfoCard(
                        snapshot: AsyncSnapshot.withData(
                            ConnectionState.done, campusDetail)),
                    AboutSection(
                        snapshot: AsyncSnapshot.withData(
                            ConnectionState.done, campusDetail),
                        campusId: widget.campusId),
                    BarChartContainer(
                      title: 'Jumlah Mahasiswa 5 Tahun Terakhir',
                      barGroups: [
                        BarChartGroupData(x: 20, barRods: [
                          BarChartRodData(
                              fromY: 0,
                              toY: 2120,
                              width: 10,
                              color: const Color(blueTheme),
                              borderRadius: BorderRadius.zero),
                        ]),
                        BarChartGroupData(x: 21, barRods: [
                          BarChartRodData(
                              fromY: 0,
                              toY: 1990,
                              width: 10,
                              color: const Color(blueTheme),
                              borderRadius: BorderRadius.zero),
                        ]),
                        BarChartGroupData(x: 22, barRods: [
                          BarChartRodData(
                              fromY: 0,
                              toY: 2260,
                              width: 10,
                              color: const Color(blueTheme),
                              borderRadius: BorderRadius.zero),
                        ]),
                        BarChartGroupData(x: 23, barRods: [
                          BarChartRodData(
                              fromY: 0,
                              toY: 2320,
                              width: 10,
                              color: const Color(blueTheme),
                              borderRadius: BorderRadius.zero),
                        ]),
                        BarChartGroupData(x: 24, barRods: [
                          BarChartRodData(
                              fromY: 0,
                              toY: 2402,
                              width: 10,
                              color: const Color(blueTheme),
                              borderRadius: BorderRadius.zero),
                        ]),
                      ],
                    ),
                    ImageCarouselContainer(
                      title: 'Fasilitas',
                      imageUrls: (campusDetail.facilities ?? [])
                          .map((facility) => '$awsUrl${facility.fileLocation}')
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
    );
  }
}
