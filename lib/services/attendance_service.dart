import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class AttendanceService {
  static const baseUrl = "https://api.anninhsinhtrac.com/api";

  static Future<void> checkIn({
    required String token,
    required String guardId,
    required String shiftId,
    required String assignmentId,
    required double lat,
    required double lng,
    required double accuracy,
    required File image,
  }) async {
    final uri = Uri.parse("$baseUrl/attendances/check-in");
    final request = http.MultipartRequest("POST", uri);

    // 🔐 Authorization
    request.headers["Authorization"] = "Bearer $token";

    // 📌 FIELDS – PHẢI KHỚP DTO BACKEND
    request.fields.addAll({
      "GuardId": guardId,
      "ShiftId": shiftId,
      "ShiftAssignmentId": assignmentId,
      "CheckInLatitude": lat.toString(),
      "CheckInLongitude": lng.toString(),
      "CheckInAccuracy": accuracy.toString(),
    });

    // 🖼️ IMAGE – ÉP JPEG + CONTENT-TYPE
    request.files.add(
      await http.MultipartFile.fromPath(
        "CheckInImage",                 // ❗ đúng key backend
        image.path,
        contentType: MediaType("image", "jpeg"),
      ),
    );

    // 🧪 DEBUG
    print("📤 CHECK-IN FIELDS: ${request.fields}");

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    print("📥 CHECK-IN STATUS: ${response.statusCode}");
    print("📥 CHECK-IN BODY: $responseBody");

    if (response.statusCode != 200) {
      throw Exception("Check-in thất bại: $responseBody");
    }
  }
}
