import 'dart:io';
import 'package:dio/dio.dart';

class FaceRegistrationService {
  final Dio _dio = Dio();

  FaceRegistrationService(String token) {
    _dio.options.baseUrl = 'https://api.anninhsinhtrac.com';
    _dio.options.connectTimeout = const Duration(seconds: 90);
    _dio.options.receiveTimeout = const Duration(seconds: 90);
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  Future<Response> registerFaceWithFiles({
    required String guardId,
    required File front,
    required File left,
    required File right,
    required File up,
    required File down,
    required File smile,
    Function(double)? onProgress,
  }) async {
    final formData = FormData.fromMap({
      'guardId': guardId,
      'image_front': await MultipartFile.fromFile(front.path),
      'image_left': await MultipartFile.fromFile(left.path),
      'image_right': await MultipartFile.fromFile(right.path),
      'image_up': await MultipartFile.fromFile(up.path),
      'image_down': await MultipartFile.fromFile(down.path),
      'image_smile': await MultipartFile.fromFile(smile.path),
    });

    final response = await _dio.post(
      '/api/attendances/faces/register-with-files',
      data: formData,
      options: Options(
        contentType: 'multipart/form-data', // 🔥 QUAN TRỌNG
      ),
      onSendProgress: (sent, total) {
        if (onProgress != null && total > 0) {
          onProgress(sent / total);
        }
      },
    );

    return response;
  }
}
