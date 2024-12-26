import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:univ_go/screens/auth/login.dart';
import 'package:univ_go/services/auth/api.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  File? _localProfileImage;
  String? _profileImageUrl;

  late Future<Map<String, dynamic>> userProfile;
  bool isEditing = false;

  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    userProfile = _fetchUserProfile();
  }

  Future<Map<String, dynamic>> _fetchUserProfile() async {
    final profileData = await Api().getProfile();

    if (profileData != null && !profileData.containsKey('message')) {
      setState(() {
        // Extract and store profile image URL
        _profileImageUrl = profileData['profile_image'];
        print('$_profileImageUrl');
        // Pre-fill controllers
        nameController.text = profileData['name'] ?? '';
        emailController.text = profileData['email'] ?? '';
      });
    }

    return profileData;
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);

      setState(() {
        _localProfileImage = imageFile;
      });

      // Upload image to server
      await _uploadProfileImage(imageFile);
    }
  }

  Future<void> _uploadProfileImage(File imageFile) async {
    final response = await Api().uploadProfileImage(imageFile);

    if (response['status_code'] == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? 'Upload berhasil')),
      );

      // Refresh user profile to get the new image URL
      setState(() {
        userProfile = _fetchUserProfile();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? 'Upload gagal')),
      );
    }
  }

  Widget _buildProfileImage() {
    // Priority order:
    // 1. Locally picked image (during current session)
    // 2. Network image from profile
    // 3. Default placeholder
    if (_localProfileImage != null) {
      return CircleAvatar(
        radius: 50,
        backgroundImage: FileImage(_localProfileImage!),
      );
    }

    if (_profileImageUrl != null && _profileImageUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: 50,
        child: CachedNetworkImage(
          fadeInDuration: Duration.zero,
          fadeOutDuration: Duration.zero,
          imageUrl: '${_profileImageUrl!}',
          imageBuilder: (context, imageProvider) => CircleAvatar(
            radius: 50,
            backgroundImage: imageProvider,
          ),
          placeholder: (context, url) => CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey[300],
            child: Icon(
              Icons.person,
              size: 50,
              color: Colors.grey[700],
            ),
          ),
          errorWidget: (context, url, error) => CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey[300],
            child: Icon(
              Icons.error,
              size: 50,
              color: Colors.grey[700],
            ),
          ),
        ),
      );
    }

    // Default placeholder
    return CircleAvatar(
      radius: 50,
      backgroundColor: Colors.grey[300],
      child: Icon(
        Icons.person,
        size: 50,
        color: Colors.grey[700],
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    try {
      // Show a confirmation dialog
      final shouldLogout = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          alignment: Alignment.center,
          actionsAlignment: MainAxisAlignment.center,
          title: Row(
            children: [
              Text(
                'Confirm Logout',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to log out?',
            style: GoogleFonts.poppins(),
          ),
          actionsPadding:
              const EdgeInsets.only(bottom: 10, left: 10, right: 10),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(false), // Cancel
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.grey[300],
                elevation: 0,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true), // Confirm
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.redAccent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Logout',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );

      if (shouldLogout == true) {
        // Call API logout method
        final response = await Api().logout();

        if (response['status_code'] == 200) {
          // Navigate to login screen and remove all previous routes
          Navigator.of(context).pushReplacementNamed('/login');
        } else {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['message'] ?? 'Logout failed'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      // Handle any unexpected errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FutureBuilder<Map<String, dynamic>>(
        future: userProfile,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final userData = snapshot.data;

          if (userData == null || userData.containsKey('message')) {
            return Center(
              child:
                  Text(userData?['message'] ?? 'Error fetching user profile'),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Stack(
                    children: [
                      _buildProfileImage(),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: const CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.blue,
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  userData['name'] ?? '',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  userData['email'] ?? '',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 30),
                profileDetail('Nama Lengkap', nameController, isEditing),
                const SizedBox(height: 15),
                profileDetail('Email', emailController, isEditing),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      isEditing = !isEditing;
                    });
                    if (!isEditing) {
                      saveProfile();
                    }
                  },
                  icon: const Icon(Icons.edit, color: Colors.black),
                  label: Text(
                    isEditing ? 'Save Profile' : 'Edit Profile',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => showChangePasswordDialog(context),
                  icon: const Icon(Icons.lock, color: Colors.black),
                  label: Text(
                    'Ganti Password',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => _logout(context),
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: Text(
                    'Logout',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
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

  Widget profileDetail(
      String title, TextEditingController controller, bool isEditing) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF7FF),
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(color: Colors.grey, width: 1.0),
          ),
          child: isEditing
              ? TextField(
                  controller: controller,
                  style: GoogleFonts.poppins(
                    fontSize: 16.0,
                    color: Colors.black87,
                  ),
                )
              : Text(
                  controller.text,
                  style: GoogleFonts.poppins(
                    fontSize: 16.0,
                    color: Colors.black87,
                  ),
                ),
        ),
      ],
    );
  }

  void saveProfile() async {
    final updatedProfile = {
      'name': nameController.text,
      'email': emailController.text,
    };

    final response = await Api().updateProfile(
      name: updatedProfile['name'] ?? '',
      email: updatedProfile['email'] ?? '',
      additionalFields: updatedProfile,
    );

    if (response['message'] != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'])),
      );
    }

    if (response['status_code'] == 200) {
      // Perform asynchronous work outside of setState
      final newProfile = await Api().getProfile();

      if (newProfile != null && !newProfile.containsKey('message')) {
        setState(() {
          // Update the state synchronously
          nameController.text = newProfile['name'] ?? '';
          emailController.text = newProfile['email'] ?? '';
          userProfile = Future.value(newProfile); // Update FutureBuilder
          isEditing = false; // Exit editing mode
        });
      }
    }
  }

  void showChangePasswordDialog(BuildContext context) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Colors.white,
          title: Center(
            child: Text(
              'Ganti Password',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildPasswordInputField(
                  'Password Saat Ini',
                  controller: currentPasswordController,
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                _buildPasswordInputField(
                  'New Password',
                  controller: newPasswordController,
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                _buildPasswordInputField(
                  'Confirm New Password',
                  controller: confirmPasswordController,
                  obscureText: true,
                ),
              ],
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(
                    color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              onPressed: () async {
                final result = await Api().changePassword(
                  currentPassword: currentPasswordController.text,
                  newPassword: newPasswordController.text,
                  confirmPassword: confirmPasswordController.text,
                );

                print("Server Response: $result");
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          result['message'] ?? 'Unexpected server response')),
                );
              },
              child: Text(
                'Submit',
                style: GoogleFonts.poppins(
                    color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPasswordInputField(String labelText,
      {required TextEditingController controller, bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle:
            GoogleFonts.poppins(color: Colors.grey.shade600, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
