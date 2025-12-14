import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  DateTime? selectedDate;
  List<dynamic> schedules = [];
  bool isLoading = false;

  final String api =
      "https://api.anninhsinhtrac.com/api/shifts/get-all?contractId=aece009e-437c-4ac0-a129-4a1d05d280ab";

  @override
  void initState() {
    super.initState();
    // Khi vào trang: mặc định chọn ngày hôm nay và load dữ liệu
    selectedDate = DateTime.now();
    // gọi sau một microtask để tránh setState trong initState gây warning trong một số trường hợp
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchSchedule();
    });
  }

  Future<void> fetchSchedule() async {
    if (selectedDate == null) return;

    setState(() => isLoading = true);

    try {
      final response = await http.get(Uri.parse(api));

      setState(() => isLoading = false);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<dynamic> all = data["data"] ?? [];

        schedules =
            all.where((item) {
              final day = DateTime.parse(item["shiftDate"]);
              return day.year == selectedDate!.year &&
                  day.month == selectedDate!.month &&
                  day.day == selectedDate!.day;
            }).toList();

        setState(() {});
      } else {
        // API trả về lỗi - giữ schedules rỗng
        setState(() {
          schedules = [];
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        schedules = [];
      });
    }
  }

  Future<void> pickDate() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2026),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF258CF4)),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
      });
      fetchSchedule();
    }
  }

  String twoDigits(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCADAE1),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        title: const Text(
          "Lịch Trình",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month, color: Color(0xFF258CF4)),
            onPressed: pickDate,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hiện ngày (mặc định là hôm nay)
            if (selectedDate != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.06),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.event, color: Color(0xFF258CF4)),
                    const SizedBox(width: 12),
                    Text(
                      "${twoDigits(selectedDate!.day)}/${twoDigits(selectedDate!.month)}/${selectedDate!.year}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    // nút refresh nhỏ
                    IconButton(
                      icon: const Icon(Icons.refresh, color: Color(0xFF258CF4)),
                      onPressed: fetchSchedule,
                      tooltip: "Tải lại",
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 20),

            Expanded(
              child:
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : schedules.isEmpty
                      ? const Center(
                        child: Text(
                          "Không có ca làm trong ngày này",
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                      )
                      : ListView.builder(
                        itemCount: schedules.length,
                        itemBuilder: (context, index) {
                          final item = schedules[index];
                          final shiftStartStr = item["shiftStart"] ?? "";
                          final shiftEndStr = item["shiftEnd"] ?? "";

                          String start = "";
                          String end = "";
                          try {
                            start = shiftStartStr.toString().substring(11, 16);
                            end = shiftEndStr.toString().substring(11, 16);
                          } catch (_) {
                            // fallback nếu format khác
                          }

                          return InkWell(
                            onTap: () {
                              // Khi bấm vào card: có thể mở chi tiết tương lai
                              // Hiện tạm dialog show detail
                              showDialog(
                                context: context,
                                builder:
                                    (_) => AlertDialog(
                                      title: Text(
                                        item["locationName"] ?? "Chi tiết",
                                      ),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Địa chỉ: ${item["locationAddress"] ?? '-'}",
                                          ),
                                          const SizedBox(height: 8),
                                          Text("Bắt đầu: $start"),
                                          Text("Kết thúc: $end"),
                                          const SizedBox(height: 8),
                                          Text(
                                            "Mô tả: ${item["description"] ?? '-'}",
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed:
                                              () => Navigator.pop(context),
                                          child: const Text("Đóng"),
                                        ),
                                      ],
                                    ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 18),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(.05),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: const Color(
                                              0xFF258CF4,
                                            ).withOpacity(.15),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.location_on,
                                            color: Color(0xFF258CF4),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            item["locationName"] ??
                                                "Không có tên",
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      item["locationAddress"] ?? "",
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.access_time,
                                          size: 20,
                                          color: Colors.black54,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          "Ca: ${start.isNotEmpty ? start : '-'} - ${end.isNotEmpty ? end : '-'}",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.date_range,
                                          size: 20,
                                          color: Colors.black54,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          "Kết thúc: ${item["shiftEndDate"]?.toString().substring(0, 10) ?? '-'}",
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
