import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:univ_go/src/const/theme_color.dart';

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

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _textAnimation = Tween<double>(begin: 0.0, end: 1).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Curves.easeIn,
      ),
    );

    _logoController.forward().then((_) {
      _textController.forward();
    });

    Timer(const Duration(seconds: 3), () {
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
          const Positioned(
            top: -60,
            left: -60,
            child: CircleAvatar(
              radius: 100,
              backgroundColor: Color(0xFF2974FF),
            ),
          ),
          const Positioned(
            top: 100,
            right: -40,
            child: CircleAvatar(
              radius: 80,
              backgroundColor: Color(0xFF2974FF),
            ),
          ),
          const Positioned(
            bottom: 50,
            left: -40,
            child: CircleAvatar(
              radius: 70,
              backgroundColor: Color(0xFF2974FF),
            ),
          ),
          const Positioned(
            bottom: -100,
            right: -80,
            child: CircleAvatar(
              radius: 140,
              backgroundColor: Color(0xFF2974FF),
            ),
          ),
          // Konten utama
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _logoAnimation,
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 125,
                  ),
                ),
                const SizedBox(height: 80),
                FadeTransition(
                  opacity: _textAnimation,
                  child: Column(
                    children: [
                      Text(
                        'UnivGO',
                        style: GoogleFonts.poppins(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2974FF),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Find your Campus\nEverywhere, Anytime',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: const Color(0xFF2974FF),
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
