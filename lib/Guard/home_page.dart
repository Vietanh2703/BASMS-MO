import 'package:adoan/Guard/SchedulePage.dart';
import 'package:adoan/Guard/SettingsPage.dart';
import 'package:adoan/Guard/WorkOverviewPage.dart';
import 'package:adoan/Guard/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // ================= LOGOUT =================
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),

      body: Column(
        children: [
          // ================= HEADER =================
          Container(
            padding:
            const EdgeInsets.only(top: 50, bottom: 12, left: 16, right: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfilePage()),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.network(
                      "https://i.pravatar.cc/150",
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                Text(
                  "SafeGuard",
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Row(
                  children: [
                    IconButton(
                      onPressed: () => _logout(context),
                      icon: const Icon(Icons.logout, color: Colors.red),
                    ),
                    IconButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SettingsPage(),
                        ),
                      ),
                      icon: const Icon(Icons.settings),
                    ),
                  ],
                )
              ],
            ),
          ),

          // ================= BODY =================
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  "Xin chào, Nhân viên!",
                  style: GoogleFonts.inter(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                // ================= CHECK-IN CARD (UI ONLY) =================
                Container(
                  height: 170,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Chấm công",
                            style: GoogleFonts.inter(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade900,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Quét khuôn mặt & vân tay",
                            style: GoogleFonts.inter(
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ],
                      ),

                      Positioned(
                        right: -20,
                        top: 30,
                        child: Transform.rotate(
                          angle: -0.15,
                          child: Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(12),
                            child: ClipOval(
                              child: Image.asset(
                                "assets/icons/biometric.jpg",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Container(
                  height: 6,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                // ================= GRID MENU =================
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _menuItem(
                      title: "Lịch trực",
                      imagePath: "assets/icons/calendar_month.png",
                      color: Colors.indigo,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SchedulePage(),
                        ),
                      ),
                    ),

                    _menuItem(
                      title: "Tổng giờ",
                      imagePath: "assets/icons/access_time.png",
                      color: Colors.amber,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const WorkOverviewPage(),
                        ),
                      ),
                    ),

                    _menuItem(
                      title: "Thông tin cá nhân",
                      imagePath: "assets/icons/person.png",
                      color: Colors.teal,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProfilePage(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= MENU ITEM =================
  Widget _menuItem({
    required String title,
    String? imagePath,
    IconData? icon,
    required Color color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: imagePath != null
                  ? Padding(
                padding: const EdgeInsets.all(6),
                child: Image.asset(imagePath),
              )
                  : Icon(icon, color: color),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
