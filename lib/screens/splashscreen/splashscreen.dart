import 'dart:async';
import 'package:flutter/material.dart';
import 'package:univ_go/screens/auth/login.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late Animation<double> _logoAnimation;
  late Animation<double> _textAnimation;

  @override
  void initState() {
    super.initState();

    // Animation for logo (Scaling effect)
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _logoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Curves.easeOutBack,
      ),
    );

    // Animation for text (Fade in effect)
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _textAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Curves.easeIn,
      ),
    );

    _logoController.forward().then((_) {
      _textController.forward();
    });

    // Timer to navigate to the next screen after 3 seconds
    Timer(const Duration(seconds: 4), () {
      Navigator.of(context).pushReplacementNamed('/login');
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Dekorasi lingkaran di latar belakang
          Positioned(
            top: -60,
            left: -60,
            child: CircleAvatar(
              radius: 100,
              backgroundColor: Colors.blue[400],
            ),
          ),
          Positioned(
            top: 100,
            right: -40,
            child: CircleAvatar(
              radius: 80,
              backgroundColor: Colors.blue[300],
            ),
          ),
          Positioned(
            bottom: 50,
            left: -40,
            child: CircleAvatar(
              radius: 70,
              backgroundColor: Colors.blue[200],
            ),
          ),
          Positioned(
            bottom: -100,
            right: -80,
            child: CircleAvatar(
              radius: 140,
              backgroundColor: Colors.blue[400],
            ),
          ),
          Positioned(
            bottom: 90,
            right: 40,
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.blue[300],
            ),
          ),

          // Konten utama
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated Logo with ScaleTransition
                ScaleTransition(
                  scale: _logoAnimation,
                  child: Image.asset(
                    'assets/images/logo.png', // Path ke logo UnivGO Anda
                    height: 150,
                  ),
                ),
                const SizedBox(height: 20),
                // Animated Text with FadeIn effect
                FadeTransition(
                  opacity: _textAnimation,
                  child: Column(
                    children: [
                      Text(
                        'UnivGo',
                        style: GoogleFonts.poppins(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Find your Campus\nEverywhere, Anytime',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
