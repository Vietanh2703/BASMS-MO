import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/user_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    String? userId = prefs.getString("userId");

    if (token == null || userId == null) return;

    try {
      final result = await UserService.getUserById(userId, token);
      setState(() {
        user = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,

      // ---------- APP BAR ----------
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Thông tin cá nhân",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // ---------- BODY ----------
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ===== AVATAR CARD =====
            Container(
              padding: const EdgeInsets.all(16),
              decoration: _cardDecoration(),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 44,
                    backgroundImage: NetworkImage(
                      user?["avatarUrl"] ??
                          "https://i.pravatar.cc/300",
                    ),
                  ),
                  const SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?["fullName"] ?? "",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          user?["phone"] ?? "Chưa có số điện thoại",
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              "Thông tin cơ bản",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            _infoTile(Icons.person, "Họ và tên", user?["fullName"]),
            _infoTile(Icons.email, "Email", user?["email"]),
            _infoTile(
              Icons.cake,
              "Ngày sinh",
              "${user?["birthDay"]}/${user?["birthMonth"]}/${user?["birthYear"]}",
            ),
            _infoTile(
              Icons.home,
              "Địa chỉ",
              user?["address"] ?? "Chưa cập nhật",
            ),
          ],
        ),
      ),
    );
  }

  // ================= UI COMPONENTS =================

  BoxDecoration _cardDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ],
  );

  Widget _infoTile(IconData icon, String label, String? value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: _cardDecoration(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF007AFF), size: 26),
          const SizedBox(width: 16),

          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 15,
              ),
            ),
          ),

          Expanded(
            child: Text(
              value ?? "",
              textAlign: TextAlign.right,
              softWrap: true,
              maxLines: 3, // ✅ cho phép nhiều dòng
              overflow: TextOverflow.visible,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

}
