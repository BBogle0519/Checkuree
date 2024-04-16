class AttendeesListResponse {
  int? count;
  List<Items>? items;
  bool success;

  AttendeesListResponse({
    this.count,
    this.items,
    required this.success,
  });

  factory AttendeesListResponse.fromJson(Map<String, dynamic> json) {
    return AttendeesListResponse(
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
  String id;
  String attendanceId;
  String name;
  String mobileNumber;
  String subMobileNumber;
  int age;
  String description;

  Items({
    required this.createId,
    required this.createdAt,
    this.updateId,
    required this.updatedAt,
    this.deletedAt,
    required this.id,
    required this.attendanceId,
    required this.name,
    required this.mobileNumber,
    required this.subMobileNumber,
    required this.age,
    required this.description,
  });

  factory Items.fromJson(Map<String, dynamic> json) {
    return Items(
      createId: json['createId'],
      createdAt: json['createdAt'],
      updateId: json['updateId'],
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt'],
      id: json['id'],
      attendanceId: json['attendanceId'],
      name: json['name'],
      mobileNumber: json['mobileNumber'],
      subMobileNumber: json['subMobileNumber'],
      age: json['age'],
      description: json['description'],
    );
  }
}
