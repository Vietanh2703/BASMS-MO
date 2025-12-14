import 'dart:convert';

import 'package:http/http.dart' as http;

class UserService {
  static const String baseUrl = "https://api.anninhsinhtrac.com/api/users";

  static Future<Map<String, dynamic>> getUserById(
    String userId,
    String token,
  ) async {
    final url = Uri.parse("$baseUrl/$userId");

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)["user"];
    } else {
      throw Exception("Không lấy được dữ liệu user");
    }
  }
}
