import 'package:blenzo/utils/app_color.dart';
import 'package:blenzo/views/home_screen.dart';
import 'package:blenzo/views/review_screen.dart';
import 'package:blenzo/views/settings.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

class BotNavBar1 extends StatefulWidget {
  const BotNavBar1({super.key});
  static const id = "/BotNavBar1";

  @override
  State<BotNavBar1> createState() => _BotNavBar1State();
}

class _BotNavBar1State extends State<BotNavBar1> {
  int _currentIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    ReviewScreen(),
    SettingScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _widgetOptions[_currentIndex]),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: AppColor.background),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: GNav(
              selectedIndex: _currentIndex,
              onTabChange: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: AppColor.primary,
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: Duration(milliseconds: 400),
              tabBackgroundColor: Colors.grey[100]!,
              color: Colors.black,
              tabs: [
                GButton(icon: LineIcons.home, text: "Home"),
                GButton(icon: LineIcons.shoppingCart, text: "Cart"),
                GButton(icon: LineIcons.user, text: "Setting"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
