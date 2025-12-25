import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ContractService {
  static const _base = "https://api.anninhsinhtrac.com/api/contracts";

  static Future<Map<String, dynamic>> _get(
      String url,
      ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    final res = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (res.statusCode != 200) {
      throw Exception("API ERROR ${res.statusCode}");
    }

    return jsonDecode(res.body);
  }

  // 1️⃣ lấy customerId bằng email
  static Future<String> getCustomerIdByEmail(String email) async {
    final data = await _get(
      "$_base/customers/by-email?email=$email",
    );
    return data["customer"]["id"];
  }

  // 2️⃣ lấy toàn bộ data (contracts + locations + shifts)
  static Future<Map<String, dynamic>> getCustomerContracts(
      String customerId,
      ) async {
    return _get("$_base/customers/$customerId");
  }
}
