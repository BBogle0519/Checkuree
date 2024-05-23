class AttendeeListResponse {
  int? count;
  List<Items>? items;
  bool success;

  AttendeeListResponse({
    this.count,
    this.items,
    required this.success,
  });

  factory AttendeeListResponse.fromJson(Map<String, dynamic> json) {
    return AttendeeListResponse(
      count: (json['count'] as int?) ?? 0,
      items: (json['items'] as List<dynamic>?)?.map((itemJson) => Items.fromJson(itemJson)).toList() ?? [],
      success: json['success'] as bool,
    );
  }
}

class Items {
  String createdAt;
  String id;
  String attendanceId;
  String name;
  String gender;
  String mobileNumber;
  String subMobileNumber;
  String? birth;
  String? course;
  String? grade;
  String? description;
  List<Schedules>? schedules;

  Items({
    required this.createdAt,
    required this.id,
    required this.attendanceId,
    required this.name,
    required this.gender,
    required this.mobileNumber,
    required this.subMobileNumber,
    this.birth,
    this.course,
    this.grade,
    this.description,
    this.schedules,
  });

  factory Items.fromJson(Map<String, dynamic> json) {
    return Items(
      createdAt: json['createdAt'],
      id: json['id'],
      attendanceId: json['attendanceId'],
      name: json['name'],
      gender: json['gender'],
      mobileNumber: json['mobileNumber'],
      subMobileNumber: json['subMobileNumber'],
      birth: json['birth'],
      course: json['course'],
      grade: json['grade'],
      description: json['description'],
      schedules: (json['schedules'] as List<dynamic>?)?.map((schedulesJson) => Schedules.fromJson(schedulesJson)).toList() ?? [],
    );
  }
}

class Schedules {
  int? id;
  String? day;
  String? time;

  Schedules({
    this.id,
    this.day,
    this.time,
  });

  factory Schedules.fromJson(Map<String, dynamic> json) {
    return Schedules(
      id: json['id'],
      day: json['day'],
      time: json['time'],
    );
  }
}
