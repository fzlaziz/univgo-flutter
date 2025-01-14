import 'package:flutter/material.dart';
import 'package:univ_go/src/features/home/const/home_style.dart';
import 'package:univ_go/src/features/profile_campus/screens/profile_campus.dart';
import 'package:univ_go/src/features/home/widgets/top_campus_placeholder.dart';

class CampusListSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<dynamic> campusList;
  final bool isLoading;

  const CampusListSection({
    super.key,
    required this.title,
    required this.subtitle,
    required this.campusList,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: HomeStyle.titleTextStyle,
          ),
        ),
        const SizedBox(height: 5.0),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            subtitle,
            style: HomeStyle.subtitleTextStyle,
          ),
        ),
        if (isLoading || campusList.isEmpty)
          const CampusPlaceholderList()
        else
          SizedBox(
            height: MediaQuery.of(context).size.height / 3.5,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: campusList.length,
              itemBuilder: (context, index) {
                final campus = campusList[index];
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
                                      height: 65,
                                      width: 65,
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
          ),
      ],
    );
  }
}
