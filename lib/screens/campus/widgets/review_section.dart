import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:univ_go/const/theme_color.dart';
import 'package:univ_go/screens/campus/campus_review.dart';

class ReviewSection extends StatelessWidget {
  final List<Map<String, dynamic>> ulasan;
  final List<Map<String, dynamic>> ulasanSaya;
  final void Function(String nama, int rating, String ulasanBaru) tambahUlasan;
  final double avgRating;

  const ReviewSection({
    Key? key,
    required this.ulasan,
    required this.ulasanSaya,
    required this.tambahUlasan,
    required this.avgRating,
  }) : super(key: key);

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
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ulasan',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => SemuaUlasanPage(
                    //       ulasan: ulasan,
                    //       ulasanSaya: ulasanSaya,
                    //       tambahUlasan: tambahUlasan,
                    //     ),
                    //   ),
                    // );
                  },
                  child: Text(
                    'Lebih Banyak',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.blue,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  avgRating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const Icon(Icons.star, color: Colors.amber, size: 14),
                const SizedBox(width: 8),
                const Text(
                  '|',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${ulasan.length} ulasan',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SingleChildScrollView(
              child: Column(
                children: List.generate(ulasan.length, (index) {
                  final ulasanItem = ulasan[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const CircleAvatar(
                            backgroundColor: Colors.blue,
                            radius: 20,
                            child: Icon(
                              Icons.person,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ulasanItem['nama'],
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              Row(
                                children: List.generate(
                                  ulasanItem['rating'],
                                  (index) => const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        ulasanItem['ulasan'],
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Divider(thickness: 1, color: Colors.grey),
                      const SizedBox(height: 16),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
