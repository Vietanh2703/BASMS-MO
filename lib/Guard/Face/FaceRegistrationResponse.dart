class FaceRegistrationResponse {
  final bool success;
  final FaceRegistrationData? data;
  final String? error;
  final String? message;

  FaceRegistrationResponse({
    required this.success,
    this.data,
    this.error,
    this.message,
  });

  factory FaceRegistrationResponse.fromJson(Map<String, dynamic> json) {
    return FaceRegistrationResponse(
      success: json['success'] ?? true,
      data: json['data'] != null
          ? FaceRegistrationData.fromJson(json['data'])
          : null,
      error: json['error'],
      message: json['message'],
    );
  }
}

class FaceRegistrationData {
  final String guardId;
  final String biometricLogId;
  final String templateUrl;
  final List<ProcessingStep> processingSteps;
  final List<double> qualityScores;
  final double averageQuality;

  FaceRegistrationData({
    required this.guardId,
    required this.biometricLogId,
    required this.templateUrl,
    required this.processingSteps,
    required this.qualityScores,
    required this.averageQuality,
  });

  factory FaceRegistrationData.fromJson(Map<String, dynamic> json) {
    return FaceRegistrationData(
      guardId: json['guardId'],
      biometricLogId: json['biometricLogId'],
      templateUrl: json['templateUrl'],
      processingSteps: (json['processingSteps'] as List)
          .map((e) => ProcessingStep.fromJson(e))
          .toList(),
      qualityScores: (json['qualityScores'] as List)
          .map((e) => (e as num).toDouble())
          .toList(),
      averageQuality: (json['averageQuality'] as num).toDouble(),
    );
  }
}

class ProcessingStep {
  final String poseType;
  final String status;
  final String message;

  ProcessingStep({
    required this.poseType,
    required this.status,
    required this.message,
  });

  factory ProcessingStep.fromJson(Map<String, dynamic> json) {
    return ProcessingStep(
      poseType: json['poseType'],
      status: json['status'],
      message: json['message'],
    );
  }
}
