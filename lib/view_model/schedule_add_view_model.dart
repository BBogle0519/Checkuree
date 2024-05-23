import 'package:checkuuree/model/schedule_add_response.dart';
import 'package:checkuuree/service/api_service.dart';
import 'package:dio/dio.dart';

class ScheduleAddViewModel {
  final Dio dio = Dio();

  Future<ScheduleAddResponse> scheduleAddPost(
    String attendanceId,
    String attendeeId,
    List<SingleSchedules> singleSchedules,
  ) async {
    try {
      Response response = await ApiService.dio.post(
        data: {
          'attendanceId': attendanceId,
          'attendeeId': attendeeId,
          'singleSchedules': singleSchedules.map((schedule) => schedule.toJson()).toList(),
        },
        '/schedules',
      );
      return ScheduleAddResponse.fromJson(response.data);
    } on DioException catch (e) {
      // print(e);
      final response = e.response;
      if (response != null) {
        print(response.data);
        return ScheduleAddResponse.fromJson(response.data);
      } else {
        print(e.requestOptions);
        print(e.message);
        throw Exception('Failed to load post: $e');
      }
    }
  }
}

class SingleSchedules {
  late String day;
  late String? time;

  SingleSchedules({String? day, this.time}) {
    this.day = day ?? '';
  }

  // JSON 직렬화를 위한 메소드, 다음 부턴 json_serializable 사용할 것
  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'time': time,
    };
  }

  @override
  String toString() {
    return '{day: $day, time: $time}';
  }
}
