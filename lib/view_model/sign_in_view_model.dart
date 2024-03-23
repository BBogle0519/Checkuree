import 'package:checkuuree/service/api_service.dart';
import 'package:dio/dio.dart';

import '../model/sign_in_response.dart';

class SignInViewModel {
  final Dio dio = Dio();

  Future<SignInResponse> signInPost(String username, String password) async {
    try {
      Response response = await ApiService.dio.post(
        '/auth/signin',
        data: {
          'username': username,
          'password': password,
        },
      );
      // print(response.data);
      return SignInResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load post: $e');
    }
  }
}
