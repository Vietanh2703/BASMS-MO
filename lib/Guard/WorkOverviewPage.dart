import 'package:flutter/material.dart';

class WorkOverviewPage extends StatelessWidget {
  const WorkOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // NỀN TRẮNG
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Tổng Quan Giờ Làm",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.calendar_month, color: Colors.black),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -------------------------------
            //  🔵 SEGMENT (Tuần này - Tháng này)
            // -------------------------------
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    _segButton("Tuần này", true),
                    _segButton("Tháng này", false),
                  ],
                ),
              ),
            ),

            // -------------------------------
            //  🔵 STATS CARDS
            // -------------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(child: _statCard("Tổng giờ làm", "48.5")),
                  const SizedBox(width: 12),
                  Expanded(child: _statCard("Giờ thông thường", "40.0")),
                  const SizedBox(width: 12),
                  Expanded(child: _statCard("Giờ tăng ca", "8.5")),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // -------------------------------
            //  🔵 BAR CHART
            // -------------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _chartCard(),
            ),

            const SizedBox(height: 24),

            // -------------------------------
            //  🔵 CHI TIẾT CHẤM CÔNG
            // -------------------------------
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Chi tiết chấm công",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),

            const SizedBox(height: 12),

            _workItem("Thứ Tư, 20/03", "07:58", "18:02", "9.5 giờ"),
            _workItem("Thứ Ba, 19/03", "08:01", "17:30", "8.5 giờ"),
            _workItem("Thứ Hai, 18/03", "07:55", "17:35", "8.5 giờ"),

            const SizedBox(height: 100),
          ],
        ),
      ),

      // -------------------------------
      //  🔵 BOTTOM BUTTON
      // -------------------------------
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white.withOpacity(0.95),
        child: ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.receipt_long),
          label: const Text(
            "Xem Chi Tiết Bảng Lương",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF258CF4),
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // 🔹 SEGMENT BUTTON
  // ============================================================
  Widget _segButton(String text, bool active) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: active ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow:
              active ? [BoxShadow(color: Colors.black12, blurRadius: 4)] : null,
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: active ? Colors.black : Colors.grey.shade600,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // 🔹 STAT CARD
  // ============================================================
  Widget _statCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // 🔹 BAR CHART
  // ============================================================
  Widget _chartCard() {
    final bars = [0.6, 0.55, 0.9, 0.6, 0.65, 0.2, 0];

    final labels = ["T2", "T3", "T4", "T5", "T6", "T7", "CN"];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Giờ làm việc trong tuần",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            "18 Tháng 3 - 24 Tháng 3",
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(bars.length, (i) {
                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        height: bars[i] * 140,
                        decoration: BoxDecoration(
                          color:
                              i == 2
                                  ? const Color(0xFF258CF4)
                                  : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        labels[i],
                        style: TextStyle(
                          color:
                              i == 2
                                  ? const Color(0xFF258CF4)
                                  : Colors.grey.shade600,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // 🔹 WORK LOG ITEM
  // ============================================================
  Widget _workItem(String day, String checkIn, String checkOut, String hours) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  day,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "Check-in: $checkIn - Check-out: $checkOut",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
            Text(
              hours,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
