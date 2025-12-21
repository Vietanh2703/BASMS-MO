class ShiftModel {
  final String shiftId;
  final String assignmentId; // ✅ THÊM
  final DateTime shiftDate;
  final DateTime shiftStart;
  final DateTime shiftEnd;
  final String locationName;
  final String locationAddress;
  final String shiftStatus;
  final String teamName;
  final double latitude;
  final double longitude;

  ShiftModel({
    required this.shiftId,
    required this.assignmentId, // ✅
    required this.shiftDate,
    required this.shiftStart,
    required this.shiftEnd,
    required this.locationName,
    required this.locationAddress,
    required this.shiftStatus,
    required this.teamName,
    required this.latitude,
    required this.longitude,
  });

  factory ShiftModel.fromJson(Map<String, dynamic> json) {
    return ShiftModel(
      shiftId: json['shiftId'],
      assignmentId: json['assignmentId'], // ✅ MAP ĐÚNG
      shiftDate: DateTime.parse(json['shiftDate']),
      shiftStart: DateTime.parse(json['shiftStart']),
      shiftEnd: DateTime.parse(json['shiftEnd']),
      locationName: json['locationName'],
      locationAddress: json['locationAddress'],
      shiftStatus: json['shiftStatus'],
      teamName: json['teamName'],
      latitude: (json['locationLatitude'] as num).toDouble(),
      longitude: (json['locationLongitude'] as num).toDouble(),
    );
  }
}
