import 'package:blenzo/extensions/navigations.dart';
import 'package:blenzo/services/local/shared_prefs_service.dart';
import 'package:blenzo/utils/app_color.dart';
import 'package:blenzo/utils/app_image.dart';
import 'package:blenzo/views/home_screen.dart';
import 'package:blenzo/views/login_screen.dart';
import 'package:blenzo/views/onboard_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const id = "/splash_screen";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  void checkLogin() async {
    final isLogin = await PreferenceHandler.getLogin();
    Future.delayed(const Duration(seconds: 3)).then((_) {
      print(isLogin);
      if (isLogin == true) {
        Navigator.pushReplacementNamed(context, HomeScreen.id);
      } else {
        Navigator.pushNamed(context, OnboardScreen.id);
      }
    });
  }

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
