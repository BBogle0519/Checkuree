import 'package:checkuuree/model/attendee_list_response.dart';
import 'package:dio/dio.dart';
import '../service/api_service.dart';

class AttendeeListViewModel {
  final Dio dio = Dio();

  Future<AttendeeListResponse> attendeeListGet(String attendanceId) async {
    try {
      Response response = await ApiService.dio.get(
        '/attendees/attendanceId/$attendanceId',
      );
      return AttendeeListResponse.fromJson(response.data);
    } on DioException catch (e) {
      // print(e);
      final response = e.response;
      if (response != null) {
        print(response.data);
        return AttendeeListResponse.fromJson(response.data);
      } else {
        print(e.requestOptions);
        print(e.message);
        throw Exception('Failed to load post: $e');
      }
    }
  }
}
