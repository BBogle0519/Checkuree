import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/sign_in_response.dart';

late SharedPreferences _prefs;
late String accessToken;
late String refreshToken;

class ApiService {
  static final Dio dio = _initializeDio();
  static Function? onTokenRefreshFailed;

  static Dio _initializeDio() {
    Dio dio = Dio(BaseOptions(baseUrl: 'https://www.pond-checkuree.com'));
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));

    // token interceptor
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        await _loadData();

        options.headers['Authorization'] = 'Bearer $accessToken';

        return handler.next(options);
      },

      // Token expiration handling
      onError: (DioException e, handler) async {
        if (e.response?.statusCode == 401) {
          int retryCount = e.requestOptions.extra["retryCount"] ?? 0;

          if (retryCount >= 1) {
            print("토큰 갱신 후 에도 실패");
            onTokenRefreshFailed?.call();
            return handler.reject(e);
          }

          print("ApiService: token reset");
          await _loadData();
          try {
            Response response = await ApiService.dio.post(
              '/auth/refresh-token',
              data: {
                'refreshToken': refreshToken,
              },
            );
            accessToken = SignInResponse.fromJson(response.data).data!.accessToken!;
            refreshToken = SignInResponse.fromJson(response.data).data!.refreshToken!;
            print("ApiService: 재요청 후 saveData");
            await _saveData();

            e.requestOptions.headers['Authorization'] = 'Bearer $accessToken';
            e.requestOptions.extra["retryCount"] = retryCount + 1;
            return handler.resolve(await dio.fetch(e.requestOptions));
          } on DioException catch (e) {
            final response = e.response;

            if (response != null) {
              print(response.data);
              print("header:: ${response.headers}");
              print("requestOptions:: ${response.requestOptions}");
            } else {
              print(e.requestOptions);
              print(e.message);
              throw Exception('Failed to load post: $e');
            }
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
    refreshToken = _prefs.getString('refreshToken') ?? "null";
    // print("apiservice accessToken load ::::: $accessToken");
  }

  // 토큰 저장
  static Future<void> _saveData() async {
    // print("apiservice access save: $accessToken");
    // print("apiservice refresh save: $refreshToken");
    _prefs = await SharedPreferences.getInstance();
    // refreshToken = _prefs.getString('refreshToken') ?? "null";

    _prefs.setString('accessToken', accessToken);
    _prefs.setString('refreshToken', refreshToken);
  }
}
