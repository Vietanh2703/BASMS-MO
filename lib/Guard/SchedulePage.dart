import 'package:adoan/models/shift_model.dart';
import 'package:adoan/services/shift_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'widgets/shift_card.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  late Future<List<ShiftModel>> futureShifts;
  DateTime selectedDate = DateTime.now(); // ✅ mặc định hôm nay

  @override
  void initState() {
    super.initState();
    futureShifts = loadShifts();
  }

  Future<List<ShiftModel>> loadShifts() async {
    final guardId = await ShiftService.getGuardIdByEmail();
    return ShiftService.getAssignedShifts(guardId);
  }

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F8),

      /// APP BAR
      appBar: AppBar(
        title: const Text(
          "Lịch Trực",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),

      /// BODY
      body: Column(
        children: [
          /// CHỌN NGÀY
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.white,
            child: Row(
              children: [
                const Icon(Icons.calendar_today, size: 18),
                const SizedBox(width: 8),
                Text(
                  DateFormat("dd/MM/yyyy").format(selectedDate),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: pickDate,
                  child: const Text("Chọn ngày"),
                ),
              ],
            ),
          ),

          /// DANH SÁCH CA TRỰC
          Expanded(
            child: FutureBuilder<List<ShiftModel>>(
              future: futureShifts,
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(
                    child: Text("Không thể tải lịch trực"),
                  );
                }

                final shifts = snapshot.data!
                    .where((shift) =>
                shift.shiftDate.year ==
                    selectedDate.year &&
                    shift.shiftDate.month ==
                        selectedDate.month &&
                    shift.shiftDate.day ==
                        selectedDate.day)
                    .toList();

                if (shifts.isEmpty) {
                  return const Center(
                    child: Text("Không có ca trực trong ngày"),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    setState(() {
                      futureShifts = loadShifts();
                    });
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: shifts.length,
                    itemBuilder: (context, index) {
                      return ShiftCard(shift: shifts[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
