import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:univ_go/models/campus_review/campus_review.dart';

class ReviewSection extends StatelessWidget {
  final List<Review> reviews;
  final int totalReviews;
  final num averageRating;

  const ReviewSection({
    super.key,
    required this.reviews,
    required this.totalReviews,
    required this.averageRating,
  });

  Widget _buildDefaultAvatar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.blue,
      ),
      child: const Icon(
        Icons.person,
        size: 30,
        color: Colors.white,
      ),
    );
  }

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
                  averageRating.toDouble().toStringAsFixed(1),
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
                  '${reviews.length} ulasan',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (reviews.isEmpty)
              Text(
                'Belum ada ulasan',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.black54,
                ),
              ),
            SingleChildScrollView(
              child: Column(
                children: List.generate(reviews.length, (index) {
                  final ulasanItem = reviews[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipOval(
                            child: SizedBox(
                              width: 40,
                              height: 40,
                              child: ulasanItem.userProfileImage != null
                                  ? Image.network(
                                      ulasanItem.userProfileImage!,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return _buildDefaultAvatar();
                                      },
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return _buildDefaultAvatar();
                                      },
                                    )
                                  : _buildDefaultAvatar(),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ulasanItem.user,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Row(
                                children: List.generate(
                                  ulasanItem.rating,
                                  (index) => const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        ulasanItem.review,
                        style: GoogleFonts.poppins(
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
