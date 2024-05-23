class ScheduleAddResponse {
  String? message;
  Data? data;
  bool success;

  ScheduleAddResponse({
    this.message,
    this.data,
    required this.success,
  });

  factory ScheduleAddResponse.fromJson(Map<String, dynamic> json) {
    return ScheduleAddResponse(
      message: (json['count'] as String?) ?? "",
      data: Data.fromJson(json['data']),
      success: json['success'] as bool,
    );
  }
}

class Data {
  List<int>? ids;

  Data({
    required this.ids,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      ids: json['ids'].cast<int>(),
    );
  }
}
