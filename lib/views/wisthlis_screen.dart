import 'package:blenzo/extensions/navigations.dart';
import 'package:blenzo/services/local/shared_prefs_service.dart';
import 'package:blenzo/utils/app_color.dart';
import 'package:blenzo/views/onboard_screen.dart';
import 'package:flutter/material.dart';

class WistListScreen extends StatefulWidget {
  const WistListScreen({super.key});
  static const id = "/wistlist_screen";

  @override
  State<WistListScreen> createState() => _WistListScreenState();
}

class _WistListScreenState extends State<WistListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: Column(
        children: [
          Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                PreferenceHandler.removeLogin();
                context.pushReplacement(OnboardScreen());
              },
              child: Text(
                "LOG OUT",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
