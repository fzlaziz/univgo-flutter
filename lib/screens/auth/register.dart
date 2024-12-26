import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:univ_go/const/theme_color.dart';
import 'package:univ_go/screens/auth/login.dart';
import 'package:univ_go/services/auth/api.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(const MainApp());

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Register Screen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
      ),
      home: const RegisterScreen(),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _obscureText = true;
  bool _isPasswordValid = false;
  bool _isPasswordMismatch = false;

  String? _emailError;
  String? _usernameError;
  String? _passwordError;
  String? _confirmPasswordError;

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final Api api = Api(); // Initialize API instance
  final RxBool _isLoading = false.obs;

  @override
  void initState() {
    super.initState();

    // Listen to changes in all fields for real-time validation
    _emailController.addListener(_validateEmail);
    _userController.addListener(_validateUsername);
    _passwordController.addListener(_validatePassword);
    _confirmPasswordController.addListener(_validateConfirmPassword);
  }

  @override
  void dispose() {
    // Dispose controllers
    _passwordController.dispose();
    _emailController.dispose();
    _userController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Email validation
  void _validateEmail() {
    final email = _emailController.text.trim();
    setState(() {
      _emailError = email.isEmpty ? 'Email Tidak Boleh Kosong' : null;
    });
  }

  // Username validation
  void _validateUsername() {
    final username = _userController.text.trim();
    setState(() {
      _usernameError = username.isEmpty ? 'Nama Tidak Boleh Kosong' : null;
    });
  }

  // Password validation
  void _validatePassword() {
    final password = _passwordController.text;
    final hasUpperCase = password.contains(RegExp(r'[A-Z]'));
    final hasDigits = password.contains(RegExp(r'[0-9]'));
    final isLengthValid = password.length >= 8;
    setState(() {
      _isPasswordValid = hasUpperCase && hasDigits && isLengthValid;
      _passwordError = !_isPasswordValid && password.isNotEmpty
          ? 'Password harus minimal 8 karakter, mengandung huruf besar dan angka'
          : null;
    });
  }

  // Confirm password validation
  void _validateConfirmPassword() {
    setState(() {
      _isPasswordMismatch =
          _passwordController.text != _confirmPasswordController.text;
      _confirmPasswordError =
          _isPasswordMismatch ? 'Password Tidak Cocok' : null;
    });
  }

  // Show message
  void _showMessage(String message, {Color backgroundColor = Colors.red}) {
    Get.snackbar(
      '',
      message,
      backgroundColor: backgroundColor,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
      snackStyle: SnackStyle.FLOATING,
      titleText: Container(),
    );
  }

  void _showLoadingDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/animations/loading.json',
                width: 100,
                height: 100,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 16),
              Text(
                'Mendaftarkan akun...',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  // Updated register method with loading state
  Future<void> _register() async {
    if (_isLoading.value) return; // Prevent multiple submissions

    _validatePassword();
    _validateConfirmPassword();
    _validateEmail();
    _validateUsername();

    final email = _emailController.text.trim();
    final username = _userController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (email.isEmpty ||
        username.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _showMessage('Isi semua dengan benar');
      return;
    }

    if (!_isPasswordValid || _isPasswordMismatch) {
      _showMessage(
          'Password harus minimal 8 karakter, mengandung huruf besar dan angka, dan sesuai dengan konfirmasi');
      return;
    }

    try {
      _isLoading.value = true;
      _showLoadingDialog();

      // Add artificial delay to show loading animation (optional)
      await Future.delayed(const Duration(milliseconds: 1500));

      final result = await api.register(
        email: email,
        name: username,
        password: password,
        passwordConfirmation: confirmPassword,
      );

      Get.back(); // Close loading dialog

      if (result['message']?.toLowerCase().contains('success') == true) {
        _showMessage(result['message'], backgroundColor: Colors.green);
        _showSuccessDialog();
      } else {
        _showMessage(result['message'] ?? 'Registrasi gagal');
      }
    } catch (e) {
      Get.back(); // Close loading dialog
      _showMessage('Terjadi kesalahan saat mendaftar');
    } finally {
      _isLoading.value = false;
    }
  }

  void _showSuccessDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 5,
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/animations/success.json',
                width: 150,
                height: 150,
                repeat: false,
              ),
              const SizedBox(height: 20),
              Text(
                'Registrasi Berhasil!',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(blueTheme),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Cek Email dan Verifikasi Akun Anda',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.offAll(() => const LoginPage()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Ke Halaman Login',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 40),
                _buildLogo(),
                const SizedBox(height: 24),
                _buildLoginText(),
                const SizedBox(height: 32),
                _buildEmailField(),
                const SizedBox(height: 16),
                _buildUserField(),
                const SizedBox(height: 16),
                _buildPasswordField(),
                const SizedBox(height: 16),
                _buildConfirmPasswordField(),
                const SizedBox(height: 24),
                _buildRegisterButton(),
                const SizedBox(height: 24),
                _buildSignUpText(),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return SizedBox(
      height: 90,
      child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
    );
  }

  Widget _buildLoginText() {
    return Column(
      children: [
        Text(
          'Register',
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Buat akun anda sekarang',
          style:
              GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.normal),
        ),
        const SizedBox(height: 6),
      ],
    );
  }

  Widget _buildEmailField() {
    return _buildTextField(
      controller: _emailController,
      hintText: 'Masukan Email',
      errorText: _emailError,
    );
  }

  Widget _buildUserField() {
    return _buildTextField(
      controller: _userController,
      hintText: 'Masukan Nama Lengkap',
      errorText: _usernameError,
    );
  }

  Widget _buildPasswordField() {
    return _buildTextField(
      controller: _passwordController,
      hintText: 'Masukan Password',
      obscureText: _obscureText,
      errorText: _passwordError,
      suffixIcon: IconButton(
        icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
        onPressed: _togglePasswordVisibility,
      ),
    );
  }

  Widget _buildConfirmPasswordField() {
    return _buildTextField(
      controller: _confirmPasswordController,
      hintText: 'Konfirmasi Password',
      obscureText: _obscureText,
      errorText: _confirmPasswordError,
      suffixIcon: IconButton(
        icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
        onPressed: _togglePasswordVisibility,
      ),
    );
  }

  // Updated register button widget
  Widget _buildRegisterButton() {
    return Obx(() => ElevatedButton(
          onPressed: _isLoading.value ? null : _register,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 20),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: _isLoading.value
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Color(blueTheme),
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  'Daftar',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(blueTheme),
                  ),
                ),
        ));
  }

  Widget _buildSignUpText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Sudah punya akun? ",
          style: GoogleFonts.poppins(),
        ),
        GestureDetector(
          onTap: () {
            Get.off(() => const LoginPage());
          },
          child: Text(
            "Login",
            style: GoogleFonts.poppins(
                color: Colors.blue, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    String? errorText,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          style: GoogleFonts.poppins(fontSize: 16),
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            hintText: hintText,
            hintStyle: GoogleFonts.poppins(fontSize: 16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: errorText != null ? Colors.red : Colors.blue,
              ),
            ),
            errorText: errorText,
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }

  void _togglePasswordVisibility() {
    setState(() => _obscureText = !_obscureText);
  }
}
