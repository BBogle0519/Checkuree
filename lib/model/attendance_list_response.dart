class AttendanceListResponse {
  int count;
  List<Items> items;
  bool success;

  AttendanceListResponse({
    required this.count,
    required this.items,
    required this.success,
  });

  factory AttendanceListResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceListResponse(
      count: json['count'] as int,
      items: (json['items'] as List)
          .map((itemJson) => Items.fromJson(itemJson))
          .toList(),
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
  String type;
  int attendeeCount;

  Attendance({
    required this.createId,
    required this.createdAt,
    this.updateId,
    required this.updatedAt,
    this.deletedAt,
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.attendeeCount,
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
      type: json['type'],
      attendeeCount: json['attendeeCount'],
    );
  }
}
