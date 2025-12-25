import 'dart:convert';
import 'dart:io';

import 'package:adoan/Customer/HomeCustomerPage.dart';
import 'package:adoan/Guard/Face/FaceRegistrationScreen.dart';
import 'package:adoan/Guard/home_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;
  bool isPasswordVisible = false;

  static const baseUrl = "https://api.anninhsinhtrac.com/api";

  // ================= HELPER =================
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("❌ $message")),
    );
  }

  bool _validateInput() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty && password.isEmpty) {
      _showError("Vui lòng nhập email và mật khẩu");
      return false;
    }

    if (email.isEmpty) {
      _showError("Vui lòng nhập email");
      return false;
    }

    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      _showError("Email không đúng định dạng");
      return false;
    }

    if (password.isEmpty) {
      _showError("Vui lòng nhập mật khẩu");
      return false;
    }

    return true;
  }

  // ================= CHECK FIRST LOGIN =================
  Future<int> checkFirstLogin(String email) async {
    final response = await http.post(
      Uri.parse("$baseUrl/users/check-first-login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"Email": email}),
    );

    if (response.statusCode != 200) {
      throw Exception("Check first login failed");
    }

    final data = jsonDecode(response.body);
    return data["loginCount"];
  }

  // ================= LOGIN =================
  Future<void> login() async {
    if (!_validateInput()) return;

    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/users/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": emailController.text.trim(),
          "password": passwordController.text.trim(),
        }),
      );

      if (response.statusCode != 200) {
        throw Exception("Sai tài khoản hoặc mật khẩu");
      }

      final data = jsonDecode(response.body);

      final token = data["accessToken"];
      final roleId = data["roleId"];
      final userId = data["userId"];
      final email = data["email"];

      // ===== SAVE LOCAL =====
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", token);
      await prefs.setString("userId", userId);
      await prefs.setString("roleId", roleId);
      await prefs.setString("email", email);

      // ===== CHECK FIRST LOGIN =====
      final loginCount = await checkFirstLogin(email);

      // ===== ROLE GUARD =====
      if (roleId == "ddbd6230-ba6e-11f0-bcac-00155dca8f48") {
        if (loginCount == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const FaceRegistrationScreen(),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomePage()),
          );
        }
        return;
      }

      // ===== ROLE CUSTOMER =====
      if (roleId == "ddbd630a-ba6e-11f0-bcac-00155dca8f48") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeCustomerPage()),
        );
        return;
      }

      _showError("Role không hợp lệ");
    } catch (e) {
      String message = "Đã xảy ra lỗi";

      if (e is SocketException) {
        message = "Không có kết nối Internet";
      } else if (e.toString().contains("Sai tài khoản")) {
        message = "Email hoặc mật khẩu không đúng";
      } else {
        message = e.toString();
      }

      _showError(message);
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F8),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: Column(
          children: [
            const SizedBox(height: 40),

            Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.shield, size: 40, color: Colors.blue),
            ),

            const SizedBox(height: 30),
            const Text(
              "SafeGuard System",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text("Đăng nhập để tiếp tục"),

            const SizedBox(height: 32),

            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.email),
                hintText: "Email",
                filled: true,
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: passwordController,
              obscureText: !isPasswordVisible,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock),
                hintText: "Mật khẩu",
                filled: true,
                suffixIcon: IconButton(
                  icon: Icon(
                    isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () =>
                      setState(() => isPasswordVisible = !isPasswordVisible),
                ),
              ),
            ),

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: isLoading ? null : login,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Đăng nhập", style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
