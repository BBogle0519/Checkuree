class AttendanceAddResponse {
  int? count;
  Data? data;
  bool success;

  AttendanceAddResponse({
    this.count,
    this.data,
    required this.success,
  });

  factory AttendanceAddResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceAddResponse(
      count: (json['count'] as int?) ?? 0,
      data: Data.fromJson(json['data']),
      success: json['success'] as bool,
    );
  }
}

class Data {
  String id;

  Data({
    required this.id,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'] as String,
    );
  }
}
