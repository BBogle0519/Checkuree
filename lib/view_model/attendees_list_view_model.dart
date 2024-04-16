import 'package:checkuuree/model/attendees_list_response.dart';
import 'package:dio/dio.dart';
import '../service/api_service.dart';

class AttendeesListViewModel {
  final Dio dio = Dio();

  Future<AttendeesListResponse> attendeesListGet(String attendanceId) async {
    try {
      Response response = await ApiService.dio.get(
        '/attendees/attendanceId/$attendanceId',
      );
      return AttendeesListResponse.fromJson(response.data);
    } on DioException catch (e) {
      // print(e);
      final response = e.response;
      if (response != null) {
        print(response.data);
        return AttendeesListResponse.fromJson(response.data);
      } else {
        print(e.requestOptions);
        print(e.message);
        throw Exception('Failed to load post: $e');
      }
    }
  }
}
