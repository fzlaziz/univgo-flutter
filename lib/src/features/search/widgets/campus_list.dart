import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:univ_go/src/features/search/widgets/placeholder_card.dart';
import 'package:univ_go/src/features/search/models/campus_response.dart';
import 'package:univ_go/src/const/theme_color.dart';
import 'package:univ_go/src/features/profile_campus/screens/profile_campus.dart';

class CampusList extends StatelessWidget {
  final Future<List<CampusResponse>> response;
  final bool showCampus;
  final AnimationController _animationController;
  final VoidCallback onToggleView;

  const CampusList({
    super.key,
    required this.response,
    required this.showCampus,
    required AnimationController animationController,
    required this.onToggleView,
  }) : _animationController = animationController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: FutureBuilder<List<CampusResponse>>(
        future: response,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) =>
                  PlaceholderCard(animationController: _animationController),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Tidak ada kampus yang ditemukan',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: onToggleView,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(blueTheme),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(
                          color: Color(blueTheme),
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: Text(
                      'Tampilkan Program Studi',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var campus = snapshot.data![index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
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
                      elevation: 2,
                      color: Colors.grey[50],
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                            color: Color.fromARGB(255, 198, 197, 197)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(width: 8),
                            campus.logoPath != null
                                ? Image.network(
                                    campus.logoPath!,
                                    width: 30,
                                    height: 40,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        'assets/images/campus_placeholder_circle2.png',
                                        width: 30,
                                        height: 40,
                                        fit: BoxFit.contain,
                                      );
                                    },
                                  )
                                : Image.asset(
                                    'assets/images/campus_placeholder_circle2.png',
                                    width: 30,
                                    height: 40,
                                    fit: BoxFit.contain,
                                  ),
                            const SizedBox(width: 5),
                          ],
                        ),
                        title: Text(campus.name,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            )),
                        subtitle: Text(campus.description,
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: Colors.black,
                            )),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
