import 'package:blenzo/utils/app_color.dart';
import 'package:blenzo/widgets/reviews/my_reviews.dart';
import 'package:blenzo/widgets/reviews/to_rate_tab.dart';
import 'package:flutter/material.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Judul tanpa AppBar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Text(
                "My Rating",
                style: TextStyle(
                  fontFamily: "Montserrat",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColor.text,
                ),
              ),
            ),

            // TabBar
            TabBar(
              controller: tabController,
              labelColor: AppColor.primary,
              unselectedLabelColor: AppColor.text2,
              indicatorColor: AppColor.primary,
              tabs: const [
                Tab(text: "To Rate"),
                Tab(text: "My Reviews"),
              ],
            ),

            // TabBarView
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  ToRateTab(
                    onReviewed: (goods) {
                      setState(() {});
                    },
                  ),
                  const MyReviewsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
