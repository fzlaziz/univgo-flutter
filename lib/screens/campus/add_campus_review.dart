import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:univ_go/services/auth/api.dart';
import 'package:univ_go/services/profile_campus/profile_campus_provider.dart';

class AddCampusReview extends StatefulWidget {
  final int campusId;
  final Map<String, dynamic>? initialData;
  final Function() onReviewSubmitted;

  const AddCampusReview({
    Key? key,
    required this.campusId,
    this.initialData,
    required this.onReviewSubmitted,
  }) : super(key: key);

  @override
  _AddCampusReviewState createState() => _AddCampusReviewState();
}

class _AddCampusReviewState extends State<AddCampusReview> {
  late TextEditingController _ulasanController;
  late int _rating;
  bool _isLoading = false;
  final _api = ProfileCampusProvider();
  late Future<Map<String, dynamic>?> _profileFuture;

  @override
  void initState() {
    super.initState();
    _ulasanController = TextEditingController(
      text: widget.initialData?['ulasan'] ?? '',
    );
    _rating = widget.initialData?['rating'] ?? 0;
    _profileFuture = _loadUserData();
  }

  Future<Map<String, dynamic>?> _loadUserData() async {
    try {
      final profileData = await Api().getProfile();
      if (profileData != null && !profileData.containsKey('message')) {
        return profileData;
      }
      return null;
    } catch (e) {
      debugPrint('Error loading profile: $e');
      return null;
    }
  }

  Widget _buildAvatar(String? imageUrl, String? username) {
    return CircleAvatar(
      radius: 25,
      backgroundColor: const Color(0xFF0059FF),
      child: imageUrl != null
          ? ClipOval(
              child: Image.network(
                imageUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _buildDefaultAvatar(),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return _buildDefaultAvatar();
                },
              ),
            )
          : _buildDefaultAvatar(),
    );
  }

  Widget _buildDefaultAvatar() {
    return const Icon(
      Icons.person,
      size: 30,
      color: Colors.white,
    );
  }

  Future<void> _kirimUlasan() async {
    if (_ulasanController.text.isEmpty || _rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap isi ulasan dan pilih rating!'),
        ),
      );
      return;
    }

    try {
      setState(() => _isLoading = true);

      Map<String, dynamic> result;
      if (widget.initialData != null) {
        // Update existing review
        result = await _api.updateCampusReview(
          widget.initialData!['id'],
          _rating,
          _ulasanController.text,
        );
      } else {
        // Add new review
        result = await _api.addCampusReview(
          widget.campusId,
          _rating,
          _ulasanController.text,
        );
      }

      if (result['success']) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['message'])),
          );
          widget.onReviewSubmitted();
          Navigator.pop(context);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['message'])),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _ulasanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.initialData != null ? 'Ubah Ulasan' : 'Buat Ulasan',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
        backgroundColor: const Color(0xFF0059FF),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
          color: Colors.white,
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final profileData = snapshot.data;
          final username = profileData?['name'] ?? 'User';
          final profileImage = profileData?['profile_image'];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildAvatar(profileImage, username),
                    const SizedBox(width: 12),
                    Text(
                      username,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Ulasan Anda akan bersifat public beserta dengan nama akun Anda',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Rating Anda',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: List.generate(
                    5,
                    (index) => IconButton(
                      icon: Icon(
                        index < _rating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                      ),
                      onPressed: () {
                        setState(() {
                          _rating = index + 1;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Tulis Ulasan',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _ulasanController,
                  maxLines: 5,
                  maxLength: 250,
                  style: GoogleFonts.poppins(),
                  decoration: InputDecoration(
                    hintText: 'Tulis ulasan Anda di sini...',
                    hintStyle: GoogleFonts.poppins(),
                    border: const OutlineInputBorder(),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF0059FF)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _kirimUlasan,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0059FF),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Kirim',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
