import 'package:flutter/material.dart';

class IncidentReportPage extends StatefulWidget {
  const IncidentReportPage({super.key});

  @override
  State<IncidentReportPage> createState() => _IncidentReportPageState();
}

class _IncidentReportPageState extends State<IncidentReportPage> {
  String incidentType = "Chọn loại sự cố";
  TimeOfDay selectedTime = const TimeOfDay(hour: 14, minute: 30);
  DateTime selectedDate = DateTime(2023, 10, 27);

  TextEditingController locationController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  List<String> attachments = [
    "https://lh3.googleusercontent.com/aida-public/AB6AXuCYmCVRO9NmM0RDazH6WLTZbypJaN7MsFp8ruuYZ9bHkLPpPM45evap_Rib67x70M5-JcNN-aPn6SzEthc85548pEcJk17sk9mMLwXSS7xkISlJ14hUkCIOjwUqj9Kobg6xSYwFFiXX7WAaCcs6NNHyCuPYd0pM5E-DAOXlv_LuTleW2P3pj4DFt4WXD3q29QBZK4-f1Tuxj8a-Hq81iIWMZ03z4yh7Or-sWTApw-SHwG6cUARaYrfLlCX2nVpv9lTp05Go1XQn9fXb",
    "https://lh3.googleusercontent.com/aida-public/AB6AXuCPJtc-5PQf3gGM54t8SeZ-JXpJdXQNGcd5LKj3uxOFQwBRt5LttbWQsNRfF1QamEO9JHRZIE5zXoIN0grQNYBXC7_VLVHDR7RHx5X7UFqz7O2Ky6jV7a_sosCR2AebUILM3HCcwKH2QnNAo1x7GvrzbqoC5H1c6SPWFEksGxSn5vIdO8Vq4nITn_y-w6SuIVWI7p__5sNk9izxWjcHSrXl6SpdRA_sIm8hRUFMz_MbRR3b0fay3aMubaY_zEGHT1MT-Unny-TAD7EW",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF007AFF)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Báo Cáo Sự Cố Mới",
          style: TextStyle(
            color: Color(0xFF1C1C1E),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // LOẠI SỰ CỐ
            const Text(
              "Loại sự cố",
              style: TextStyle(color: Color(0xFF636366), fontSize: 14),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F3F8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButton<String>(
                isExpanded: true,
                underline: const SizedBox(),
                value: incidentType,
                items:
                    [
                          "Chọn loại sự cố",
                          "Trộm cắp",
                          "Phá hoại tài sản",
                          "Y tế khẩn cấp",
                          "Xâm nhập trái phép",
                          "Khác",
                        ]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                onChanged: (value) => setState(() => incidentType = value!),
              ),
            ),

            const SizedBox(height: 20),

            // THỜI GIAN
            const Text(
              "Thời gian xảy ra",
              style: TextStyle(color: Color(0xFF636366), fontSize: 14),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: _boxStyle(),
                    controller: TextEditingController(
                      text: selectedTime.format(context),
                    ),
                    readOnly: true,
                    onTap: _pickTime,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    decoration: _boxStyle(),
                    controller: TextEditingController(
                      text:
                          "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}",
                    ),
                    readOnly: true,
                    onTap: _pickDate,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ĐỊA ĐIỂM
            const Text(
              "Địa điểm",
              style: TextStyle(color: Color(0xFF636366), fontSize: 14),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: locationController,
              decoration: _boxStyle(
                suffixIcon: Icon(Icons.my_location, color: Color(0xFF007AFF)),
              ),
            ),

            const SizedBox(height: 20),

            // MÔ TẢ
            const Text(
              "Mô tả chi tiết",
              style: TextStyle(color: Color(0xFF636366), fontSize: 14),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: descriptionController,
              maxLines: 5,
              decoration: _boxStyle(),
            ),

            const SizedBox(height: 20),

            // HÌNH ẢNH
            const Text(
              "Đính kèm hình ảnh/video",
              style: TextStyle(color: Color(0xFF636366), fontSize: 14),
            ),
            const SizedBox(height: 10),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: attachments.length + 1,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                if (index < attachments.length) {
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          attachments[index],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                      Positioned(
                        right: 2,
                        top: 2,
                        child: GestureDetector(
                          onTap:
                              () => setState(() => attachments.removeAt(index)),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Color(0xFFD32F2F),
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(4),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }

                return ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF0F3F8),
                    foregroundColor: const Color(0xFF007AFF),
                  ),
                  child: const Icon(Icons.add),
                );
              },
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF007AFF),
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: const Text(
            "Gửi Báo Cáo",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          onPressed: () {},
        ),
      ),
    );
  }

  InputDecoration _boxStyle({Widget? suffixIcon}) {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFFF0F3F8),
      suffixIcon: suffixIcon,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF007AFF), width: 2),
      ),
    );
  }

  _pickTime() async {
    final t = await showTimePicker(context: context, initialTime: selectedTime);
    if (t != null) setState(() => selectedTime = t);
  }

  _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (d != null) setState(() => selectedDate = d);
  }
}
