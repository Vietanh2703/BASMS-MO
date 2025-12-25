class AttendanceStatus {
  final String status;

  AttendanceStatus({required this.status});

  factory AttendanceStatus.fromJson(Map<String, dynamic> json) {
    return AttendanceStatus(
      status: json['status'],
    );
  }
}
