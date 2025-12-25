import 'package:adoan/Guard/SchedulePage.dart';
import 'package:adoan/Guard/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  // ================= LOGOUT (GIỐNG HOMEPAGE) =================
  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    final confirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Đăng xuất"),
        content: const Text("Bạn có chắc muốn đăng xuất không?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Huỷ"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              "Đăng xuất",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    await http.post(
      Uri.parse("https://api.anninhsinhtrac.com/api/users/logout"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    await prefs.remove("token");
    Navigator.pushNamedAndRemoveUntil(context, "/login", (_) => false);
  }

  // ================= ITEM UI =================
  Widget _item({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    Color iconColor = const Color(0xFF258CF4),
    bool showDivider = true,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ),
          if (showDivider)
            Container(
              height: 1,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              color: Colors.grey.withOpacity(0.2),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F8),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Cài đặt",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ================= CARD =================
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _item(
                    icon: Icons.calendar_month,
                    title: "Lịch trực",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SchedulePage(),
                      ),
                    ),
                  ),
                  _item(
                    icon: Icons.person,
                    title: "Thông tin cá nhân",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ProfilePage(),
                      ),
                    ),
                    showDivider: false,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ================= LOGOUT =================
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextButton(
                onPressed: () => _logout(context),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Text(
                    "Đăng xuất",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
