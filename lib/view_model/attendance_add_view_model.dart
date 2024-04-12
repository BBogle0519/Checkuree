import 'package:checkuuree/service/api_service.dart';
import 'package:dio/dio.dart';

import '../model/attendance_add_response.dart';

class AttendanceAddViewModel {
  final Dio dio = Dio();

  Future<AttendanceAddResponse> attendanceAddPost(
    String title,
    String description,
    String availableFrom,
    String availableTo,
    bool allowLateness,
    List<String> attendanceDays,
  ) async {
    try {
      Response response = await ApiService.dio.post(
        data: {
          'title': title,
          'description': description,
          'availableFrom': availableFrom,
          'availableTo': availableTo,
          'allowLateness': allowLateness,
          'attendanceDays': attendanceDays,
        },
        '/attendances',
      );
      return AttendanceAddResponse.fromJson(response.data);
    } on DioException catch (e) {
      // print(e);
      final response = e.response;
      if (response != null) {
        print(response.data);
        return AttendanceAddResponse.fromJson(response.data);
      } else {
        print(e.requestOptions);
        print(e.message);
        throw Exception('Failed to load post: $e');
      }
    }
  }
}
