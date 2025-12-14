// widgets/home_card.dart
import 'package:flutter/material.dart';

class HomeCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor; // 👈 THAY ĐỔI: Bỏ gradient, dùng màu cho icon
  final VoidCallback? onTap;

  const HomeCard({
    super.key,
    required this.title,
    required this.icon,
    required this.iconColor, // 👈 THAY ĐỔI
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          // ⚠️ THAY ĐỔI: Bỏ gradient, dùng màu kính mờ
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(24),
          // Thêm viền mỏng để tạo hiệu ứng kính
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2), // Giảm shadow một chút
              blurRadius: 10,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                // Nền icon trong suốt hơn một chút
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              // ⚠️ THAY ĐỔI: Dùng iconColor cho icon
              child: Icon(icon, color: iconColor, size: 42),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
