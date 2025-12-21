import 'package:adoan/Guard/CheckInCameraPage.dart';
import 'package:adoan/Guard/location_service.dart';
import 'package:adoan/models/shift_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ShiftCard extends StatelessWidget {
  final ShiftModel shift;

  const ShiftCard({super.key, required this.shift});

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat("HH:mm");

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
        border: Border(
          left: BorderSide(
            color: shift.shiftStatus == "SCHEDULED"
                ? Colors.orange
                : Colors.blue,
            width: 4,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// THÔNG TIN CA
          Row(
            children: [
              Column(
                children: [
                  Text(
                    timeFormat.format(shift.shiftStart),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    timeFormat.format(shift.shiftEnd),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shift.locationName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            shift.locationAddress,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// NÚT CHỨC NĂNG
          Row(
            children: [
              /// ĐIỂM DANH
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CheckInCameraPage(shift: shift),
                      ),
                    );
                  },

                  icon: const Icon(Icons.qr_code),
                  label: const Text("Điểm danh"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              /// VỊ TRÍ
              /// VỊ TRÍ
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LocationPage(shift: shift),
                      ),
                    );
                  },
                  icon: const Icon(Icons.map),
                  label: const Text("Vị trí"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blue, // màu icon + text
                    side: const BorderSide(
                      color: Colors.blue, // màu viền
                      width: 1.5,
                    ),
                    backgroundColor: Colors.blue.shade50, // nền xanh nhạt (tuỳ chọn)
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
