import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:univ_go/const/theme_color.dart';
import 'package:univ_go/services/auth/api.dart';
import 'package:lottie/lottie.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Login Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  final RxBool _isLoading = false.obs;
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  String? _emailError;
  String? _passwordError;

  bool _isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegExp.hasMatch(email);
  }

  bool _isValidPassword(String password) {
    return password.length >= 6;
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
              Text(
                'Loading...',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 100), // Padding atas
                // Tambahkan logo di sini
                Image.asset(
                  'assets/images/logo.png', // Path ke logo Anda
                  height: 100, // Atur tinggi sesuai kebutuhan
                  width: 100, // Atur lebar sesuai kebutuhan
                ),
                const SizedBox(height: 20), // Spacing di bawah logo
                Text(
                  'Login',
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Welcome Back',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 40),
                _buildEmailField(),
                const SizedBox(height: 16),
                _buildPasswordField(), // Password field with eye icon
                const SizedBox(height: 24),
                _buildLoginButton(),
                const SizedBox(height: 16),
                _buildSignupAndForgotPasswordLinks(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      decoration: InputDecoration(
        labelText: 'Email',
        labelStyle: GoogleFonts.poppins(),
        hintText: 'Masukkan Email',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        errorText: _emailError,
      ),
      onChanged: (value) {
        if (_emailError != null) {
          setState(() {
            _emailError = null;
          });
        }
      },
    );
  }

  TextFormField _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: GoogleFonts.poppins(),
        hintText: 'Masukkan Password',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        errorText: _passwordError,
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
      ),
      onChanged: (value) {
        if (_passwordError != null) {
          setState(() {
            _passwordError = null;
          });
        }
      },
    );
  }

  SizedBox _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: Obx(() => ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[800],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: _isLoading.value ? null : _login,
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
                    'Login',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          )),
    );
  }

  Future<void> _login() async {
    _emailFocusNode.unfocus();
    _passwordFocusNode.unfocus();

    if (_isLoading.value) return;

    _isLoading.value = true;

    String email = _emailController.text;
    String password = _passwordController.text;

    bool hasError = false;

    setState(() {
      _emailError = null;
      _passwordError = null;
    });

    if (email.isEmpty) {
      setState(() {
        _emailError = 'Email diperlukan';
      });
      hasError = true;
    } else if (!_isValidEmail(email)) {
      setState(() {
        _emailError = 'Mohon masukkan email yang valid';
      });
      hasError = true;
    }

    if (password.isEmpty) {
      setState(() {
        _passwordError = 'Password diperlukan';
      });
      hasError = true;
    } else if (!_isValidPassword(password)) {
      setState(() {
        _passwordError = 'Password minimal 6 karakter';
      });
      hasError = true;
    }

    if (hasError) {
      _isLoading.value = false;
      _showSnackBar('Cek kembali input Anda', Colors.red);
      return;
    }

    _isLoading.value = true;

    try {
      _showLoadingDialog();

      await Future.delayed(const Duration(milliseconds: 1000));

      final result = await Api().login(email: email, password: password);

      Get.back(closeOverlays: true);

      if (result['status_code'] == 401) {
        _showSnackBar(result["message"] ?? 'Gagal melakukan login', Colors.red);
      } else if (result['status_code'] == 403 &&
          result['message'] == "Email Belum Di verifikasi") {
        _showSnackBar('Mohon Verifikasi Email Anda', Colors.red);
      } else if (result.containsKey('token')) {
        await Api().setToken(result['token']);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String username = result['username'] ?? 'default_username';
        await prefs.setString('username', username);

        _showSnackBar('Login successful', const Color(blueTheme));
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Get.back(closeOverlays: true);
        _showSnackBar('Unexpected response from server', Colors.red);
      }
    } catch (e) {
      Get.back(closeOverlays: true);
      _showSnackBar('An error occurred', Colors.red);
    } finally {
      _isLoading.value = false;
    }
  }

  void _showSnackBar(String message, Color backgroundColor) {
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

  Column _buildSignupAndForgotPasswordLinks() {
    return Column(
      children: [
        Text(
          "Belum punya akun? ",
          style: GoogleFonts.poppins(
            fontSize: 17,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Get.offNamed('/register');
              },
              child: Text(
                "Daftar Sekarang",
                style: GoogleFonts.poppins(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
