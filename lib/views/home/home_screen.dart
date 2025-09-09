import 'package:blenzo/models/user/get_user.dart';
import 'package:blenzo/services/api/user_api.dart';
import 'package:blenzo/utils/app_color.dart';
import 'package:blenzo/utils/app_image.dart';
import 'package:blenzo/widgets/categories/category_tab.dart';
import 'package:blenzo/widgets/product/home_tab.dart';
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
            /// Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// Avatar & Greeting
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColor.background,
                        radius: 20,
                        backgroundImage: AssetImage(AppImage.profile),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hi, ${user?.data.name ?? "Loading..."}",
                            style: const TextStyle(
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

                  /// Notification Icon
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            title: const Text(
                              "Notifications",
                              style: TextStyle(
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            content: SizedBox(
                              width: double.maxFinite,
                              child: ListView(
                                shrinkWrap: true,
                                children: const [
                                  ListTile(
                                    leading: Icon(
                                      Icons.local_offer,
                                      color: AppColor.secondary,
                                    ),
                                    title: Text("Fashion Sale - 50% Off!"),
                                    subtitle: Text("Offer ends Sept 12, 2025"),
                                  ),
                                  Divider(),
                                  ListTile(
                                    leading: Icon(
                                      Icons.shopping_bag,
                                      color: Colors.blue,
                                    ),
                                    title: Text("Your order has been shipped"),
                                    subtitle: Text("Track Your Order"),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: const Icon(Icons.notifications_none, size: 26),
                  ),
                ],
              ),
            ),

            /// Tabs
            TabBar(
              controller: tabController,
              labelColor: AppColor.primary,
              unselectedLabelColor: AppColor.text2,
              indicatorColor: AppColor.primary,
              tabs: const [
                Tab(text: "Home"),
                Tab(text: "Categories"),
              ],
            ),

            /// Tab Content
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: const [HomeTab(), CategoryTab()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
