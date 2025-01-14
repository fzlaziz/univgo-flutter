import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CampusProfileCarousel extends StatelessWidget {
  const CampusProfileCarousel({
    super.key,
    required this.campusDetail,
    required this.awsUrl,
  });

  final dynamic campusDetail;
  final String awsUrl;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (campusDetail.facilities == null || campusDetail.facilities!.isEmpty)
          CarouselSlider(
            items: [
              Image.asset(
                'assets/images/campus_placeholder.jpg',
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ],
            options: CarouselOptions(
              height: 250.0,
              autoPlay: false,
              enlargeCenterPage: true,
              viewportFraction: 1.0,
            ),
          )
        else
          CarouselSlider(
            items: campusDetail.facilities!.map<Widget>((facility) {
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
              height: 250.0,
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
    );
  }
}
