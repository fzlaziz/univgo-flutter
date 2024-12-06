import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:univ_go/components/card/placeholder_card.dart';
import 'package:univ_go/models/campus/campus_response.dart';
import 'package:univ_go/const/theme_color.dart';

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
            return Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) =>
                    PlaceholderCard(animationController: _animationController),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Container(
                padding: const EdgeInsets.all(16.0),
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
              ),
            );
          } else {
            return Expanded(
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  var campus = snapshot.data![index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Card(
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
                                    campus.logoPath,
                                    width: 30,
                                    height: 40,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                          Icons.image_not_supported,
                                          color: Colors.black);
                                    },
                                  )
                                : const Icon(Icons.image_not_supported,
                                    color: Colors.black),
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
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
