import 'package:checkuuree/service/api_service.dart';
import 'package:dio/dio.dart';

import '../model/sign_up_response.dart';

class SignUpViewModel {
  final Dio dio = Dio();

  Future<SignUpResponse> signUpPost(String username, String password,
      String name, String mobileNumber, String birthday, String email) async {
    try {
      Response response = await ApiService.dio.post('/auth/signup', data: {
        'username': username,
        'password': password,
        'name': name,
        'mobileNumber': mobileNumber,
        'birthday': birthday,
        'email': email,
      });
      print(response.data);
      return SignUpResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load post: $e');
    }
  }
}
