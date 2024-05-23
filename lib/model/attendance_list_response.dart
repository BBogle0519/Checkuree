class AttendanceListResponse {
  int? count;
  List<Items>? items;
  bool success;

  AttendanceListResponse({
    this.count,
    this.items,
    required this.success,
  });

  factory AttendanceListResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceListResponse(
      count: (json['count'] as int?) ?? 0,
      items: (json['items'] as List<dynamic>?)?.map((itemJson) => Items.fromJson(itemJson)).toList() ?? [],
      success: json['success'] as bool,
    );
  }
}

class Items {
  String createdAt;
  int userAttendanceId;
  String userId;
  String attendanceId;
  String role;
  Attendance attendance;

  Items({
    required this.createdAt,
    required this.userAttendanceId,
    required this.userId,
    required this.attendanceId,
    required this.role,
    required this.attendance,
  });

  factory Items.fromJson(Map<String, dynamic> json) {
    return Items(
      createdAt: json['createdAt'],
      userAttendanceId: json['userAttendanceId'],
      userId: json['userId'],
      attendanceId: json['attendanceId'],
      role: json['role'],
      attendance: Attendance.fromJson(json['attendance']),
    );
  }
}

class Attendance {
  String createdAt;
  String id;
  String title;
  String? description;
  int attendeeCount;
  String availableFrom;
  String availableTo;
  bool allowLateness;
  String? imageUrl;
  List<AttendanceDays>? attendanceDays;
  List<String>? days;

  Attendance({
    required this.createdAt,
    required this.id,
    required this.title,
    this.description,
    required this.attendeeCount,
    required this.availableFrom,
    required this.availableTo,
    required this.allowLateness,
    this.imageUrl,
    this.attendanceDays,
    this.days,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      createdAt: json['createdAt'],
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? "",
      attendeeCount: json['attendeeCount'],
      availableFrom: json['availableFrom'],
      availableTo: json['availableTo'],
      allowLateness: json['allowLateness'],
      imageUrl: json['imageUrl'],
      attendanceDays: (json['attendanceDays'] as List<dynamic>?)?.map((itemJson) => AttendanceDays.fromJson(itemJson)).toList() ?? [],
      days: json['days'].cast<String>(),
    );
  }
}

class AttendanceDays {
  int id;
  String attendanceId;
  String day;

  AttendanceDays({
    required this.id,
    required this.attendanceId,
    required this.day,
  });

  factory AttendanceDays.fromJson(Map<String, dynamic> json) {
    return AttendanceDays(
      id: json['id'],
      attendanceId: json['attendanceId'],
      day: json['day'],
    );
  }
}
