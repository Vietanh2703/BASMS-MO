import 'package:adoan/Customer/SchedulePage.dart';
import 'package:flutter/material.dart';

class HomeCustomerPage extends StatelessWidget {
  const HomeCustomerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F8),

      // ---------------- HEADER ----------------
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F7F8),
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage(
              "https://lh3.googleusercontent.com/aida-public/AB6AXuA97AgHJJ3UERFUuNGgUgHcsTiHbTOzgMWZwXmhuUNuaLkQCwM_at0w7igzVMCyax6NvKPoG0CgeDPqs7lPiyvmVNPkOpC1XdVdvlHiDlqK983IPgg9Tf1cLK91p8kfcYN3eOWn7FKZ4RiKqvVWEN6F_eDA1uUmEljvLhnJeWIG9onAWjEuTvdUpFY6zGGuTNHQZy5z6_6nXgENnoEHwrU3aJUthWC2ah3MZldoyAc7FA_-Icgg4i-yngP0N8lHsbPwf_pyqzQxDloG",
            ),
          ),
        ),
        title: const Text(
          "Trang Chủ",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined, color: Colors.black),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------------- WELCOME ----------------
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Text(
                "Chào mừng, Tòa nhà ABC",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
            ),

            // ---------------- SECTION: NHÂN VIÊN ĐANG TRỰC ----------------
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 12),
              child: Text(
                "Nhân viên đang trực",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),

            SizedBox(
              height: 220,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 16),
                children: [
                  _guardCard(
                    name: "Lê Văn An",
                    id: "SG123",
                    start: "08:00",
                    img:
                        "https://lh3.googleusercontent.com/aida-public/AB6AXuDjGK_SvuZh8qGb8uArvQap382H5eYAxR7E5WEbWBjBYyW7HrsQurvX9sT_53Pu8Tgl8nbWkPkCyvCaZfYTzFtpV3JDGgQLkt4zFEtNZLoxj7AX-QHwZN250KnBnI0CfGsgALLDzzJbREAd3l9ixxAWhtRz8oDAZQ8GylcaDrzmjxXD8wfMYSzSV2mDr-CxwMkTpfeIHwSm8X3AAd199aRnCTgY3_2LN0ZRHY8i20bOH0O3xgv6yZ0ONV4ua1y1dWH9C_YGVxt3yi95",
                  ),
                  _guardCard(
                    name: "Trần Thị Bích",
                    id: "SG456",
                    start: "08:00",
                    img:
                        "https://lh3.googleusercontent.com/aida-public/AB6AXuB-yrr7whwL6n8dso6JLSkvcV32mFv9wYU_ST7vyfSS17uEgt5X1NiTHy0eFNZf9n-nLYWYtQc8NzyxN5Y0PHgZ8r_5OqxVKNvMc2KipG1JCG8v-nZJ69NUV3-C5ueIk2yDgOcypaojK-vmH8VoEoH8Lf2fwVb0p6DfMcnFUAaKardJi05zot7rZDVu9Eq8_mTuRMJcR716hTFt2tYoDL7Id-E9FTR78jbIB3dH89XxRIlY06DEre_OUf7a8Sz9uPdZc5qMgm7mZXq3",
                  ),
                  _guardCard(
                    name: "Nguyễn Văn Cường",
                    id: "SG789",
                    start: "07:30",
                    img:
                        "https://lh3.googleusercontent.com/aida-public/AB6AXuDfLIo8JVKir2b6JM5M92DdMCDt9YyVMpHqvEnWZDnqf1bEUgGKw1Fy6ZbTP8FoPK0ebWnQbwwdYXwcNt8HxV1m0glC6vx5LDA9aZRNNpQQ9Ay7UL9GwlnjfeHGAn1UIJuIL2qA3BvSePySwyKCE7qvyfatAOzsOY_T7fA2IXKH3biCkbcYxVU3NawoeKatMyP0VZ1FcbUTDmy3iyYu2f-cOAwoZ7aN7Uq1LK8m2EvTUUIt5qcVXyQpMCLSa_6oTCqweVI7DNfNgAu7",
                  ),
                ],
              ),
            ),

            // ---------------- SECTION: LỊCH TRÌNH ----------------
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Lịch trình hôm nay",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  IconButton(
                    icon: const Icon(Icons.calendar_month, color: Colors.blue),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SchedulePage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            _scheduleItem(
              start: "08:00",
              end: "17:00",
              name: "Lê Văn An",
              position: "Cổng chính",
              img:
                  "https://lh3.googleusercontent.com/aida-public/AB6AXuDtgfIch2x8OMfC4djFKczjBC2oa28nKw6graUlabSD7PfEoey-k9huHOzmvnrdLNOP5yIRA8hGSIYBnG75ru5WY0UJDDhqBtReJoeeONIGQ2-fCtsu0iUcr5QWVT7UB5jfTp102wESEueVB9RoQTFyPKDICVV9IYpB_MtXbX0YGHokQ5iqTOQLEOiOw5YhfBRMU2vHwQysIMZl-k2g7wr2p5XLr6KrGjFJb7vTC2lfJleqNjuZWM3FNCMBJtH3zUo346J9lD4iaiDt",
            ),

            _scheduleItem(
              start: "17:00",
              end: "01:00",
              name: "Phạm Thị Dung",
              position: "Tuần tra khu vực B",
              img:
                  "https://lh3.googleusercontent.com/aida-public/AB6AXuAgcflicbmUqXOsonHIH64IRK-Vod0cm2KIRYIt3CWUnJRfrZJjvVixQN00ZVujjYhbwzu0Qp0BjKO7caXiwfhw0r4DENKMndWb_lKR9sQu0nvs7VbLJF9SiX5Wye71xpZPV0QXwoQWh5P9QGstG55DOXASmV5pEfk6R8hV9Ry1xgnTtG9k0JZ8WF5ynU_eGWU9UuhYYPY2UQu0PcOZHKR737U2mroL4703r9FhKft4ygQeGobLKiAa5tKfCM7g99fUO_mcWSucVbwy",
            ),

            // ---------------- SECTION: SỰ CỐ GẦN ĐÂY ----------------
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Sự cố gần đây",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Xem tất cả",
                    style: TextStyle(color: Colors.blue, fontSize: 14),
                  ),
                ],
              ),
            ),

            _incidentItem(
              icon: Icons.priority_high,
              color: Colors.red,
              title: "Phát hiện người lạ",
              time: "15 phút trước",
              level: "Cao",
            ),

            _incidentItem(
              icon: Icons.build,
              color: Colors.orange,
              title: "Sự cố kỹ thuật camera",
              time: "2 giờ trước",
              level: "Trung Bình",
            ),

            _incidentItem(
              icon: Icons.article,
              color: Colors.grey,
              title: "Báo cáo tuần tra định kỳ",
              time: "Hôm qua",
              level: "Thấp",
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  // ---------------- CARD NHÂN VIÊN ----------------
  Widget _guardCard({
    required String name,
    required String id,
    required String start,
    required String img,
  }) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(img, fit: BoxFit.cover),
                ),
              ),
              Positioned(
                bottom: 6,
                right: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.circle, size: 10, color: Colors.white),
                      SizedBox(width: 4),
                      Text(
                        "Online",
                        style: TextStyle(fontSize: 10, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          Text("ID: $id", style: const TextStyle(color: Colors.grey)),
          Text("Bắt đầu: $start", style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  // ---------------- ITEM LỊCH TRÌNH ----------------
  Widget _scheduleItem({
    required String start,
    required String end,
    required String name,
    required String position,
    required String img,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        children: [
          Column(
            children: [
              Text(
                start,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(end, style: const TextStyle(color: Colors.grey)),
            ],
          ),
          Container(
            width: 1,
            height: 40,
            margin: const EdgeInsets.symmetric(horizontal: 12),
            color: Colors.grey.shade300,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "Vị trí: $position",
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          CircleAvatar(radius: 22, backgroundImage: NetworkImage(img)),
        ],
      ),
    );
  }

  // ---------------- ITEM SỰ CỐ ----------------
  Widget _incidentItem({
    required IconData icon,
    required Color color,
    required String title,
    required String time,
    required String level,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        children: [
          Container(
            height: 46,
            width: 46,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(time, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              level,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
