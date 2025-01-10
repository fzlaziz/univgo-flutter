import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:univ_go/src/const/theme_color.dart';
import 'package:univ_go/src/features/profile_campus/models/campus_review.dart';
import 'package:univ_go/src/features/profile_campus/screens/add_campus_review.dart';
import 'package:univ_go/src/features/profile_campus/const/campus_reviews_page_style.dart';
import 'package:univ_go/src/features/profile_campus/widgets/expandable_text.dart';
import 'package:univ_go/src/features/profile_campus/services/profile_campus_provider.dart';

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
  bool _isDeleting = false;

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
                  if (userReviews.isNotEmpty) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Ulasan Kamu',
                          style: CampusReviewsPageStyle.titleStyle,
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            size: 18,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            if (userReviews.isNotEmpty) {
                              _showDeleteConfirmationDialog(userReviews.first);
                            }
                          },
                        )
                      ],
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
                          '|',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
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
      floatingActionButton: _isLoading
          ? null
          : FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddCampusReview(
                      campusId: widget.campusId,
                      initialData: userReviews.isNotEmpty
                          ? {
                              'id': userReviews.first.id,
                              'rating': userReviews.first.rating,
                              'ulasan': userReviews.first.review,
                            }
                          : null,
                      onReviewSubmitted: () {
                        _loadData(); // Refresh the reviews list
                      },
                    ),
                  ),
                );
              },
              backgroundColor: const Color(blueTheme),
              icon: const Icon(Icons.edit, color: Colors.white),
              label: Text(
                userReviews.isNotEmpty ? 'Ubah Ulasan' : 'Buat Ulasan',
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(Review review) async {
    if (!mounted) return;

    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return PopScope(
              canPop: !_isDeleting,
              child: AlertDialog(
                title: Text(
                  'Hapus Ulasan',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                content: _isDeleting
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Lottie.asset(
                            'assets/animations/loading.json',
                            width: 150,
                            height: 150,
                            fit: BoxFit.contain,
                          ),
                          Text(
                            'Menghapus ulasan...',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        'Apakah Anda yakin ingin menghapus ulasan ini?',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                        ),
                      ),
                actions: _isDeleting
                    ? null
                    : <Widget>[
                        TextButton(
                          child: Text(
                            'Batal',
                            style: GoogleFonts.poppins(
                              color: Colors.grey,
                            ),
                          ),
                          onPressed: () => Navigator.of(context).pop(false),
                        ),
                        TextButton(
                          child: Text(
                            'Hapus',
                            style: GoogleFonts.poppins(
                              color: Colors.red,
                            ),
                          ),
                          onPressed: () async {
                            setState(() => _isDeleting = true);

                            try {
                              final result =
                                  await _api.deleteCampusReview(review.id);

                              if (!mounted) return;

                              Navigator.of(context).pop(true);

                              if (result['success']) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(result['message'])),
                                );
                                await _loadData();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(result['message']),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            } catch (e) {
                              if (!mounted) return;

                              Navigator.of(context).pop(false);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(e.toString()),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            } finally {
                              if (mounted) {
                                setState(() => _isDeleting = false);
                              }
                            }
                          },
                        ),
                      ],
              ),
            );
          },
        );
      },
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
        ExpandableText(
          text: review.review,
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
