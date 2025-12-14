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
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFF101922),

      appBar: AppBar(
        backgroundColor: const Color(0xFF101922),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Thông tin cá nhân",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar + Name
            Row(
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundImage: NetworkImage(
                    user?["avatarUrl"] ??
                        "https://lh3.googleusercontent.com/aida-public/AB6AXuAjX8M_Z1is3nl6dLqf5kE9N29xvFc8kphRLNtsp3dIg0F5A0mZdrhsMpKN-jotQ0VwgIcCyI3QmM97FJKDgBzBXFo4lHQ_mh73DzoUjjQmPLqiNFHkT_7h-65ICN9I7Oq6rqUKSVWQkPl0oetEonfFIxCnm1Q3IpGKDawJ6yS0bhnoN5rtaTzf5KwGKWZ7CUiLju4Mh--FJ1jEot83s3bm5ZkIMLKguLmfq0ldVW9jKWN3InWaQa47TUmp945kk3nvnHPd4WXBuu_1",
                  ),
                ),
                const SizedBox(width: 16),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?["fullName"] ?? "",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      user?["phone"] ?? "Không có số điện thoại",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 24),

            const Text(
              "Thông tin cơ bản",
              style: TextStyle(
                color: Colors.white,
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

  Widget _infoTile(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 56,
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.05)),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF258cf4), size: 26),
          const SizedBox(width: 16),

          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ),

          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
