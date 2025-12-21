import 'dart:io';
import 'package:dio/dio.dart';

class AttendanceService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://api.anninhsinhtrac.com",
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

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
    final formData = FormData.fromMap({
      "guardId": guardId,
      "shiftId": shiftId,

      // ✅ TÊN KEY ĐÚNG Y CHANG POSTMAN
      "shiftAssignmentId": assignmentId,

      "checkInLatitude": lat.toString(),
      "checkInLongitude": lng.toString(),
      "checkInLocationAccuracy": accuracy.toString(),

      "checkInImage": await MultipartFile.fromFile(
        image.path,
        filename: image.path.split('/').last,
      ),
    });

    try {
      final res = await _dio.post(
        "/api/attendances/check-in",
        data: formData,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      print("✅ CHECK-IN OK: ${res.data}");
    } on DioException catch (e) {
      print("❌ CHECK-IN ERROR");
      print(e.response?.data);
      rethrow;
    }
  }
}
