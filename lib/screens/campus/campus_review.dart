import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:univ_go/const/theme_color.dart';
import 'package:univ_go/models/campus_review/campus_review.dart';
import 'package:univ_go/services/profile_campus/profile_campus_provider.dart';

class CampusReviewsPageStyle {
  static final TextStyle titleStyle = GoogleFonts.poppins(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: Colors.black,
  );

  static final TextStyle nameReviewStyle = GoogleFonts.poppins(
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle textReviewsStyle = GoogleFonts.poppins(
    fontSize: 13,
    color: Colors.black,
  );
}

class CampusReviewsPage extends StatefulWidget {
  final int campusId;

  const CampusReviewsPage({
    super.key,
    required this.campusId,
  });

  @override
  _CampusReviewsPageState createState() => _CampusReviewsPageState();
}

class _CampusReviewsPageState extends State<CampusReviewsPage> {
  List<Review> _reviews = [];
  bool _isLoading = true;
  int? _userId;
  num _averageRating = 0;
  int _totalReviews = 0;
  final ProfileCampusProvider _api = ProfileCampusProvider();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    _userId = prefs.getInt('user_id');
    print(_userId);
    try {
      final campusReviews = await _api.getCampusReviews(widget.campusId);
      setState(() {
        _reviews = campusReviews.data.reviews ?? [];
        _averageRating = campusReviews.data.averageRating;
        _totalReviews = campusReviews.data.totalReviews;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load reviews')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // final otherReviews =
    //     _reviews.where((review) => review.id != _userId).toList();
    final userReviews =
        _reviews.where((review) => review.userId == _userId).toList();
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: const Color(blueTheme),
        centerTitle: true,
        title: Text(
          "Ulasan Kampus",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: const Color(0xffffffff),
          ),
        ),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back()),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Reviews Section
                  if (userReviews.isNotEmpty) ...[
                    Text(
                      'Ulasan Kamu',
                      style: CampusReviewsPageStyle.titleStyle,
                    ),
                    const SizedBox(height: 16),
                    ...userReviews.map((review) => _buildReviewItem(review)),
                    const SizedBox(height: 16),
                  ],

                  // Other Reviews Section
                  if (_reviews.isNotEmpty)
                    Text(
                      'Semua Ulasan',
                      style: CampusReviewsPageStyle.titleStyle,
                    ),
                  const SizedBox(height: 10),
                  if (_reviews.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: Text('Belum ada ulasan'),
                      ),
                    )
                  else ...[
                    Row(
                      children: [
                        Text(
                          _averageRating.toStringAsFixed(1),
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        const Icon(Icons.star, color: Colors.amber, size: 14),
                        const SizedBox(width: 8),
                        Text(
                          '$_totalReviews ulasan',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ..._reviews.map((review) => _buildReviewItem(review)),
                  ],
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigator.push(
          //   // context,
          //   // MaterialPageRoute(
          //   //   builder: (context) => BuatUlasanPage(
          //   //     tambahUlasan: (nama, rating, ulasan) {
          //   //       // We'll implement this later with the API
          //   //     },
          //   //     initialData: userReviews.isNotEmpty ? userReviews.first : null,
          //   //   ),
          //   // ),
          // ).then((_) => _loadData()); // Refresh after adding/editing review
        },
        backgroundColor: const Color(0xFF0059FF),
        icon: const Icon(Icons.edit, color: Colors.white),
        label: Text(
          userReviews.isNotEmpty ? 'Ubah Ulasan' : 'Buat Ulasan',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildReviewItem(Review review) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipOval(
              child: SizedBox(
                width: 40,
                height: 40,
                child: review.userProfileImage != null
                    ? Image.network(
                        review.userProfileImage!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildDefaultAvatar();
                        },
                        loadingBuilder: (context, child, loadingProgress) {
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review.user,
                    style: CampusReviewsPageStyle.nameReviewStyle,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      ...List.generate(
                        review.rating,
                        (index) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 13,
                        ),
                      ),
                      ...List.generate(
                        5 - review.rating,
                        (index) => const Icon(
                          Icons.star_border,
                          color: Colors.amber,
                          size: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          review.review,
          style: CampusReviewsPageStyle.textReviewsStyle,
        ),
        const SizedBox(height: 5),
        const Divider(thickness: 1, color: Colors.grey),
        const SizedBox(height: 16),
      ],
    );
  }

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
}
