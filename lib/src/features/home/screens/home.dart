import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:univ_go/src/features/home/widgets/latest_news_placeholder.dart';
import 'package:univ_go/src/features/home/widgets/top_campus_placeholder.dart';
import 'package:univ_go/src/features/home/widgets/recommended_campus_placeholder.dart';
import 'package:univ_go/src/features/home/const/home_style.dart';
import 'package:univ_go/src/features/profile_campus/screens/profile_campus.dart';
import 'package:univ_go/src/const/theme_color.dart';
import 'package:univ_go/src/features/home/controller/home_controller.dart';
import 'package:get/get.dart';
import 'package:univ_go/src/features/home/widgets/campus_list_section.dart';

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
            const SizedBox(height: 16),
            GetX<HomeController>(
              init: HomeController(),
              builder: (controller) {
                return CampusListSection(
                  title: 'Top 10 PTN',
                  subtitle: 'PTN terbaik di Indonesia',
                  campusList: controller.ptnList,
                  isLoading: controller.ptnList.isEmpty,
                );
              },
            ),
            const SizedBox(height: 16),
            GetX<HomeController>(
              init: HomeController(),
              builder: (controller) {
                return CampusListSection(
                  title: 'Top 10 Politeknik',
                  subtitle: 'Politeknik Terbaik di Indonesia',
                  campusList: controller.politeknikList,
                  isLoading: controller.politeknikList.isEmpty,
                );
              },
            ),
            const SizedBox(height: 16),
            GetX<HomeController>(
              init: HomeController(),
              builder: (controller) {
                return CampusListSection(
                  title: 'Top 10 Kampus Swasta',
                  subtitle: 'Kampus Swasta Terbaik di Indonesia',
                  campusList: controller.swastaList,
                  isLoading: controller.swastaList.isEmpty,
                );
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
                    Get.toNamed('/news_list');
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
