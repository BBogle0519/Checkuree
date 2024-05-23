import 'package:checkuuree/service/api_service.dart';
import 'package:dio/dio.dart';

import '../model/attendee_add_response.dart';

class AttendeeAddViewModel {
  final Dio dio = Dio();

  Future<AttendeeAddResponse> attendeeAddPost(
    String attendanceId,
    String name,
    String gender,
    String mobileNumber,
    String subMobileNumber,
    String birth,
    String course,
    String grade,
    String school,
    String description,
  ) async {
    try {
      Response response = await ApiService.dio.post(
        data: {
          'attendanceId': attendanceId,
          'name': name,
          'gender': gender,
          'mobileNumber': mobileNumber,
          'subMobileNumber': subMobileNumber,
          'birth': birth,
          'course': course,
          'grade': grade,
          'school': school,
          'description': description,
        },
        '/attendees',
      );
      return AttendeeAddResponse.fromJson(response.data);
    } on DioException catch (e) {
      // print(e);
      final response = e.response;
      if (response != null) {
        print(response.data);
        return AttendeeAddResponse.fromJson(response.data);
      } else {
        print(e.requestOptions);
        print(e.message);
        throw Exception('Failed to load post: $e');
      }
    }
  }
}
