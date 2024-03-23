import 'package:dio/dio.dart';

class ApiService {
  static final Dio dio = _initializeDio();

  static Dio _initializeDio() {
    Dio dio = Dio(BaseOptions(baseUrl: 'https://checkuree.com'));
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));

    return dio;
  }
}
