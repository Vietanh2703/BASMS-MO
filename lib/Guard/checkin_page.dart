import 'package:flutter/material.dart';
import 'package:adoan/Guard/Face/FaceRegistrationScreen.dart';

class CheckInPage extends StatelessWidget {
  const CheckInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),

      // ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xFF1E293B),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(
              Icons.notifications,
              color: Color(0xFF1E293B),
            ),
          ),
        ],
        title: const Text(
          "Chấm công",
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),

      // ================= BODY =================
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),

            // -------- Trạng thái --------
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  CircleAvatar(
                    radius: 5,
                    backgroundColor: Colors.orange,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Bạn đang ngoài ca trực",
                    style: TextStyle(
                      color: Color(0xFFF97316),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // -------- Thời gian --------
            Text(
              "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}",
              style: const TextStyle(
                fontSize: 56,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const Text(
              "Thứ Hai, 26 tháng 8",
              style: TextStyle(fontSize: 16, color: Color(0xFF64748B)),
            ),

            const SizedBox(height: 24),

            // -------- Bản đồ --------
            Container(
              height: 200,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
                image: const DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    "https://lh3.googleusercontent.com/aida-public/AB6AXuDCU7RC-fJNVuB2zXypmNRB9WcQ0uDR0hI6ltIjj_xDo3gmmD-e6aaspOTP-MUHAB6vsBRz89ud5DnEPww_VLHOuCclDPOiNXMSBmt0NtVXij5itYNXX7Hqa1e6LjSVS6MrXGOOMn7xjAi1evydZVj_9FpnbK95xHsx3cn1T5w03WSm0JGI4BHivku3Yd7PPChaEVPCxZPCAUiVqxThXbGq48z5-_qzWigAR87bnHigJn5NvD0Mthp3Z6Zdl5ik2BBxDS_3gVa3yBw3",
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "904 Lê Văn Việt",
              style: TextStyle(
                color: Color(0xFF1E293B),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 24),

            // -------- Thông tin ca --------
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  _ShiftInfo(
                    title: "Ca tiếp theo",
                    value: "08:00 - 16:00",
                  ),
                  _ShiftInfo(
                    title: "Vị trí",
                    value: "Cổng chính",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // -------- Quét khuôn mặt --------
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const FaceRegistrationScreen(),
                  ),
                );
              },
              child: Column(
                children: const [
                  CircleAvatar(
                    radius: 65,
                    backgroundColor: Color(0xFF2563EB),
                    child: Icon(
                      Icons.face_retouching_natural,
                      color: Colors.white,
                      size: 70,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Quét khuôn mặt để vào ca",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // -------- Đăng ký khuôn mặt --------
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const FaceRegistrationScreen(),
                  ),
                );
              },
              child: const Text(
                "Đăng ký khuôn mặt",
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF2563EB),
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),

      // ================= BOTTOM NAV =================
      bottomNavigationBar: const _BottomNav(),
    );
  }
}

// ================= SHIFT INFO =================
class _ShiftInfo extends StatelessWidget {
  final String title;
  final String value;

  const _ShiftInfo({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF64748B),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// ================= BOTTOM NAV =================
class _BottomNav extends StatelessWidget {
  const _BottomNav();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey)),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _BottomNavItem(
            icon: Icons.person_search,
            label: "Chấm công",
            isActive: true,
          ),
          _BottomNavItem(icon: Icons.report, label: "Sự cố"),
          _BottomNavItem(icon: Icons.calendar_month, label: "Lịch trực"),
          _BottomNavItem(icon: Icons.person, label: "Hồ sơ"),
        ],
      ),
    );
  }
}

// ================= NAV ITEM =================
class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;

  const _BottomNavItem({
    required this.icon,
    required this.label,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: isActive
              ? const Color(0xFF2563EB)
              : const Color(0xFF64748B),
          size: 26,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isActive
                ? const Color(0xFF2563EB)
                : const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }
}
