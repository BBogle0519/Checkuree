class SignInResponse {
  final bool success;
  final String message;
  final AccessTokenData data;

  SignInResponse(
      {required this.success, required this.message, required this.data});

  factory SignInResponse.fromJson(Map<String, dynamic> json) {
    return SignInResponse(
      success: json['success'],
      message: json['message'],
      data: AccessTokenData.fromJson(json['data']),
    );
  }
}

class AccessTokenData {
  final String accessToken;

  AccessTokenData({required this.accessToken});

  factory AccessTokenData.fromJson(Map<String, dynamic> json) {
    return AccessTokenData(
      accessToken: json['accessToken'],
    );
  }
}
