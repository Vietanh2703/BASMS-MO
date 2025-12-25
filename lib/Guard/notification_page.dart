import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101922),
      body: SafeArea(
        child: Column(
          children: [
            // -----------------------------------------------------------
            // ⭐ TOP APP BAR
            // -----------------------------------------------------------
            Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                border: const Border(bottom: BorderSide(color: Colors.white24)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),

                  const Text(
                    "Thông báo",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),

                  // Mark as read
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Đánh dấu đã đọc",
                      style: TextStyle(
                        color: Color(0xFF258CF4),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // -----------------------------------------------------------
            // ⭐ FILTER CHIP SECTION
            // -----------------------------------------------------------
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              color: Colors.black.withOpacity(0.3),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _filterChip("Tất cả", true),
                    _filterChip("Ca trực", false),
                    _filterChip("Chấm công", false),
                    _filterChip("Sự cố", false),
                    _filterChip("Hệ thống", false),
                  ],
                ),
              ),
            ),

            // -----------------------------------------------------------
            // ⭐ LIST CONTENT
            // -----------------------------------------------------------
            Expanded(
              child: ListView(
                children: [
                  _sectionHeader("Hôm nay"),

                  _notificationItem(
                    title: "Thay đổi ca trực",
                    message:
                        "Ca trực của bạn vào 18:00 hôm nay đã được chuyển sang ngày mai.",
                    icon: Icons.calendar_month,
                    minutesAgo: "5 phút",
                    unread: true,
                  ),

                  _notificationItem(
                    title: "Nhắc nhở chấm công vào ca",
                    message: "Đã đến giờ chấm công vào ca. Vui lòng thực hiện.",
                    icon: Icons.fingerprint,
                    minutesAgo: "15 phút",
                    unread: true,
                  ),

                  _sectionHeader("Hôm qua"),

                  _notificationItem(
                    title: "Phản hồi sự cố: Mất an ninh khu vực B",
                    message:
                        "Báo cáo của bạn đã được tiếp nhận và đang được xử lý.",
                    icon: Icons.report,
                    minutesAgo: "14:30",
                    unread: false,
                  ),

                  _notificationItem(
                    title: "Ca trực mới đã được phân công",
                    message: "Bạn có một ca trực mới vào thứ Sáu lúc 08:00.",
                    icon: Icons.calendar_today,
                    minutesAgo: "09:15",
                    unread: false,
                  ),

                  _sectionHeader("Tuần này"),

                  _notificationItem(
                    title: "Thông báo bảo trì hệ thống",
                    message: "Hệ thống sẽ bảo trì vào 02:00 sáng ngày 25/10.",
                    icon: Icons.system_update,
                    minutesAgo: "2 ngày",
                    unread: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ⭐ FILTER CHIP
  Widget _filterChip(String text, bool selected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF258CF4) : Colors.white10,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          color: selected ? Colors.white : Colors.white70,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ⭐ SECTION HEADER
  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ⭐ NOTIFICATION ITEM
  Widget _notificationItem({
    required String title,
    required String message,
    required IconData icon,
    required String minutesAgo,
    required bool unread,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: unread ? Colors.blue.withOpacity(0.15) : Colors.transparent,
      ),
      child: Row(
        children: [
          // ICON
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: unread ? Colors.blue.withOpacity(0.25) : Colors.white12,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: unread ? const Color(0xFF258CF4) : Colors.white70,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),

          // TITLE + MESSAGE
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: unread ? Colors.white : Colors.white70,
                    fontSize: 16,
                    fontWeight: unread ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: const TextStyle(color: Colors.white60, fontSize: 13),
                ),
              ],
            ),
          ),

          // TIME + DOT
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                minutesAgo,
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
              const SizedBox(height: 6),
              unread
                  ? Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Color(0xFF258CF4),
                      shape: BoxShape.circle,
                    ),
                  )
                  : const SizedBox(),
            ],
          ),
        ],
      ),
    );
  }
}
