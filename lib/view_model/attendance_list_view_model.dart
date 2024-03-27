import 'package:checkuuree/model/attendance_list_response.dart';
import 'package:checkuuree/service/api_service.dart';
import 'package:dio/dio.dart';

class AttendanceListViewModel {
  final Dio dio = Dio();

  Future<AttendanceListResponse> attendanceListGet() async {
    try {
      Response response = await ApiService.dio.get(
        '/attendances',
      );
      return AttendanceListResponse.fromJson(response.data);
    } on DioException catch (e) {
      // print(e);
      final response = e.response;
      if (response != null) {
        print(response.data);
        return AttendanceListResponse.fromJson(response.data);
      } else {
        print(e.requestOptions);
        print(e.message);
        throw Exception('Failed to load post: $e');
      }
    }
  }
}
