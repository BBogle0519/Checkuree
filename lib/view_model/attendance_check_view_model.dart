import 'package:checkuuree/model/attendance_check_response.dart';
import 'package:dio/dio.dart';

import '../service/api_service.dart';

class AttendanceCheckViewModel {
  final Dio dio = Dio();

  Future<AttendanceCheckResponse> attendeesListGet(String attendanceId) async {
    try {
      Response response = await ApiService.dio.get(
        '/attendees/attendanceId/$attendanceId',
      );
      return AttendanceCheckResponse.fromJson(response.data);
    } on DioException catch (e) {
      // print(e);
      final response = e.response;
      if (response != null) {
        print(response.data);
        return AttendanceCheckResponse.fromJson(response.data);
      } else {
        print(e.requestOptions);
        print(e.message);
        throw Exception('Failed to load post: $e');
      }
    }
  }
}
