import 'package:blenzo/utils/app_color.dart';
import 'package:blenzo/views/my_reviews.dart';
import 'package:blenzo/views/to_rate_tab.dart';
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
      appBar: AppBar(
        backgroundColor: AppColor.background,
        title: Text("My Rating"),
        elevation: 0,
        bottom: TabBar(
          controller: tabController,
          labelColor: AppColor.primary,
          unselectedLabelColor: AppColor.text2,
          indicatorColor: AppColor.primary,
          tabs: [
            Tab(text: "To Rate"),
            Tab(text: "My Reviews"),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [ToRateTab(), MyReviews()],
      ),
    );
  }
}
