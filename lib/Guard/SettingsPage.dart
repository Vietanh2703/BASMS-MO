import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  // ---- Widget tạo mỗi item ----
  Widget buildItem({
    required IconData icon,
    required String title,
    String? trailingText,
    bool showDivider = true,
    bool isSwitch = false,
    bool switchValue = false,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF258CF4).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: const Color(0xFF258CF4)),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),

              // --- Switch ---
              if (isSwitch)
                Switch(
                  value: switchValue,
                  activeColor: const Color(0xFF258CF4),
                  onChanged: (_) {},
                ),

              // --- Text + Arrow ---
              if (!isSwitch)
                Row(
                  children: [
                    if (trailingText != null)
                      Text(
                        trailingText,
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    const SizedBox(width: 6),
                    Icon(Icons.chevron_right, color: Colors.grey[500]),
                  ],
                ),
            ],
          ),
        ),

        // Divider
        if (showDivider)
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            color: Colors.grey.withOpacity(0.2),
          ),
      ],
    );
  }

  // ---- Widget tạo Section ----
  Widget buildSectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 6),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  // ---- Widget tạo Box ----
  Widget buildCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // nền trắng như yêu cầu
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(children: children),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F8), // nền trắng sáng
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

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ------- Section Tài khoản -------
            buildSectionTitle("Tài khoản"),
            buildCard([
              buildItem(icon: Icons.person, title: "Thông tin cá nhân"),
              buildItem(
                icon: Icons.key,
                title: "Đổi mật khẩu",
                showDivider: false,
              ),
            ]),

            const SizedBox(height: 20),

            // ------- Section Bảo mật -------
            buildSectionTitle("Bảo mật"),
            buildCard([
              buildItem(
                icon: Icons.face,
                title: "Sử dụng Face ID",
                isSwitch: true,
                switchValue: true,
              ),
              buildItem(
                icon: Icons.devices,
                title: "Quản lý thiết bị",
                showDivider: false,
              ),
            ]),

            const SizedBox(height: 20),

            // ------- Section Cài đặt chung -------
            buildSectionTitle("Cài đặt chung"),
            buildCard([
              buildItem(icon: Icons.notifications, title: "Thông báo"),
              buildItem(
                icon: Icons.language,
                title: "Ngôn ngữ",
                trailingText: "Tiếng Việt",
              ),
              buildItem(
                icon: Icons.contrast,
                title: "Giao diện",
                trailingText: "Tối",
                showDivider: false,
              ),
            ]),

            const SizedBox(height: 20),

            // ------- Section Khác -------
            buildSectionTitle("Khác"),
            buildCard([
              buildItem(icon: Icons.info, title: "Về SafeGuard"),
              buildItem(
                icon: Icons.support_agent,
                title: "Hỗ trợ & Phản hồi",
                showDivider: false,
              ),
            ]),

            const SizedBox(height: 20),

            // ------- Logout -------
            buildCard([
              TextButton(
                onPressed: () {},
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Text(
                    "Đăng xuất",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ]),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
