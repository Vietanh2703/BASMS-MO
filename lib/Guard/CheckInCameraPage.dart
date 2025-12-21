import 'dart:io';
import 'package:adoan/models/shift_model.dart';
import 'package:adoan/services/attendance_service.dart';
import 'package:adoan/services/shift_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckInCameraPage extends StatefulWidget {
  final ShiftModel shift;

  const CheckInCameraPage({super.key, required this.shift});

  @override
  State<CheckInCameraPage> createState() => _CheckInCameraPageState();
}

class _CheckInCameraPageState extends State<CheckInCameraPage> {
  File? image;
  bool loading = false;

  Future<void> takePhotoAndCheckIn() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.camera);
      if (picked == null) return;

      setState(() {
        image = File(picked.path);
        loading = true;
      });

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token")!;
      final guardId = await ShiftService.getGuardIdByEmail();

      await AttendanceService.checkIn(
        token: token,
        guardId: guardId,
        shiftId: widget.shift.shiftId,
        assignmentId: widget.shift.assignmentId, // ✅
        lat: pos.latitude,
        lng: pos.longitude,
        accuracy: pos.accuracy,
        image: image!,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Điểm danh thành công")),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Check-in thất bại")),
      );
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Điểm danh")),
      body: Center(
        child: loading
            ? const CircularProgressIndicator()
            : ElevatedButton.icon(
          onPressed: takePhotoAndCheckIn,
          icon: const Icon(Icons.camera_alt),
          label: const Text("Chụp ảnh & điểm danh"),
        ),
      ),
    );
  }
}
