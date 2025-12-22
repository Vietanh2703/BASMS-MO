import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/shift_model.dart';

class ShiftService {
  static const String baseUrl = "https://api.anninhsinhtrac.com/api";

  /// 1️⃣ Lấy guardId bằng email đã login
  static Future<String> getGuardIdByEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    final email = prefs.getString("email");

    if (token == null || email == null) {
      throw Exception("❌ Chưa login hoặc thiếu email");
    }

    debugPrint("📧 EMAIL SEND API: $email");

    final response = await http.post(
      Uri.parse("$baseUrl/shifts/guards/by-email"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "Email": email,
      }),
    );

    debugPrint("📡 STATUS: ${response.statusCode}");
    debugPrint("📦 BODY: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception(
        "❌ Lỗi lấy guardId: ${response.statusCode}",
      );
    }

    final data = jsonDecode(response.body);
    return data["guard"]["id"];
  }

  /// 2️⃣ Lấy lịch trực (TỰ ĐỘNG LẤY guardId)
  static Future<List<ShiftModel>> getAssignedShifts() async {
    final guardId = await getGuardIdByEmail();

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    final response = await http.get(
      Uri.parse("$baseUrl/shifts/guards/$guardId/assigned"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    debugPrint("📡 STATUS: ${response.statusCode}");
    debugPrint("📦 BODY: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception("❌ Lỗi lấy lịch trực");
    }

    final data = jsonDecode(response.body);

    if (data["success"] != true) {
      throw Exception("❌ API success=false");
    }

    final List list = data["data"];
    return list.map((e) => ShiftModel.fromJson(e)).toList();
  }
}
