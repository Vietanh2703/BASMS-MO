import 'package:flutter/material.dart';
import 'package:adoan/Customer/SchedulePage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomeCustomerPage extends StatelessWidget {
  const HomeCustomerPage({super.key});
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

    if (!context.mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, "/login", (_) => false);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F8),

      // ================= HEADER =================
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage("https://i.pravatar.cc/150"),
          ),
        ),
        title: const Text(
          "Trang chủ",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () => _logout(context),
            tooltip: "Đăng xuất",
          ),
        ],
      ),


      // ================= BODY =================
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -------- WELCOME --------
            const Text(
              "Chào mừng!",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // -------- CARD LỊCH TRỰC --------
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SchedulePage(),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                height: 140,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF258CF4),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Lịch trực",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "Xem ca làm việc hôm nay",
                          style: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                    const Icon(
                      Icons.calendar_month,
                      size: 64,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
