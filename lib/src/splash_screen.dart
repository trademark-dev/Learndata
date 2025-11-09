import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:d99_learn_data_enginnering/src/common/theme/app_images.dart';
import 'package:d99_learn_data_enginnering/src/services/status_bar_service.dart';
import 'package:d99_learn_data_enginnering/src/features/home/page/home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  bool _navigating = false;

  @override
  void initState() {
    super.initState();
    
    // Set status bar to transparent with white icons
    StatusBarService.setTransparentStatusBar();
    
    // Animation controller for splash effect
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    
    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    
    // Start the animation
    _controller.forward();
    
    // Navigate after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && !_navigating) {
        _navigating = true;
        _navigateToHome();
      }
    });
  }

  _navigateToHome() async {
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const HomePage(),
        ),
      );
    }
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.splashScreenBg),
            fit: BoxFit.cover,
          ),
        ),
        child: FadeTransition(
          opacity: _opacity,
          child: Center(
            child: SvgPicture.asset(
              AppIcons.splashIcon,
              width: 50.w,
              height: 50.h,
            ),
          ),
        ),
      ),
    );
  }
}

