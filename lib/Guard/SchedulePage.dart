import 'package:flutter/material.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),

      // APPBAR
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.9),
        elevation: 0,
        centerTitle: true,

        // 🔙 Nút BACK về HomePage
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Text(
          "Lịch Trình Ca Trực",
          style: TextStyle(
            color: Color(0xFF0A84FF),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            // ================= CALENDAR CARD =================
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 10),
                ],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  // Month selector
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left),
                        onPressed: () {},
                      ),
                      const Expanded(
                        child: Text(
                          "Tháng 9, 2024",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF0A84FF),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Week days
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      _DayLabel("CN"),
                      _DayLabel("T2"),
                      _DayLabel("T3"),
                      _DayLabel("T4"),
                      _DayLabel("T5"),
                      _DayLabel("T6"),
                      _DayLabel("T7"),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Calendar numbers row 1
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      _DayItem(text: "1", faded: true),
                      _DayItem(text: "2"),
                      _DayItem(text: "3"),
                      _DayItem(text: "4"),
                      _DayItem(text: "5", selected: true),
                      _DayItem(text: "6", hasDot: true),
                      _DayItem(text: "7"),
                    ],
                  ),
                ],
              ),
            ),

            // ================= TODAY SHIFTS =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // Title row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Ca trực hôm nay",
                        style: TextStyle(
                          color: Color(0xFF0A84FF),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Xem tất cả",
                        style: TextStyle(
                          color: Color(0xFF0A84FF),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Shift Card 1
                  _ShiftCard(
                    title: "Ca Tối",
                    time: "19:00 - 07:00 (12h)",
                    location: "Khu đô thị The Manor...",
                    color: const Color(0xFF0A84FF),
                    icon: Icons.schedule,
                    iconColor: Colors.white,
                    iconBackground: const Color(0xFF0A84FF),
                    border: true,
                  ),

                  const SizedBox(height: 12),

                  // Shift Card 2
                  _ShiftCard(
                    title: "Ca Sáng (Đã hoàn thành)",
                    time: "07:00 - 19:00 (12h)",
                    location: "Tòa nhà Vincom Center",
                    color: Colors.green,
                    icon: Icons.task_alt,
                    iconColor: Colors.white,
                    iconBackground: Colors.green,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),

      // ================== BOTTOM NAV ==================
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
        ),
        height: 85,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            _NavItem(icon: Icons.home, label: "Trang chủ", active: false),
            _NavItem(
              icon: Icons.calendar_month,
              label: "Lịch trình",
              active: true,
            ),
            _NavItem(icon: Icons.description, label: "Báo cáo", active: false),
            _NavItem(icon: Icons.person, label: "Tài khoản", active: false),
          ],
        ),
      ),
    );
  }
}

// ====================== Widgets ======================

class _DayLabel extends StatelessWidget {
  final String text;
  const _DayLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF8E8E93),
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _DayItem extends StatelessWidget {
  final String text;
  final bool selected;
  final bool faded;
  final bool hasDot;

  const _DayItem({
    required this.text,
    this.selected = false,
    this.faded = false,
    this.hasDot = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 38,
          height: 38,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF0A84FF) : Colors.transparent,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Text(
            text,
            style: TextStyle(
              color:
                  selected
                      ? Colors.white
                      : faded
                      ? Colors.grey
                      : Colors.black87,
              fontWeight: selected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
        if (hasDot)
          Positioned(
            bottom: 4,
            left: 16,
            child: Container(
              width: 5,
              height: 5,
              decoration: const BoxDecoration(
                color: Color(0xFF0A84FF),
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}

class _ShiftCard extends StatelessWidget {
  final String title;
  final String time;
  final String location;
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final Color color;
  final bool border;

  const _ShiftCard({
    required this.title,
    required this.time,
    required this.location,
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.color,
    this.border = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: border ? const Color(0xFFE6F3FF) : Colors.transparent,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Row(
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),

          const SizedBox(width: 16),

          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1C1C1E),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  time,
                  style: const TextStyle(
                    color: Color(0xFF636366),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 18,
                      color: Color(0xFF0A84FF),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      location,
                      style: const TextStyle(
                        color: Color(0xFF636366),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // More menu
          const Icon(Icons.more_vert, color: Color(0xFF8E8E93)),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: active ? const Color(0xFF0A84FF) : const Color(0xFF8E8E93),
          size: 26,
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: active ? FontWeight.bold : FontWeight.w500,
            color: active ? const Color(0xFF0A84FF) : const Color(0xFF8E8E93),
          ),
        ),
      ],
    );
  }
}
