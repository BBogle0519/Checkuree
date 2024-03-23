class SignInResponse {
  final bool success;
  final String message;
  final TokenData data;

  SignInResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory SignInResponse.fromJson(Map<String, dynamic> json) {
    return SignInResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: TokenData.fromJson(json['data']),
    );
  }
}

class TokenData {
  final String accessToken;
  final String refreshToken;

  TokenData({
    required this.accessToken,
    required this.refreshToken,
  });

  factory TokenData.fromJson(Map<String, dynamic> json) {
    return TokenData(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );
  }
}
