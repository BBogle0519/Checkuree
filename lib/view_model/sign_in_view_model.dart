import 'package:checkuuree/service/api_service.dart';
import 'package:dio/dio.dart';

import '../model/sign_in_response.dart';

class SignInViewModel {

  Future<SignInResponse> signInPost(String username, String password) async {
    try {
      Response response = await ApiService.dio.post(
        '/auth/signin',
        data: {
          'username': username,
          'password': password,
        },
      );

      return SignInResponse.fromJson(response.data);
    } on DioException catch (e) {
      // print(e);
      final response = e.response;
      if (response != null) {
        // print(response.data);
        // print("header:: ${response.headers}");
        // print("requestOptions:: ${response.requestOptions}");
        return SignInResponse.fromJson(response.data);
      } else {
        print(e.requestOptions);
        print(e.message);
        throw Exception('Failed to load post: $e');
      }
    }
  }

// void printLongLog(String longLog) {
//   final maxLength = 4000; // 로그의 최대 길이
//   final logLength = longLog.length;
//
//   if (logLength <= maxLength) {
//     // 로그가 최대 길이 이하일 경우, 그대로 출력
//     print("4000k 이하임 ::::$longLog");
//   } else {
//     // 로그가 최대 길이를 초과할 경우, 조각으로 나누어 출력
//     for (int i = 0; i < logLength; i += maxLength) {
//       print(longLog.substring(i, min(i + maxLength, logLength)));
//     }
//   }
// }
}
