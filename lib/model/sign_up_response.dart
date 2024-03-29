class SignUpResponse {
  final bool success;
  final String message;
  final UserInfo? data;

  SignUpResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory SignUpResponse.fromJson(Map<String, dynamic> json) {
    return SignUpResponse(
      success: json['success'] as bool,
      message: (json['message'] as String?) ?? "null",
      data: json['data'] != null
          ? UserInfo.fromJson(json['data'] as Map<String, dynamic>)
          : UserInfo.empty(),
    );
  }
}

class UserInfo {
  final String username;
  final String name;
  final String mobileNumber;
  final String email;
  final String birthday;
  final String? createId;
  final String? createAt;
  final String? updateId;
  final String? updateAt;
  final String? deletedAt;
  final String? refreshToken;
  final String id;
  final String type;

  UserInfo({
    required this.username,
    required this.name,
    required this.mobileNumber,
    required this.email,
    required this.birthday,
    this.createId,
    this.createAt,
    this.updateId,
    this.updateAt,
    this.deletedAt,
    this.refreshToken,
    required this.id,
    required this.type,
  });

  factory UserInfo.fromJson(Map<String?, dynamic> json) {
    return UserInfo(
      username: json['username'],
      name: json['name'],
      mobileNumber: json['mobileNumber'],
      email: json['email'],
      birthday: json['birthday'],
      createId: json['createId'],
      createAt: json['createAt'],
      updateId: json['updateId'],
      updateAt: json['updateAt'],
      deletedAt: json['deletedAt'],
      refreshToken: json['refreshToken'],
      id: json['id'],
      type: json['type'],
    );
  }

  static UserInfo empty() {
    return UserInfo(
      username: "",
      name: "",
      mobileNumber: "",
      email: "",
      birthday: "",
      createId: null,
      createAt: null,
      updateId: null,
      updateAt: null,
      deletedAt: null,
      refreshToken: null,
      id: "",
      type: "",
    );
  }
}
