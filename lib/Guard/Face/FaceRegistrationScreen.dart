import 'dart:convert';
import 'dart:io';

import 'package:adoan/Guard/Face/CenterError.dart';
import 'package:adoan/Guard/Face/CenterSuccess.dart';
import 'package:adoan/Guard/Face/FaceRegistrationService.dart';
import 'package:adoan/Guard/Face/PoseStep.dart';
import 'package:adoan/Guard/home_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  bool _showError = false;
  bool _showSuccess = false;

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

  Future<void> _loadGuardId() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final email = prefs.getString('email');

    _service = FaceRegistrationService(token!);

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

  Future<void> _takePhoto(String key) async {
    final picked = await _picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
      imageQuality: 70,
      maxWidth: 1080,
    );

    if (picked != null) {
      setState(() => images[key] = File(picked.path));
    }
  }

  Future<void> _upload() async {
    setState(() {
      _showError = false;
      _showSuccess = false;
      _progress = 0;
    });

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
      setState(() => _showSuccess = true);
    } catch (_) {
      setState(() => _showError = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final completed = images.values.where((e) => e != null).length;

    return Scaffold(
      appBar: AppBar(title: const Text('Đăng ký khuôn mặt')),
      body: Stack(
        children: [
          Column(
            children: [
              LinearProgressIndicator(
                value: completed / poseSteps.length,
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: poseSteps.map(_poseCard).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed:
                  completed == poseSteps.length ? _upload : null,
                  child: const Text('Gửi đăng ký khuôn mặt'),
                ),
              )
            ],
          ),

          /// 🔴 ERROR
          if (_showError)
            CenterError(
              title: 'Chất lượng ảnh quá thấp',
              subtitle:
              'Vui lòng chụp lại ảnh rõ nét, đủ ánh sáng và đúng hướng.',
              onClose: () {
                setState(() => _showError = false);
              },
            ),

          /// 🟢 SUCCESS
          if (_showSuccess)
            CenterSuccess(
              title: 'Đăng ký khuôn mặt thành công',
              subtitle:
              'Hệ thống đã ghi nhận khuôn mặt của bạn.',
              onClose: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const HomePage()),
                      (route) => false,
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _poseCard(PoseStep step) {
    final file = images[step.poseType];

    return Card(
      child: ListTile(
        leading: file == null
            ? Icon(step.icon)
            : Image.file(file!, width: 48, height: 48),
        title: Text(step.title),
        subtitle: Text(step.instruction),
        trailing: Icon(
          file != null ? Icons.check_circle : Icons.camera_alt,
          color: file != null ? Colors.green : null,
        ),
        onTap: () => _takePhoto(step.poseType),
      ),
    );
  }
}
