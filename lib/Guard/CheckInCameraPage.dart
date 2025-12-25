import 'dart:io';

import 'package:adoan/models/shift_model.dart';
import 'package:adoan/services/attendance_service.dart';
import 'package:adoan/services/shift_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckInCameraPage extends StatefulWidget {
  final ShiftModel shift;

  const CheckInCameraPage({super.key, required this.shift});

  @override
  State<CheckInCameraPage> createState() => _CheckInCameraPageState();
}

class _CheckInCameraPageState extends State<CheckInCameraPage> {
  bool loading = false;
  File? image;

  // ================= GPS =================
  Future<Position> _getLocation() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw Exception("GPS chưa bật");
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever ||
        permission == LocationPermission.denied) {
      throw Exception("Không có quyền GPS");
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  // ================= SUCCESS DIALOG =================
  Future<void> _showSuccess() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.check_circle, color: Colors.green, size: 64),
            SizedBox(height: 12),
            Text(
              "✅ Check-in thành công",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context, true);
              },
              child: const Text("OK"),
            ),
          ),
        ],
      ),
    );
  }
  Future<void> _showErrorDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.error, color: Colors.red, size: 64),
            SizedBox(height: 12),
            Text(
              "❌ Điểm danh không thành công",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ),
        ],
      ),
    );
  }

  // ================= MAIN FLOW =================
  Future<void> takePhotoAndCheckIn() async {
    try {
      setState(() => loading = true);

      final picker = ImagePicker();

      // 📸 ÉP RA JPEG (RẤT QUAN TRỌNG)
      final picked = await picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        imageQuality: 90,
        maxWidth: 1080,
      );

      if (picked == null) return;
      image = File(picked.path);

      final pos = await _getLocation();
      final prefs = await SharedPreferences.getInstance();

      final token = prefs.getString("token")!;
      final guardId = await ShiftService.getGuardIdByEmail();

      await AttendanceService.checkIn(
        token: token,
        guardId: guardId,
        shiftId: widget.shift.shiftId,
        assignmentId: widget.shift.assignmentId,
        lat: pos.latitude,
        lng: pos.longitude,
        accuracy: pos.accuracy,
        image: image!,
      );

      if (!mounted) return;
      await _showSuccess();
    } catch (e) {
      print("❌ CHECK-IN FAILED: $e");

      if (!mounted) return;
      await _showErrorDialog();
    }
    finally {
      if (mounted) setState(() => loading = false);
    }
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Điểm danh")),
      body: Center(
        child: loading
            ? const CircularProgressIndicator()
            : ElevatedButton.icon(
          icon: const Icon(Icons.camera_alt),
          label: const Text("Chụp ảnh & Check-in"),
          onPressed: takePhotoAndCheckIn,
        ),
      ),
    );
  }
}

