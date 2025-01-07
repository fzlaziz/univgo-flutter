import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:univ_go/components/card/latest_news_placeholder.dart';
import 'package:univ_go/components/card/top_campus_placeholder.dart';
import 'package:univ_go/components/card/recommended_campus_placeholder.dart';
import 'package:univ_go/screens/home/const/home_style.dart';
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
                'Rekomendasi Kampus Terdekat',
                style: HomeStyle.titleTextStyle,
              ),
            ),
            const SizedBox(height: 5.0),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Kampus Terdekat Dari Lokasi Anda',
                style: HomeStyle.subtitleTextStyle,
              ),
            ),
            const SizedBox(height: 16),
            GetX<HomeController>(
              init: HomeController(),
              builder: (controller) {
                if (controller.recommendedCampuses.isEmpty) {
                  return const RecommendedCampusesPlaceholder();
                }
                return GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 2 / 2.5,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: List.generate(controller.recommendedCampuses.length,
                      (index) {
                    final campus = controller.recommendedCampuses[index];
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
                              colorFilter: const ColorFilter.mode(
                                Colors.black45,
                                BlendMode.darken,
                              ),
                              child: campus.logoPath != null
                                  ? Image.network(
                                      campus.logoPath!,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.asset(
                                          'assets/images/campus_placeholder.jpg',
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    )
                                  : Image.asset(
                                      'assets/images/campus_placeholder.jpg',
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          Positioned(
                            top: 16,
                            left: 16,
                            right: 16,
                            child: Text(
                              campus.name,
                              style: HomeStyle.reccomendedCampusTextStyle,
                              overflow: TextOverflow.visible,
                            ),
                          ),
                          Positioned(
                            bottom: 16,
                            right: 16,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ProfileCampus(campusId: campus.id),
                                  ),
                                );
                              },
                              child: const Icon(
                                Icons.arrow_outward,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                );
              },
            ),
            const SizedBox(
              height: 16,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Top 10 PTN',
                style: HomeStyle.titleTextStyle,
              ),
            ),
            const SizedBox(height: 5.0),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'PTN terbaik di Indonesia',
                style: HomeStyle.subtitleTextStyle,
              ),
            ),
            GetX<HomeController>(
              init: HomeController(),
              builder: (controller) {
                if (controller.ptnList.isEmpty) {
                  return const CampusPlaceholderList();
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
                          margin: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProfileCampus(campusId: campus.id),
                                ),
                              );
                            },
                            child: Card(
                              color: Colors.white,
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
                                      child: campus.logoPath != null
                                          ? Image.network(
                                              campus.logoPath!,
                                              height: 80,
                                              width: 80,
                                              fit: BoxFit.contain,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Image.asset(
                                                  height: 50,
                                                  width: 50,
                                                  fit: BoxFit.contain,
                                                  'assets/images/campus_placeholder.jpg',
                                                );
                                              },
                                            )
                                          : Image.asset(
                                              'assets/images/campus_placeholder.jpg',
                                              height: 50,
                                              width: 50,
                                              fit: BoxFit.contain,
                                            ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    Text(
                                      campus.name,
                                      style: HomeStyle.topCampusTextStyle,
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
                style: HomeStyle.titleTextStyle,
              ),
            ),
            const SizedBox(height: 5.0),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Politeknik Terbaik di Indonesia',
                style: HomeStyle.subtitleTextStyle,
              ),
            ),
            GetX<HomeController>(
              init: HomeController(),
              builder: (controller) {
                if (controller.politeknikList.isEmpty) {
                  return const CampusPlaceholderList();
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
                          margin: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProfileCampus(campusId: campus.id),
                                ),
                              );
                            },
                            child: Card(
                              color: Colors.white,
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
                                      child: campus.logoPath != null
                                          ? Image.network(
                                              campus.logoPath!,
                                              height: 80,
                                              width: 80,
                                              fit: BoxFit.contain,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Image.asset(
                                                  height: 50,
                                                  width: 50,
                                                  fit: BoxFit.contain,
                                                  'assets/images/campus_placeholder.jpg',
                                                );
                                              },
                                            )
                                          : Image.asset(
                                              'assets/images/campus_placeholder.jpg',
                                              height: 50,
                                              width: 50,
                                              fit: BoxFit.contain,
                                            ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    Text(
                                      campus.name,
                                      style: HomeStyle.topCampusTextStyle,
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
                style: HomeStyle.titleTextStyle,
              ),
            ),
            const SizedBox(height: 5.0),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Kampus Swasta Terbaik di Indonesia',
                style: HomeStyle.subtitleTextStyle,
              ),
            ),
            GetX<HomeController>(
              init: HomeController(),
              builder: (controller) {
                if (controller.swastaList.isEmpty) {
                  return const CampusPlaceholderList();
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
                          margin: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProfileCampus(campusId: campus.id),
                                ),
                              );
                            },
                            child: Card(
                              color: Colors.white,
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
                                      child: campus.logoPath != null
                                          ? Image.network(
                                              campus.logoPath!,
                                              height: 80,
                                              width: 80,
                                              fit: BoxFit.contain,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Image.asset(
                                                  height: 50,
                                                  width: 50,
                                                  fit: BoxFit.contain,
                                                  'assets/images/campus_placeholder.jpg',
                                                );
                                              },
                                            )
                                          : Image.asset(
                                              'assets/images/campus_placeholder.jpg',
                                              height: 50,
                                              width: 50,
                                              fit: BoxFit.contain,
                                            ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    Text(
                                      campus.name,
                                      style: HomeStyle.topCampusTextStyle,
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
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Berita Terkini',
                    style: HomeStyle.titleTextStyle,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const NewsList()),
                    );
                  },
                  icon: Text('Lihat semua', style: HomeStyle.subtitleTextStyle),
                  label: const Icon(
                    Icons.arrow_forward,
                    color: Color(greyTheme),
                  ),
                )
              ],
            ),
            const SizedBox(height: 8.0),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Temukan berbagai berita kampus terkini',
                style: HomeStyle.subtitleTextStyle,
              ),
            ),
            const SizedBox(height: 16.0),
            GetX<HomeController>(
              init: HomeController(),
              builder: (controller) {
                if (controller.latestNews.isEmpty) {
                  return const NewsPlaceholder();
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
                          elevation: 5,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 0.1,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: news.attachment != null
                                      ? Image.network(
                                          news.attachment!,
                                          fit: BoxFit.cover,
                                          height: 150,
                                          width: double.infinity,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Image.asset(
                                              'assets/images/news_placeholder.jpg',
                                              fit: BoxFit.cover,
                                              height: 150,
                                              width: double.infinity,
                                            );
                                          },
                                        )
                                      : Image.asset(
                                          'assets/images/news_placeholder.jpg',
                                          fit: BoxFit.cover,
                                          height: 150,
                                          width: double.infinity,
                                        ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  news.title,
                                  style: HomeStyle.newsTitleTextStyle,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  DateFormat('dd MMMM yyyy - HH:mm')
                                      .format(news.createdAt),
                                  style: HomeStyle.newsDateTextStyle,
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
