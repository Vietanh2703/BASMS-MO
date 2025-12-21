import 'dart:convert';
import 'dart:io';

import 'package:adoan/Guard/Face/FaceRegistrationService.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PoseStep {
  final String poseType;
  final String title;
  final String instruction;
  final IconData icon;

  PoseStep({
    required this.poseType,
    required this.title,
    required this.instruction,
    required this.icon,
  });
}

class FaceRegistrationScreen extends StatefulWidget {
  const FaceRegistrationScreen({super.key});

  @override
  State<FaceRegistrationScreen> createState() =>
      _FaceRegistrationScreenState();
}

class _FaceRegistrationScreenState extends State<FaceRegistrationScreen> {
  String? _guardId;
  bool _loading = true;
  double _progress = 0;

  late FaceRegistrationService _service;
  final ImagePicker _picker = ImagePicker();

  final Map<String, File?> images = {
    'front': null,
    'left': null,
    'right': null,
    'up': null,
    'down': null,
    'smile': null,
  };

  final List<PoseStep> poseSteps = [
    PoseStep(
      poseType: 'front',
      title: 'Chính diện',
      instruction: 'Nhìn thẳng vào camera',
      icon: Icons.face,
    ),
    PoseStep(
      poseType: 'left',
      title: 'Quay trái',
      instruction: 'Quay nhẹ sang trái',
      icon: Icons.rotate_left,
    ),
    PoseStep(
      poseType: 'right',
      title: 'Quay phải',
      instruction: 'Quay nhẹ sang phải',
      icon: Icons.rotate_right,
    ),
    PoseStep(
      poseType: 'up',
      title: 'Nhìn lên',
      instruction: 'Ngẩng đầu lên',
      icon: Icons.arrow_upward,
    ),
    PoseStep(
      poseType: 'down',
      title: 'Nhìn xuống',
      instruction: 'Cúi đầu xuống',
      icon: Icons.arrow_downward,
    ),
    PoseStep(
      poseType: 'smile',
      title: 'Cười',
      instruction: 'Cười tự nhiên',
      icon: Icons.sentiment_satisfied_alt,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadGuardId();
  }

  // ================= LOAD GUARD ID =================
  Future<void> _loadGuardId() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final email = prefs.getString('email');

    if (token == null || email == null) return;

    _service = FaceRegistrationService(token);

    final res = await http.post(
      Uri.parse(
          'https://api.anninhsinhtrac.com/api/shifts/guards/by-email'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'Email': email}),
    );

    final data = jsonDecode(res.body);

    setState(() {
      _guardId = data['guard']['id'];
      _loading = false;
    });
  }

  // ================= TAKE PHOTO =================
  Future<void> _takePhoto(String key) async {
    final picked = await _picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
      imageQuality: 60,
      maxWidth: 720,
    );

    if (picked != null) {
      setState(() {
        images[key] = File(picked.path);
      });
    }
  }

  // ================= UPLOAD =================
  Future<void> _upload() async {
    if (images.values.any((e) => e == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chụp đủ 6 ảnh')),
      );
      return;
    }

    try {
      await _service.registerFaceWithFiles(
        guardId: _guardId!,
        front: images['front']!,
        left: images['left']!,
        right: images['right']!,
        up: images['up']!,
        down: images['down']!,
        smile: images['smile']!,
        onProgress: (p) => setState(() => _progress = p),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đăng ký khuôn mặt thành công')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi upload: $e')),
      );
    }
  }

  // ================= POSE CARD UI =================
  Widget _poseCard(PoseStep step) {
    final file = images[step.poseType];

    return InkWell(
      onTap: () => _takePhoto(step.poseType),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: file == null
                  ? Icon(step.icon, size: 32, color: Colors.grey)
                  : ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(file, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    step.instruction,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              file != null ? Icons.check_circle : Icons.camera_alt,
              color: file != null ? Colors.green : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final completed =
        images.values.where((e) => e != null).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text('Đăng ký khuôn mặt'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  'Xác thực khuôn mặt',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Vui lòng thực hiện đầy đủ các bước bên dưới',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: completed / poseSteps.length,
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(10),
                ),
                const SizedBox(height: 6),
                Text('$completed / ${poseSteps.length} bước hoàn thành'),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: poseSteps.map(_poseCard).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed:
              completed == poseSteps.length ? _upload : null,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: _progress > 0 && _progress < 1
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                      value: _progress,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text('Đang gửi dữ liệu...'),
                ],
              )
                  : const Text(
                'Gửi đăng ký khuôn mặt',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
