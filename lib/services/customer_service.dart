import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CustomerService {
  static Future<String> getCustomerIdByEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    final res = await http.get(
      Uri.parse(
        "https://api.anninhsinhtrac.com/api/contracts/customers/by-email?email=$email",
      ),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    final body = jsonDecode(res.body);
    return body["customer"]["id"];
  }
}
