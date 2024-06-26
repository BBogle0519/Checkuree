class AttendeeAddResponse {
  String? message;
  Data? data;
  bool success;

  AttendeeAddResponse({
    this.message,
    this.data,
    required this.success,
  });

  factory AttendeeAddResponse.fromJson(Map<String, dynamic> json) {
    return AttendeeAddResponse(
      message: (json['count'] as String?) ?? "",
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
