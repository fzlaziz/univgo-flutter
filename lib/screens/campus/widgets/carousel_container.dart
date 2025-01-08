import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';

// in case i will use this later, so i just comment it
// class ImageCarouselContainer extends StatelessWidget {
//   final String title;
//   final List<String> imageUrls;
//   final double height;

//   const ImageCarouselContainer({
//     Key? key,
//     required this.title,
//     required this.imageUrls,
//     this.height = 250.0,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.fromLTRB(8, 8, 8, 4),
//       width: double.infinity,
//       decoration: BoxDecoration(
//         border: Border.all(
//           color: Colors.black.withOpacity(0.2),
//           width: 0.5,
//         ),
//         borderRadius: BorderRadius.circular(5),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: GoogleFonts.poppins(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.blue,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),
//             CarouselSlider(
//               items: imageUrls.map<Widget>((url) {
//                 return Builder(
//                   builder: (BuildContext context) {
//                     return Image.network(
//                       url,
//                       fit: BoxFit.cover,
//                       width: double.infinity,
//                     );
//                   },
//                 );
//               }).toList(),
//               options: CarouselOptions(
//                 height: height,
//                 autoPlay: false,
//                 autoPlayInterval: const Duration(seconds: 5),
//                 enlargeCenterPage: true,
//                 viewportFraction: 1.0,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class ImageCarouselContainer extends StatelessWidget {
  final String title;
  final List<String>? imageUrls;
  final double height;

  const ImageCarouselContainer({
    super.key,
    required this.title,
    required this.imageUrls,
    this.height = 250.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(8, 8, 8, 4),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black.withOpacity(0.2),
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            imageUrls == null || imageUrls!.isEmpty
                ? Text(
                    'Tidak ada Data Gambar',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.black54,
                    ),
                  )
                : CarouselSlider(
                    items: imageUrls!.map<Widget>((url) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Image.network(
                            url,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          );
                        },
                      );
                    }).toList(),
                    options: CarouselOptions(
                      height: height,
                      autoPlay: false,
                      autoPlayInterval: const Duration(seconds: 5),
                      enlargeCenterPage: true,
                      viewportFraction: 1.0,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
