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
  String createId;
  String createdAt;
  String? updateId;
  String updatedAt;
  String? deletedAt;
  int userAttendanceId;
  String userId;
  String attendanceId;
  String role;
  Attendance attendance;

  Items({
    required this.createId,
    required this.createdAt,
    this.updateId,
    required this.updatedAt,
    this.deletedAt,
    required this.userAttendanceId,
    required this.userId,
    required this.attendanceId,
    required this.role,
    required this.attendance,
  });

  factory Items.fromJson(Map<String, dynamic> json) {
    return Items(
      createId: json['createId'],
      createdAt: json['createdAt'],
      updateId: json['updateId'],
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt'],
      userAttendanceId: json['userAttendanceId'],
      userId: json['userId'],
      attendanceId: json['attendanceId'],
      role: json['role'],
      attendance: Attendance.fromJson(json['attendance']),
    );
  }
}

class Attendance {
  String createId;
  String createdAt;
  String? updateId;
  String updatedAt;
  String? deletedAt;
  String id;
  String title;
  String description;
  int attendeeCount;
  String availableFrom;
  String availableTo;
  bool allowLateness;
  List<AttendanceDays>? attendanceDays;
  List<String>? days;

  // "days": [
  // "TUESDAY",
  // "THURSDAY"
  // ]
  Attendance({
    required this.createId,
    required this.createdAt,
    this.updateId,
    required this.updatedAt,
    this.deletedAt,
    required this.id,
    required this.title,
    required this.description,
    required this.attendeeCount,
    required this.availableFrom,
    required this.availableTo,
    required this.allowLateness,
    this.attendanceDays,
    this.days,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      createId: json['createId'],
      createdAt: json['createdAt'],
      updateId: json['updateId'],
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt'],
      id: json['id'],
      title: json['title'],
      description: json['description'],
      attendeeCount: json['attendeeCount'],
      availableFrom: json['availableFrom'],
      availableTo: json['availableTo'],
      allowLateness: json['allowLateness'],
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
