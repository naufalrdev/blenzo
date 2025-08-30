import 'package:blenzo/utils/app_color.dart';
import 'package:blenzo/utils/app_image.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: Center(
        child: Image.asset(AppImage.logo, width: 275, fit: BoxFit.cover),
      ),
    );
  }
}
