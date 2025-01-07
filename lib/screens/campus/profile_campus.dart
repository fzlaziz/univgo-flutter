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
import 'package:univ_go/services/api_data_provider.dart';

class ProfileCampus extends StatefulWidget {
  final int campusId;

  const ProfileCampus({Key? key, required this.campusId}) : super(key: key);

  @override
  _ProfileCampusState createState() => _ProfileCampusState();
}

class _ProfileCampusState extends State<ProfileCampus> {
  final List<Map<String, dynamic>> ulasan = [
    {
      'nama': 'Elizabeth',
      'rating': 5,
      'ulasan': 'Kampusnya sangat nyaman',
    },
    {
      'nama': 'Abimanyu',
      'rating': 5,
      'ulasan': 'Fasilitasnya lengkap',
    },
  ];

  final List<Map<String, dynamic>> ulasanSaya = [];

  void tambahUlasan(String nama, int rating, String ulasanBaru) {
    setState(() {
      final ulasanBaruItem = {
        'nama': nama,
        'rating': rating,
        'ulasan': ulasanBaru
      };
      ulasan.add(ulasanBaruItem);
      ulasanSaya.add(ulasanBaruItem);
    });
  }

  ApiDataProvider api = ApiDataProvider();

  double get avgRating {
    if (ulasan.isEmpty) {
      return 0;
    }
    return ulasan
            .fold(0, (sum, item) => sum + item['rating'] as int)
            .toDouble() /
        ulasan.length;
  }

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
            future: api.getCampusDetail(widget.campusId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(
                  color: Color(blueTheme),
                );
              } else {
                if (snapshot.data != null) {
                  return Column(
                    children: [
                      Stack(
                        children: [
                          if (snapshot.data!.facilities == null ||
                              snapshot.data!.facilities!.isEmpty)
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
                              items: snapshot.data!.facilities!
                                  .map<Widget>((facility) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return Image.network(
                                      '$awsUrl${facility.fileLocation}',
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      errorBuilder:
                                          (context, error, stackTrace) {
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
                              '$awsUrl${snapshot.data!.logoPath}',
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
                                snapshot.data!.name,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      LocationInfoCard(snapshot: snapshot),
                      AboutSection(
                          snapshot: snapshot, campusId: widget.campusId),
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
                        imageUrls: snapshot.data!.facilities!
                            .map(
                                (facility) => '$awsUrl${facility.fileLocation}')
                            .toList(),
                        height: 250.0,
                      ),
                      ImageCarouselContainer(
                        title: 'Galeri Kampus',
                        imageUrls: snapshot.data!.galleries!
                            .map((gallery) => '$awsUrl${gallery.fileLocation}')
                            .toList(),
                        height: 240.0,
                      ),
                      CampusNewsContainer(snapshot: snapshot),
                      ReviewSection(
                        ulasan: ulasan,
                        ulasanSaya: ulasanSaya,
                        tambahUlasan: tambahUlasan,
                        avgRating: avgRating,
                      )
                    ],
                  );
                } else {
                  return const Text('No data available');
                }
              }
            },
          ),
        ),
      ),
    );
  }
}
