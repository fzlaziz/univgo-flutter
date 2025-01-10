import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:univ_go/src/const/theme_color.dart';
import 'package:univ_go/src/features/auth/services/auth_api_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  final RxBool _isLoading = false.obs;
  final Api api = Api();

  final _emailController = TextEditingController();
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _validateEmail = false;
  bool _validateUsername = false;
  bool _validatePassword = false;
  bool _validateConfirmPassword = false;

  final emailValidator = MultiValidator([
    RequiredValidator(errorText: 'Email tidak boleh kosong'),
    EmailValidator(errorText: 'Format email tidak valid')
  ]);

  final nameValidator = MultiValidator([
    RequiredValidator(errorText: 'Nama tidak boleh kosong'),
    MinLengthValidator(3, errorText: 'Nama minimal 3 karakter')
  ]);

  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'Password tidak boleh kosong'),
    MinLengthValidator(8, errorText: 'Password minimal 8 karakter'),
    PatternValidator(r'(?=.*?[A-Z])',
        errorText: 'Password harus mengandung huruf besar'),
    PatternValidator(r'(?=.*?[0-9])',
        errorText: 'Password harus mengandung angka')
  ]);

  String? confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password tidak boleh kosong';
    }
    if (value != _passwordController.text) {
      return 'Konfirmasi Password tidak cocok';
    }
    return null;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _userController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    setState(() {
      _validateEmail = true;
      _validateUsername = true;
      _validatePassword = true;
      _validateConfirmPassword = true;
    });

    if (_formKey.currentState?.validate() ?? false) {
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

        Get.back();

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
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
                _buildUsernameField(),
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

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      autovalidateMode: _validateEmail
          ? AutovalidateMode.onUserInteraction
          : AutovalidateMode.disabled,
      onTap: () {
        if (!_validateEmail) {
          setState(() => _validateEmail = true);
        }
      },
      validator: emailValidator,
      style: GoogleFonts.poppins(fontSize: 16),
      decoration: _getInputDecoration('Masukan Email'),
    );
  }

  Widget _buildUsernameField() {
    return TextFormField(
      controller: _userController,
      autovalidateMode: _validateUsername
          ? AutovalidateMode.onUserInteraction
          : AutovalidateMode.disabled,
      onTap: () {
        if (!_validateUsername) {
          setState(() => _validateUsername = true);
        }
      },
      validator: nameValidator,
      style: GoogleFonts.poppins(fontSize: 16),
      decoration: _getInputDecoration('Masukan Nama Lengkap'),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscureText,
      autovalidateMode: _validatePassword
          ? AutovalidateMode.onUserInteraction
          : AutovalidateMode.disabled,
      onTap: () {
        if (!_validatePassword) {
          setState(() => _validatePassword = true);
        }
      },
      onChanged: (value) {
        // Only revalidate confirm password if it's already being validated
        if (_validateConfirmPassword) {
          _formKey.currentState?.validate();
        }
      },
      validator: passwordValidator,
      style: GoogleFonts.poppins(fontSize: 16),
      decoration: _getInputDecoration('Masukan Password',
          suffixIcon: _buildPasswordVisibilityToggle()),
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: _obscureText,
      autovalidateMode: _validateConfirmPassword
          ? AutovalidateMode.onUserInteraction
          : AutovalidateMode.disabled,
      onTap: () {
        if (!_validateConfirmPassword) {
          setState(() => _validateConfirmPassword = true);
        }
      },
      validator: confirmPasswordValidator,
      style: GoogleFonts.poppins(fontSize: 16),
      decoration: _getInputDecoration('Konfirmasi Password',
          suffixIcon: _buildPasswordVisibilityToggle()),
    );
  }

  InputDecoration _getInputDecoration(String hintText, {Widget? suffixIcon}) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      hintText: hintText,
      hintStyle: GoogleFonts.poppins(fontSize: 16),
      errorStyle: GoogleFonts.poppins(
        color: Colors.red,
        fontSize: 12,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.blue, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      suffixIcon: suffixIcon,
    );
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

  IconButton _buildPasswordVisibilityToggle() {
    return IconButton(
      icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
      onPressed: () => setState(() => _obscureText = !_obscureText),
    );
  }
}
