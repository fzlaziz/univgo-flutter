import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:univ_go/const/theme_color.dart';
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

  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _userFocus = FocusNode();

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
    _emailController.addListener(() => validateField('email'));
    _userController.addListener(() => validateField('username'));
    _passwordController.addListener(() => validateField('password'));
    _confirmPasswordController.addListener(() => validateField('confirm'));
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    _userController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Show message
  void _showMessage(String message, {Color backgroundColor = Colors.red}) {
    Get.rawSnackbar(
      message: message,
      backgroundColor: backgroundColor,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
      snackStyle: SnackStyle.FLOATING,
      snackPosition: SnackPosition.TOP,
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
                width: 150,
                height: 150,
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

  // Unified validation method
  void validateField(String field) {
    setState(() {
      switch (field) {
        case 'email':
          final email = _emailController.text.trim();
          if (email.isEmpty) {
            _emailError = 'Email tidak boleh kosong';
          } else if (!_isValidEmail(email)) {
            _emailError = 'Format email tidak valid';
          } else {
            _emailError = null;
          }
          break;

        case 'username':
          final username = _userController.text.trim();
          if (username.isEmpty) {
            _usernameError = 'Nama tidak boleh kosong';
          } else if (username.length < 3) {
            _usernameError = 'Nama minimal 3 karakter';
          } else {
            _usernameError = null;
          }
          break;

        case 'password':
          final password = _passwordController.text;
          if (password.isEmpty) {
            _passwordError = 'Password tidak boleh kosong';
            _isPasswordValid = false;
          } else if (password.length < 8) {
            _passwordError = 'Password minimal 8 karakter';
            _isPasswordValid = false;
          } else if (!password.contains(RegExp(r'[A-Z]'))) {
            _passwordError = 'Password harus mengandung huruf besar';
            _isPasswordValid = false;
          } else if (!password.contains(RegExp(r'[0-9]'))) {
            _passwordError = 'Password harus mengandung angka';
            _isPasswordValid = false;
          } else {
            _passwordError = null;
            _isPasswordValid = true;
          }
          // Revalidate confirm password when password changes
          if (_confirmPasswordController.text.isNotEmpty) {
            validateField('confirm');
          }
          break;

        case 'confirm':
          final confirmPass = _confirmPasswordController.text;
          if (confirmPass.isEmpty) {
            _confirmPasswordError = 'Konfirmasi password tidak boleh kosong';
            _isPasswordMismatch = true;
          } else if (confirmPass != _passwordController.text) {
            _confirmPasswordError = 'Password tidak cocok';
            _isPasswordMismatch = true;
          } else {
            _confirmPasswordError = null;
            _isPasswordMismatch = false;
          }
          break;
      }
    });
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Validate all fields at once
  bool _validateAll() {
    validateField('email');
    validateField('username');
    validateField('password');
    validateField('confirm');

    return _emailError == null &&
        _usernameError == null &&
        _passwordError == null &&
        _confirmPasswordError == null;
  }

  Future<void> _register() async {
    _emailFocus.unfocus();
    _userFocus.unfocus();
    _passwordFocus.unfocus();
    _confirmPasswordFocus.unfocus();
    
    if (_isLoading.value) return;

    if (!_validateAll()) {
      _showMessage('Mohon perbaiki error yang ada');
      return;
    }

    try {
      _isLoading.value = true;
      _showLoadingDialog();

      await Future.delayed(const Duration(milliseconds: 1500));

      final result = await api.register(
        email: _emailController.text.trim(),
        name: _userController.text.trim(),
        password: _passwordController.text,
        passwordConfirmation: _confirmPasswordController.text,
      );

      Get.back(); // Close loading dialog

      if (result['message']?.toLowerCase().contains('success') == true) {
        _showMessage(result['message'], backgroundColor: Colors.green);
        _showSuccessDialog();
      } else {
        _showMessage(result['message'] ?? 'Registrasi gagal');
      }
    } catch (e) {
      Get.back();
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
                  onPressed: () => Get.offAllNamed('/login'),
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
      backgroundColor: Colors.white,
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
      focusNode: _emailFocus,
      controller: _emailController,
      hintText: 'Masukan Email',
      errorText: _emailError,
      errorField: _emailError,
    );
  }

  Widget _buildUserField() {
    return _buildTextField(
      focusNode: _userFocus,
      controller: _userController,
      hintText: 'Masukan Nama Lengkap',
      errorText: _usernameError,
      errorField: _usernameError,
    );
  }

  Widget _buildPasswordField() {
    return _buildTextField(
      focusNode: _passwordFocus,
      controller: _passwordController,
      hintText: 'Masukan Password',
      obscureText: _obscureText,
      errorText: _passwordError,
      errorField: _passwordError,
      suffixIcon: IconButton(
        icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
        onPressed: _togglePasswordVisibility,
      ),
    );
  }

  Widget _buildConfirmPasswordField() {
    return _buildTextField(
      focusNode: _confirmPasswordFocus,
      controller: _confirmPasswordController,
      hintText: 'Konfirmasi Password',
      obscureText: _obscureText,
      errorText: _confirmPasswordError,
      errorField: _confirmPasswordError,
      suffixIcon: IconButton(
        icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
        onPressed: _togglePasswordVisibility,
      ),
    );
  }

  // Updated register button widget
  Widget _buildRegisterButton() {
    return Obx(() => SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _isLoading.value ? null : _register,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[800],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: _isLoading.value
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    'Daftar',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
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
          style: GoogleFonts.poppins(fontSize: 17),
        ),
        GestureDetector(
          onTap: () {
            Get.offNamed('/login');
          },
          child: Text(
            "Login",
            style: GoogleFonts.poppins(
                color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 17),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required var errorField,
    required FocusNode focusNode,
    String? errorText,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return TextField(
      focusNode: focusNode,
      onChanged: (value) {
        if (errorField != null) {
          setState(() {
            errorField = null;
          });
        }
      },
      controller: controller,
      obscureText: obscureText,
      style: GoogleFonts.poppins(fontSize: 16),
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        hintText: hintText,
        hintStyle: GoogleFonts.poppins(fontSize: 16),
        errorText: errorText,
        errorStyle: GoogleFonts.poppins(
          color: Colors.red,
          fontSize: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: errorText != null ? Colors.red : Colors.grey.shade300,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: errorText != null ? Colors.red : Colors.blue,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        suffixIcon: suffixIcon,
      ),
    );
  }

  void _togglePasswordVisibility() {
    setState(() => _obscureText = !_obscureText);
  }
}
