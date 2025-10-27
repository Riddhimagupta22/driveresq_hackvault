
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'splash_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final controller = Get.put(SplashViewModel());

  late AnimationController _animationController;
  late Animation<Offset> _carSlideAnimation;
  late Animation<double> _textFadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    // Car: from right to center
    _carSlideAnimation =
        Tween<Offset>(
          begin: const Offset(1.5, 0), // start off-screen right
          end: Offset.zero, // center of screen
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOutCubicEmphasized,
          ),
        );

    // Text: fade in after car reaches center
    _textFadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
      ),
    );

    _animationController.forward();

    // Navigate to next screen after full animation
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: Get.width,
        height: Get.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.withOpacity(0.1),
              Colors.tealAccent.withOpacity(0.1),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Car moving from right to center
            SlideTransition(
              position: _carSlideAnimation,
              child: Image.asset(
                "Assest/image/WhatsApp_Image_2025-10-27_at_14.38.12_b2e626bf-removebg-preview.png",
                height: 220,
              ),
            ),
            const SizedBox(height: 0),
            // Text fading in
            FadeTransition(
              opacity: _textFadeAnimation,
              child: Text(
                "DriveResQ",
                style: GoogleFonts.mochiyPopPOne(
                  fontSize: 22,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
