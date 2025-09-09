import 'package:blenzo/extensions/navigations.dart';
import 'package:blenzo/utils/app_color.dart';
import 'package:blenzo/views/admin/brand.dart';
import 'package:blenzo/views/admin/categories.dart';
import 'package:blenzo/views/admin/product.dart';
import 'package:flutter/material.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget buildSettingItem({
    required IconData icon,
    required String title,
    String? trailingText,
    VoidCallback? onTap,
    Color? color,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: color ?? Colors.black54),
        title: Text(title),
        trailing: trailingText != null
            ? Text(trailingText, style: const TextStyle(color: Colors.grey))
            : const Icon(Icons.chevron_right),

        onTap: onTap,
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.neutral,
      appBar: AppBar(
        title: const Text(
          "Admin Panel",
          style: TextStyle(
            fontFamily: "Montserrat",
            fontWeight: FontWeight.w600,
            color: AppColor.text,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColor.neutral,
        elevation: 0,
      ),
      body: ListView(
        children: [
          buildSettingItem(
            icon: Icons.person_outline,
            title: "Brand",
            onTap: () {
              context.push(BrandListScreen());
            },
          ),
          buildSettingItem(
            icon: Icons.lock_outline,
            title: "Categories",
            onTap: () {
              context.push(CategoriesListScreen());
            },
          ),
          buildSettingItem(
            icon: Icons.notifications_none,
            title: "Product",
            onTap: () {
              context.push(ProductListScreen());
            },
          ),
        ],
      ),
    );
  }
}
