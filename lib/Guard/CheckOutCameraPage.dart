import 'dart:io';
import 'package:adoan/models/shift_model.dart';
import 'package:adoan/services/checkout_service.dart';
import 'package:adoan/services/shift_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckOutCameraPage extends StatefulWidget {
  final ShiftModel shift;

  const CheckOutCameraPage({super.key, required this.shift});

  @override
  State<CheckOutCameraPage> createState() => _CheckOutCameraPageState();
}

class _CheckOutCameraPageState extends State<CheckOutCameraPage> {
  File? image;
  bool loading = false;

  Future<void> takePhotoAndCheckOut() async {
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
      final guardId = await ShiftService.getGuardIdByEmail(); // ✅ GIỐNG CHECK-IN

      await CheckOutService.checkOut(
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

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Check-out thành công")),
      );

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Check-out thất bại")),
      );
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Check-out")),
      body: Center(
        child: loading
            ? const CircularProgressIndicator()
            : ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          onPressed: takePhotoAndCheckOut,
          icon: const Icon(Icons.camera_alt),
          label: const Text("Chụp ảnh & Check-out"),
        ),
      ),
    );
  }
}
