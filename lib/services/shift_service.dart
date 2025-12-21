import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/shift_model.dart';

class ShiftService {
  static const String baseUrl = "https://api.anninhsinhtrac.com/api";

  /// 1️⃣ Lấy guardId bằng email
  static Future<String> getGuardIdByEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    final email = prefs.getString("email"); // hoặc hardcode test

    if (token == null) {
      throw Exception("Token null – chưa login");
    }

    final response = await http.post(
      Uri.parse("$baseUrl/shifts/guards/by-email"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "Email": email ?? "guard8@basms.com", // test trước
      }),
    );

    debugPrint("📡 STATUS: ${response.statusCode}");
    debugPrint("📦 BODY: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception(
        "Lỗi lấy guardId: ${response.statusCode} - ${response.body}",
      );
    }

    final data = jsonDecode(response.body);

    /// ⚠️ RẤT QUAN TRỌNG: đúng key như Postman
    return data["guard"]["id"];
  }


  /// 2️⃣ Lấy lịch trực theo guardId
  static Future<List<ShiftModel>> getAssignedShifts(String guardId) async {
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
      throw Exception(
        "Lỗi lấy lịch trực: ${response.statusCode} - ${response.body}",
      );
    }

    final data = jsonDecode(response.body);

    if (data["success"] != true) {
      throw Exception("API trả success=false");
    }

    final List list = data["data"];

    return list.map((e) => ShiftModel.fromJson(e)).toList();
  }


}
