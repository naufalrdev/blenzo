import 'package:blenzo/extensions/navigations.dart';
import 'package:blenzo/services/local/shared_prefs_service.dart';
import 'package:blenzo/utils/app_color.dart';
import 'package:blenzo/views/admin/admin_panel.dart';
import 'package:blenzo/views/auth/edit_profile.dart';
import 'package:blenzo/views/auth/onboard_screen.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
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
      body: SafeArea(
        child: ListView(
          children: [
            // Custom Header (tanpa AppBar)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(
                  "Settings",
                  style: const TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColor.text,
                  ),
                ),
              ),
            ),

            // Section General
            buildSectionTitle("General"),
            buildSettingItem(
              icon: Icons.person_outline,
              title: "Edit Profile",
              onTap: () async {
                final result = await context.push(const EditProfileScreen());
                if (result != null) {
                  setState(() {});
                }
              },
            ),
            buildSettingItem(
              icon: Icons.lock_outline,
              title: "Admin Panel",
              onTap: () {
                context.push(const AdminPanelScreen());
              },
            ),
            buildSettingItem(
              icon: Icons.notifications_none,
              title: "Notifications",
              onTap: () {},
            ),
            buildSettingItem(
              icon: Icons.security_outlined,
              title: "Security",
              onTap: () {},
            ),
            buildSettingItem(
              icon: Icons.language,
              title: "Language",
              trailingText: "English",
              onTap: () {},
            ),

            // Section Preferences
            buildSectionTitle("Preferences"),
            buildSettingItem(
              icon: Icons.description_outlined,
              title: "Legal and Policies",
              onTap: () {},
            ),
            buildSettingItem(
              icon: Icons.help_outline,
              title: "Help & Support",
              onTap: () {},
            ),

            // Logout
            const SizedBox(height: 20),
            Container(
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
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.red),
                ),
                splashColor: Colors.transparent,
                hoverColor: Colors.transparent,
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    builder: (context) {
                      return Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "Logout Confirmation",
                              style: TextStyle(
                                fontFamily: "Montserrat",
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              "Are you sure you want to log out?",
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () => Navigator.pop(context),
                                    style: OutlinedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text(
                                      "Cancel",
                                      style: TextStyle(
                                        fontFamily: "Montserrat",
                                        color: AppColor.text,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColor.primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: () {
                                      PreferenceHandler.removeUserId();
                                      PreferenceHandler.removeToken();
                                      PreferenceHandler.removeLogin();

                                      Navigator.pop(context);
                                      context.pushReplacement(
                                        const OnboardScreen(),
                                      );
                                    },
                                    child: const Text(
                                      "Logout",
                                      style: TextStyle(
                                        fontFamily: "Montserrat",
                                        color: AppColor.neutral,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
