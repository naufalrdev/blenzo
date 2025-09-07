import 'package:blenzo/models/user/get_user.dart';
import 'package:blenzo/services/api/user_api.dart';
import 'package:blenzo/utils/app_color.dart';
import 'package:blenzo/utils/app_image.dart';
import 'package:blenzo/widgets/category_tab.dart';
import 'package:blenzo/widgets/home_tab.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const id = "/home_screen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  GetUserModel? user;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    getUserData();
  }

  Future<void> getUserData() async {
    try {
      final data = await AuthenticationAPIUser.getProfile();
      setState(() {
        user = data;
      });
    } catch (e) {
      print("User fetch error: $e");
    }
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColor.background,
                        radius: 20,
                        backgroundImage: AssetImage(AppImage.profile),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hi, ${user?.data.name ?? "Loading..."}",
                            style: TextStyle(
                              fontFamily: "Montserrat",
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "Let's go shopping",
                            style: TextStyle(
                              fontFamily: "Montserrat",
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColor.text2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(children: [Icon(Icons.notifications_none, size: 26)]),
                ],
              ),
            ),
            TabBar(
              controller: tabController,
              labelColor: AppColor.primary,
              unselectedLabelColor: AppColor.text2,
              indicatorColor: AppColor.primary,
              tabs: [
                Tab(text: "Home"),
                Tab(text: "Categories"),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [HomeTab(), CategoryTab()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCategories() {
    return SafeArea(child: Column());
  }
}
