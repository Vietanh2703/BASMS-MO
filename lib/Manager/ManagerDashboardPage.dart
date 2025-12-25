import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ManagerDashboardPage extends StatelessWidget {
  const ManagerDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F8),
      body: SafeArea(
        child: Center(
          child: Container(
            width: 500, // max width giống HTML mobile layout
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _buildHeader(),
                Expanded(child: _buildContent(context)),
                _buildBottomNav(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------
  // ⭐ HEADER
  // ---------------------------------------
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ClipOval(
                child: Image.network(
                  "https://lh3.googleusercontent.com/aida-public/AB6AXuAhMECZI8oXgOabtZg0abuSW8QLrTSGbB32DDdudC0gt_2wo8n0sBhgdEmOul8qmUlgJDcAGHgGej2MVK2q389xjwAfH_7MYDsARE_xMDqgiRKrI5rMhVPyaAYWMGUzC82fJCrqKBEbkBtx5USQXmLogCi4vsPhe7mLbO8fSy3WjVaIyBxO-rivB53ynuo1UwgiFDQDMLZtikwA-nEMPrnPB5an4m8Tt8ed7PwZrEKgw8Wbb5mEg2s7avUxzLfNa-3XrM74OkElK8gq",
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "Xin chào, Quản lý!",
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {},
              ),
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: Color(0xFFFF9F43),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "1",
                    style: TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------
  // ⭐ MAIN CONTENT
  // ---------------------------------------
  Widget _buildContent(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatsGrid(),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text(
              "Truy cập nhanh",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          _buildQuickAccess(),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text(
              "Sự cố cần xử lý gấp",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          _incidentCard(
            title: "Mất kết nối camera tại Khu A",
            time: "15 phút trước",
          ),
          _incidentCard(
            title: "Phát hiện xâm nhập tại Cổng số 2",
            time: "32 phút trước",
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  // ---------------------------------------
  // ⭐ STATS GRID
  // ---------------------------------------
  Widget _buildStatsGrid() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _statCard("Tổng ca trực", "12"),
          _statCard("Đang làm việc", "45/50"),
          _statCard("Sự cố mới", "3", color: Color(0xFFEA5455)),
          _statCard("Cảnh báo", "1", color: Color(0xFFFF9F43)),
        ],
      ),
    );
  }

  Widget _statCard(String label, String value, {Color? color}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: color ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------
  // ⭐ QUICK ACCESS — đã xoá mục "Chấm công"
  // ---------------------------------------
  Widget _buildQuickAccess() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          _quickItem(Icons.calendar_month, "Quản lý Ca trực"),
          // ❌ BỎ CHẤM CÔNG
          _quickItem(Icons.summarize, "Báo cáo sự cố"),
          _quickItem(Icons.groups, "Quản lý Đội ngũ"),
        ],
      ),
    );
  }

  Widget _quickItem(IconData icon, String title) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFF258CF4)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------
  // ⭐ INCIDENT CARD
  // ---------------------------------------
  Widget _incidentCard({required String title, required String time}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        time,
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFFEA5455).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "CAO",
                    style: TextStyle(
                      color: Color(0xFFEA5455),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: Color(0xFF258CF4),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: const Text(
                "Xem chi tiết",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------
  // ⭐ BOTTOM NAV
  // ---------------------------------------
  Widget _buildBottomNav() {
    return Container(
      width: 500,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        border: const Border(top: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(Icons.dashboard, "Tổng quan", true),
          _navItem(Icons.analytics, "Báo cáo", false),
          _navItem(Icons.badge, "Nhân viên", false),
          _navItem(Icons.account_circle, "Tài khoản", false),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, bool active) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: active ? Color(0xFF258CF4) : Colors.grey[500]),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: active ? Color(0xFF258CF4) : Colors.grey[600],
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
