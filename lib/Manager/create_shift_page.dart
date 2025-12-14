import 'package:flutter/material.dart';

class CreateShiftPage extends StatefulWidget {
  const CreateShiftPage({super.key});

  @override
  State<CreateShiftPage> createState() => _CreateShiftPageState();
}

class _CreateShiftPageState extends State<CreateShiftPage> {
  bool repeatShift = false;
  int staffCount = 2;

  String? selectedLocation;

  List<Map<String, dynamic>> teams = [
    {
      "name": "Đội An Ninh 1",
      "members": 5,
      "avatar":
          "https://lh3.googleusercontent.com/aida-public/AB6AXuChzpPfte5OQgW_KpkKmocptp1m9gT8_HiS_oxekmgoL4-9auWdUsYi6Px3UHuWncITe-IXAbXpXqcELINfXXRqFsPSW2o-_CgCp5Y9QGAem154KQ_7OLo9D3dcniJtJ81yghtXModXBmt0VObuYWuJqs-0IYzYIr1G0cjRMI-hHRRGUms7XRHZkgulR7OBQYlhrJhQzvIhK1dt31TS2UVDXB7wNzNHOPETdT2cjTzD9avrIIENIP8gqP_VEegW7KjCFAX_4qtQCHqd",
      "checked": false,
    },
    {
      "name": "Đội Phản Ứng Nhanh",
      "members": 3,
      "avatar":
          "https://lh3.googleusercontent.com/aida-public/AB6AXuCYHUnzA-9Eu1WMDWruKh_8BwtVYZWcq28itqZFHycz40Eh2d3AAF_upVju1oIzkRSltbiazaHZZslXxSboHCtWYnEQEz9m1VYx2VpfWZPDn5l5s9kK6TfFnzj5wvdAuF8Lo5nv5BO4FKIeQ-fe93FpenCx_g9opvTcAigYYCGw959DJ9gq20sRt41UuMKXr5ecMRo9J9R7MRWN5htJMREl2y8NPPH64bgQir_4v-rUXuIYENRADKK3sJ9i8ANCZ1QQ_Lzf7tZXCdi2",
      "checked": true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        title: const Text(
          "Tạo Ca Mới",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle("Thông tin chung"),
            _inputField("Tên ca trực", "Ví dụ: Ca đêm tòa A"),

            const SizedBox(height: 20),
            _sectionTitle("Thời gian & Lịch trình"),

            _dateTimeRow("Ngày bắt đầu", "Giờ bắt đầu"),
            const SizedBox(height: 10),
            _dateTimeRow("Ngày kết thúc", "Giờ kết thúc"),

            const SizedBox(height: 16),
            _repeatToggle(),

            const SizedBox(height: 20),
            _sectionTitle("Địa điểm & Yêu cầu"),

            _dropdownLocation(),

            const SizedBox(height: 16),
            _staffCounter(),

            const SizedBox(height: 20),
            _sectionTitle("Phân công"),

            const Text(
              "Chọn đội để phân công vào ca trực này.",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 10),
            ...teams.map(_teamCheckbox).toList(),

            const SizedBox(height: 80),
          ],
        ),
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey)),
          color: Colors.white,
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            minimumSize: const Size(double.infinity, 55),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {},
          child: const Text(
            "Tạo Ca Trực",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  // --------------------------
  // COMPONENTS
  // --------------------------

  Widget _sectionTitle(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text.toUpperCase(),
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: Colors.grey,
      ),
    ),
  );

  Widget _inputField(String label, String placeholder) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      const SizedBox(height: 6),
      TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey.shade100,
          hintText: placeholder,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
      ),
    ],
  );

  Widget _dateTimeRow(String dateLabel, String timeLabel) => Row(
    children: [
      Expanded(child: _dateField(dateLabel)),
      const SizedBox(width: 12),
      Expanded(child: _timeField(timeLabel)),
    ],
  );

  Widget _dateField(String label) => _iconInput(label, Icons.calendar_today);
  Widget _timeField(String label) => _iconInput(label, Icons.schedule);

  Widget _iconInput(String label, IconData icon) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      const SizedBox(height: 6),
      TextField(
        decoration: InputDecoration(
          prefixIcon: Icon(icon, size: 22),
          filled: true,
          fillColor: Colors.grey.shade100,
          hintText: "Chọn",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
      ),
    ],
  );

  Widget _repeatToggle() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    height: 55,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.grey.shade100,
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: const [
            Icon(Icons.repeat, color: Colors.black54),
            SizedBox(width: 12),
            Text("Lặp lại ca", style: TextStyle(fontSize: 16)),
          ],
        ),

        Switch(
          value: repeatShift,
          activeColor: Colors.white,
          activeTrackColor: Colors.green,
          onChanged: (v) => setState(() => repeatShift = v),
        ),
      ],
    ),
  );

  Widget _dropdownLocation() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "Địa điểm/Chốt trực",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      const SizedBox(height: 6),
      DropdownButtonFormField<String>(
        value: selectedLocation,
        items:
            [
              "Sảnh chính Tòa A",
              "Cổng B khu công nghiệp",
              "Tầng hầm B1",
            ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        onChanged: (v) => setState(() => selectedLocation = v),
      ),
    ],
  );

  Widget _staffCounter() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "Số lượng nhân viên",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      const SizedBox(height: 6),

      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        height: 55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.shade100,
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _counterButton("-", () {
              if (staffCount > 1) setState(() => staffCount--);
            }),

            Text(
              "$staffCount",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            _counterButton("+", () {
              setState(() => staffCount++);
            }),
          ],
        ),
      ),
    ],
  );

  Widget _counterButton(String text, Function() onTap) => Container(
    width: 40,
    height: 40,
    decoration: BoxDecoration(
      color: text == "+" ? Colors.green.withOpacity(0.2) : Colors.grey.shade200,
      borderRadius: BorderRadius.circular(10),
    ),
    child: InkWell(
      onTap: onTap,
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: text == "+" ? Colors.green : Colors.black,
          ),
        ),
      ),
    ),
  );

  Widget _teamCheckbox(Map<String, dynamic> team) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
        color: team["checked"] ? Colors.green : Colors.grey.shade300,
      ),
      color:
          team["checked"]
              ? Colors.green.withOpacity(0.1)
              : Colors.grey.shade100,
    ),
    child: CheckboxListTile(
      value: team["checked"],
      activeColor: Colors.green,
      onChanged: (v) {
        setState(() => team["checked"] = v);
      },
      title: Row(
        children: [
          CircleAvatar(backgroundImage: NetworkImage(team["avatar"])),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                team["name"],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                "${team["members"]} thành viên",
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
      controlAffinity: ListTileControlAffinity.trailing,
    ),
  );
}
