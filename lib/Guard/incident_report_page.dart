import 'dart:io';
import 'package:adoan/models/shift_model.dart';
import 'package:adoan/services/IncidentService.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class IncidentReportPage extends StatefulWidget {
  final ShiftModel shift;
  const IncidentReportPage({super.key, required this.shift});

  @override
  State<IncidentReportPage> createState() => _IncidentReportPageState();
}

class _IncidentReportPageState extends State<IncidentReportPage> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  String incidentType = "THEFT";
  String severity = "MEDIUM";
  TimeOfDay incidentTime = TimeOfDay.now();
  File? image;

  final incidentTypes = {
    "THEFT": "Trộm cắp",
    "FIRE": "Báo cháy",
    "LEAVE": "Xin nghỉ",
    "EARLY_LEAVE": "Ra ca sớm",
    "OTHER": "Khác",
  };

  final severities = {
    "LOW": "Bình thường",
    "MEDIUM": "Nghiêm trọng",
    "HIGH": "Nguy hiểm",
  };

  // ================= IMAGE =================
  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );
    if (picked != null) {
      setState(() => image = File(picked.path));
    }
  }

  // ================= SUBMIT =================
  Future<void> submit() async {
    try {
      if (_titleCtrl.text.trim().isEmpty) {
        _showError("Vui lòng nhập tiêu đề");
        return;
      }

      final now = DateTime.now();

      final incidentDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        incidentTime.hour,
        incidentTime.minute,
      );

// 🔥 convert sang UTC
      final incidentUtc = incidentDateTime.toUtc();

// ISO string
      final time = incidentUtc.toIso8601String();


      // ❌ chặn thời gian tương lai
      if (incidentDateTime.isAfter(now)) {
        _showError("Thời gian sự cố không được lớn hơn hiện tại");
        return;
      }



      final success = await IncidentService.createIncident(
        title: _titleCtrl.text,
        description: _descCtrl.text,
        incidentType: incidentType,
        severity: severity,
        incidentTime: time,
        location: widget.shift.locationAddress,
        shiftLocation: widget.shift.locationName,
        file: image,
      );

      if (!mounted) return;

      if (success) {
        _showSuccess("Gửi báo cáo thành công");
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pop(context);
        });
      } else {
        _showError("Gửi báo cáo thất bại");
      }
    } catch (e) {
      if (!mounted) return;
      _showError(e.toString());
    }
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ---------- APP BAR ----------
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
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

      // ---------- BODY ----------
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label("Tiêu đề"),
            _box(
              child: TextField(
                controller: _titleCtrl,
                decoration: _boxStyle(),
              ),
            ),

            const SizedBox(height: 20),

            _label("Loại sự cố"),
            _box(
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: incidentType,
                  items: incidentTypes.entries
                      .map(
                        (e) => DropdownMenuItem(
                      value: e.key,
                      child: Text(e.value),
                    ),
                  )
                      .toList(),
                  onChanged: (v) => setState(() => incidentType = v!),
                ),
              ),
            ),

            const SizedBox(height: 20),

            _label("Mức độ"),
            _box(
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: severity,
                  items: severities.entries
                      .map(
                        (e) => DropdownMenuItem(
                      value: e.key,
                      child: Text(e.value),
                    ),
                  )
                      .toList(),
                  onChanged: (v) => setState(() => severity = v!),
                ),
              ),
            ),

            const SizedBox(height: 20),

            _label("Thời gian xảy ra"),
            _box(
              onTap: () async {
                final t = await showTimePicker(
                  context: context,
                  initialTime: incidentTime,
                );
                if (t != null) setState(() => incidentTime = t);
              },
              child: Row(
                children: [
                  Text(incidentTime.format(context)),
                  const Spacer(),
                  const Icon(Icons.access_time, color: Color(0xFF007AFF)),
                ],
              ),
            ),

            const SizedBox(height: 20),

            _label("Địa điểm"),
            _box(
              child: Text(widget.shift.locationName),
            ),

            const SizedBox(height: 20),

            _label("Mô tả chi tiết"),
            _box(
              child: TextField(
                controller: _descCtrl,
                maxLines: 4,
                decoration: _boxStyle(),
              ),
            ),

            const SizedBox(height: 20),

            _label("Hình ảnh"),
            const SizedBox(height: 10),

            Row(
              children: [
                if (image != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      image!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: pickImage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF0F3F8),
                    foregroundColor: const Color(0xFF007AFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Icon(Icons.camera_alt),
                ),
              ],
            ),

            const SizedBox(height: 120),
          ],
        ),
      ),

      // ---------- SUBMIT ----------
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: submit,
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
        ),
      ),
    );
  }

  // ================= HELPERS =================
  Widget _label(String text) => Text(
    text,
    style: const TextStyle(
      color: Color(0xFF636366),
      fontSize: 14,
    ),
  );

  Widget _box({required Widget child, VoidCallback? onTap}) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F3F8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    ),
  );

  InputDecoration _boxStyle() => const InputDecoration(
    border: InputBorder.none,
    isDense: true,
  );

  void _showSuccess(String msg) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
