import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/sign_in_response.dart';

late SharedPreferences _prefs;
late String accessToken;
late String refreshToken;

class ApiService {
  static final Dio dio = _initializeDio();

  static Dio _initializeDio() {
    Dio dio = Dio(BaseOptions(baseUrl: 'https://checkuree.com'));
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));

    // token interceptor
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        await _loadData();

        accessToken = _prefs.getString('accessToken') ?? "null";
        print("accessToken load ::::: $accessToken");

        String? token = accessToken;
        options.headers['Authorization'] = 'Bearer $token';
        print("Bearer token ::: Bearer $token");

        return handler.next(options);
      },

      // Token expiration handling
      onError: (e, handler) async {
        if (e.response?.statusCode == 401) {
          print("ApiService: token reset");
          refreshToken = _prefs.getString('refreshToken')!;
          Response response = await ApiService.dio.post(
            '/auth/refresh-token',
            data: {
              'refreshToken': refreshToken,
            },
          );
          if (response.statusCode == 200) {
            accessToken =
                SignInResponse.fromJson(response.data).data!.accessToken!;
            refreshToken =
                SignInResponse.fromJson(response.data).data!.refreshToken!;
            await _saveData();

            e.requestOptions.headers['Authorization'] = 'Bearer $accessToken';
            return handler.resolve(await dio.request(
              e.requestOptions.path,
              options: e.requestOptions as Options,
            ));
          }
        }

        return handler.reject(e);
      },
    ));

    return dio;
  }

  static bool _requiresToken(String url) {
    return !url.startsWith('/auth');
  }

  // 토큰 로드
  static Future<void> _loadData() async {
    _prefs = await SharedPreferences.getInstance();
    accessToken = _prefs.getString('accessToken') ?? "null";
    // print("accessToken load ::::: $accessToken");
  }

  // 토큰 저장
  static Future<void> _saveData() async {
    // print("access: $accessToken");
    // print("refresh: $refreshToken");
    _prefs = await SharedPreferences.getInstance();
    refreshToken = _prefs.getString('refreshToken') ?? "null";

    _prefs.setString('accessToken', accessToken);
    _prefs.setString('refreshToken', refreshToken);
  }
}
