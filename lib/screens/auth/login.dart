import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:univ_go/screens/auth/register.dart';
import 'package:univ_go/services/auth/api.dart';

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
  bool _isPasswordVisible = false; // Variable to manage password visibility

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
      decoration: InputDecoration(
        labelText: 'Email',
        labelStyle: GoogleFonts.poppins(),
        hintText: 'Masukkan Email',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  TextFormField _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible, // Toggle password visibility
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: GoogleFonts.poppins(),
        hintText: 'Masukkan Password',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible
                ? Icons.visibility
                : Icons.visibility_off, // Change icon based on visibility
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible; // Toggle visibility
            });
          },
        ),
      ),
    );
  }

  SizedBox _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[800],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: _login,
        child: Text(
          'Login',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    // Validasi input
    if (email.isEmpty) {
      _showSnackBar('Email is required', Colors.red);
      return;
    }
    if (password.isEmpty) {
      _showSnackBar('Password is required', Colors.red);
      return;
    }

    // Memanggil API untuk login
    final result = await Api().login(email: email, password: password);

    // Menangani hasil
    if (result['status_code'] == 401) {
      _showSnackBar(result["message"] ?? 'Gagal melakukan login', Colors.red);
    } else if (result.containsKey('token')) {
      await Api().setToken(result['token']);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String username = result['username'] ?? 'default_username';
      await prefs.setString('username', username);

      _showSnackBar('Login successful', Colors.green);
      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      _showSnackBar('Unexpected response from server', Colors.red);
    }
  }

  void _showSnackBar(String message, Color backgroundColor) {
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

  Column _buildSignupAndForgotPasswordLinks() {
    return Column(
      children: [
        Text(
          "Belum punya akun? ",
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Get.off(RegisterScreen());
              },
              child: Text(
                "Daftar Sekarang",
                style: GoogleFonts.poppins(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
