import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class CheckOutService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://api.anninhsinhtrac.com",
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  )..interceptors.add(
    LogInterceptor(
      request: true,
      requestBody: true,
      responseBody: true,
      error: true,
    ),
  );

  static Future<void> checkOut({
    required String token,
    required String guardId,
    required String shiftId,
    required String assignmentId,
    required double lat,
    required double lng,
    required double accuracy,
    required File image,
  }) async {
    final formData = FormData.fromMap({
      // 🔥 BẮT BUỘC
      "guardId": guardId,
      "shiftId": shiftId,
      "shiftAssignmentId": assignmentId,

      // 📍 GPS
      "checkOutLatitude": lat.toString(),
      "checkOutLongitude": lng.toString(),
      "checkOutLocationAccuracy": accuracy.toString(),

      // 📸 ẢNH
      "checkOutImage": await MultipartFile.fromFile(
        image.path,
        filename: image.path.split('/').last,
      ),
    });

    try {
      final res = await _dio.post(
        "/api/attendances/check-out",
        data: formData,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      debugPrint("✅ CHECK-OUT OK");
      debugPrint(res.data.toString());
    } on DioException catch (e) {
      debugPrint("❌ CHECK-OUT ERROR");
      debugPrint(e.response?.data.toString());
      rethrow;
    }
  }
}
