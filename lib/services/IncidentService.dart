import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class IncidentService {
  static const String baseUrl =
      "https://api.anninhsinhtrac.com/api";

  static Future<bool> createIncident({
    required String title,
    required String description,
    required String incidentType,
    required String severity,
    required String incidentTime, // HH:mm
    required String location,
    required String shiftLocation,
    required File? file,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    final reporterId = prefs.getString("userId"); // 🔥 userId lúc login

    if (token == null || reporterId == null) {
      throw Exception("Chưa đăng nhập");
    }

    final uri = Uri.parse("$baseUrl/incidents/create");
    final request = http.MultipartRequest("POST", uri);

    request.headers["Authorization"] = "Bearer $token";

    request.fields.addAll({
      "title": title,
      "description": description,
      "incidentType": incidentType,
      "severity": severity,
      "incidentTime": incidentTime,
      "location": location,
      "shiftLocation": shiftLocation,
      "reporterId": reporterId,
    });

    if (file != null) {
      request.files.add(
        await http.MultipartFile.fromPath("files", file.path),
      );
    }

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    print("📡 REPORT STATUS: ${response.statusCode}");
    print("📦 REPORT BODY: $responseBody");

    return response.statusCode == 200;
  }
}
