import 'package:adoan/Guard/CheckInCameraPage.dart';
import 'package:adoan/Guard/CheckOutCameraPage.dart';
import 'package:adoan/Guard/incident_report_page.dart';
import 'package:adoan/Guard/location_service.dart';
import 'package:adoan/models/AttendanceStatus.dart';
import 'package:adoan/models/shift_model.dart';
import 'package:adoan/services/shift_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ShiftCard extends StatefulWidget {
  final ShiftModel shift;
  const ShiftCard({super.key, required this.shift});

  @override
  State<ShiftCard> createState() => _ShiftCardState();
}

class _ShiftCardState extends State<ShiftCard> {
  AttendanceStatus? attendanceStatus;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadAttendanceStatus();
  }

  Future<void> _loadAttendanceStatus() async {
    try {
      final guardId = await ShiftService.getGuardIdByEmail();
      final status = await ShiftService.getAttendanceStatus(
        guardId: guardId,
        shiftId: widget.shift.shiftId,
      );

      setState(() {
        attendanceStatus = status;
        loading = false;
      });
    } catch (e) {
      debugPrint("❌ Load status error: $e");
      loading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat("HH:mm");
    final status = attendanceStatus?.status;

    final isCheckedIn = status == "CHECKED_IN";
    final isCheckedOut = status == "CHECKED_OUT";

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// ===== THÔNG TIN CA =====
          Row(
            children: [
              Column(
                children: [
                  Text(
                    timeFormat.format(widget.shift.shiftStart),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    timeFormat.format(widget.shift.shiftEnd),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.shift.locationName,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(widget.shift.locationAddress,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// ===== TRẠNG THÁI =====
          if (isCheckedIn)
            const Text("🟢 Đã điểm danh",
                style: TextStyle(color: Colors.green)),
          if (isCheckedOut)
            const Text("🔵 Đã chấm công",
                style: TextStyle(color: Colors.blue)),

          const SizedBox(height: 14),

          /// ===== HÀNG 1: CHECK-IN / CHECK-OUT =====
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: (isCheckedIn || isCheckedOut)
                      ? null
                      : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            CheckInCameraPage(shift: widget.shift),
                      ),
                    );
                  },
                  icon: const Icon(Icons.qr_code),
                  label: const Text("Điểm danh"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    disabledBackgroundColor: Colors.grey.shade300,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: isCheckedOut
                      ? null
                      : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            CheckOutCameraPage(shift: widget.shift),
                      ),
                    );
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text("Ra ca"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    disabledBackgroundColor: Colors.grey.shade300,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// ===== HÀNG 2: VỊ TRÍ / BÁO CÁO =====
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LocationPage(shift: widget.shift),
                      ),
                    );
                  },
                  icon: const Icon(Icons.map),
                  label: const Text("Vị trí"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    disabledBackgroundColor: Colors.grey.shade300,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => IncidentReportPage(
                          shift: widget.shift, // ✅ SỬA Ở ĐÂY
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.report_problem, size: 18),
                  label: const Text("Báo cáo"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.orange,
                    side: const BorderSide(color: Colors.orange, width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: Colors.orange.shade50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

            ],
          ),
        ],
      ),
    );
  }
}
