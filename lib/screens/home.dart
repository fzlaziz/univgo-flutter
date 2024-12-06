import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:univ_go/screens/news/news_list.dart';
import 'package:univ_go/screens/campus/profile_campus.dart';
import 'package:univ_go/const/theme_color.dart';
import 'package:univ_go/controller/home_controller.dart';
import 'package:get/get.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Rekomendasi untuk Anda',
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 2 / 2.5,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate(4, (index) {
                // List of different image URLs
                final imageUrls = [
                  'assets/images/logo_polines.png',
                  'assets/images/logo_undip.png',
                  'assets/images/logo_polkesmar.png',
                  'assets/images/logo_unnes.png',
                ];

                // List of different campus names
                final campusNames = [
                  'Politeknik Negeri Semarang',
                  'Universitas Diponegoro',
                  'Politeknik Kesehatan Semarang',
                  'Universitas Negeri Semarang',
                ];

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.5),
                            BlendMode.darken,
                          ),
                          child: Image.asset(
                            imageUrls[index % imageUrls.length],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 16,
                        left: 16,
                        right: 16,
                        child: Container(
                          height: 40, // Set a fixed height for the container
                          child: Text(
                            campusNames[index % campusNames.length],
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.visible, // Allow overflow
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        right: 16,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfileCampus()),
                            );
                          },
                          child: Text('More'),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
            const SizedBox(
              height: 16,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Top 10 PTN',
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            GetX<HomeController>(
              init: HomeController(), // Inisialisasi HomeController
              builder: (controller) {
                if (controller.ptnList.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height / 3.5,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.ptnList.length,
                      itemBuilder: (context, index) {
                        final campus = controller.ptnList[index];
                        return Container(
                          width: MediaQuery.of(context).size.width / 2,
                          margin: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {},
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              elevation: 5.0,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(15.0),
                                      child: Image.network(
                                        campus.logoPath ??
                                            'https://dummyimage.com/400x600/000/fff',
                                        height:
                                            80, // Adjust the size of the logo
                                        width: 80,
                                        fit: BoxFit.contain,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const Icon(
                                            Icons.broken_image,
                                            size: 50,
                                            color: Colors.grey,
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    Text(
                                      campus.name,
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),

            const SizedBox(
              height: 16,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Top 10 Politeknik',
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            GetX<HomeController>(
              init: HomeController(), // Inisialisasi HomeController
              builder: (controller) {
                if (controller.politeknikList.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height / 3.5,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.politeknikList.length,
                      itemBuilder: (context, index) {
                        final campus = controller.politeknikList[index];
                        return Container(
                          width: MediaQuery.of(context).size.width / 2,
                          margin: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {},
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              elevation: 5.0,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(15.0),
                                      child: Image.network(
                                        campus.logoPath ??
                                            'https://dummyimage.com/400x600/000/fff',
                                        height:
                                            80, // Adjust the size of the logo
                                        width: 80,
                                        fit: BoxFit.contain,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const Icon(
                                            Icons.broken_image,
                                            size: 50,
                                            color: Colors.grey,
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    Text(
                                      campus.name,
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),

            const SizedBox(
              height: 16,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Top 10 Kampus Swasta',
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            GetX<HomeController>(
              init: HomeController(), // Inisialisasi HomeController
              builder: (controller) {
                if (controller.swastaList.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height / 3.5,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.swastaList.length,
                      itemBuilder: (context, index) {
                        final campus = controller.swastaList[index];
                        return Container(
                          width: MediaQuery.of(context).size.width / 2,
                          margin: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {},
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              elevation: 5.0,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(15.0),
                                      child: Image.network(
                                        campus.logoPath ??
                                            'https://dummyimage.com/400x600/000/fff',
                                        height:
                                            80, // Adjust the size of the logo
                                        width: 80,
                                        fit: BoxFit.contain,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const Icon(
                                            Icons.broken_image,
                                            size: 50,
                                            color: Colors.grey,
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    Text(
                                      campus.name,
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),

            const SizedBox(height: 16.0), // Add spacing below the row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Berita Terkini',
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    // Navigate to all news page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const NewsList()),
                    );
                  },
                  icon: const Text(
                    'Lihat semua',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  label: const Icon(
                    Icons.arrow_forward,
                    color: Color(greyTheme),
                  ),
                )
              ],
            ),
            const SizedBox(height: 16.0), // Add spacing above the row
            const Row(
              children: [
                Expanded(
                  child: Text(
                    'Temukan berbagai berita kampus terkini',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0), // Add spacing below the row
            GetX<HomeController>(
              init: HomeController(), // Inisialisasi HomeController
              builder: (controller) {
                if (controller.latestNews.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: 1 / 1.5,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children:
                        List.generate(controller.latestNews.length, (index) {
                      final news = controller.latestNews[index];
                      return GestureDetector(
                        onTap: () {
                          final homeController = Get.find<HomeController>();
                          homeController.navigateToDetail(news.id);
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                child: Image.network(
                                  news.attachment ??
                                      'https://dummyimage.com/400x600/000/fff', // Default jika attachment null
                                  fit: BoxFit.cover,
                                  height:
                                      150, // Set a fixed height for the image
                                  width: double.infinity,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.broken_image,
                                      size: 50,
                                      color: Colors.grey,
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  news.title,
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2, // Menampilkan maksimal 2 baris
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  DateFormat('dd MMMM yyyy - HH:mm')
                                      .format(news.createdAt),
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
