import 'package:checkuuree/model/attendance_list_response.dart' as attendance_list_response;
import 'package:checkuuree/view/attendance_add_screen.dart';
import 'package:checkuuree/view/attendance_check_screen.dart';
import 'package:checkuuree/view_model/attendance_list_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AttendanceListScreen extends StatefulWidget {
  const AttendanceListScreen({super.key});

  @override
  State<AttendanceListScreen> createState() => _AttendanceListScreenState();
}

class _AttendanceListScreenState extends State<AttendanceListScreen> {
  final _formKey = GlobalKey<FormState>();
  final AttendanceListViewModel _viewModel = AttendanceListViewModel();
  List<attendance_list_response.Items> data = [];
  final DateTime now = DateTime.now();
  late final String formattedDate;
  late final String date;

  final Map<String, String> dayMappings = {
    'MONDAY': '월',
    'TUESDAY': '화',
    'WEDNESDAY': '수',
    'THURSDAY': '목',
    'FRIDAY': '금',
    'SATURDAY': '토',
    'SUNDAY': '일'
  };
  final Map<int, String> intToDayMappings = {
    1: 'MONDAY',
    2: 'TUESDAY',
    3: 'WEDNESDAY',
    4: 'THURSDAY',
    5: 'FRIDAY',
    6: 'SATURDAY',
    7: 'SUNDAY'
  };
  final Map<String, int> dayIntMaps = {'월': 1, '화': 2, '수': 3, '목': 4, '금': 5, '토': 6, '일': 7};

  @override
  void initState() {
    super.initState();
    _loadAttendanceList();
    final now = DateTime.now();
    formattedDate = DateFormat('EEEE', 'ko_KR').format(now);
    date = DateFormat('yyyy년 MM월 dd일', 'ko_KR').format(now);
  }

  Future<void> _loadAttendanceList() async {
    bool success = await _attendanceListGet(context);
    if (success) {
      setState(() {});
    }
  }

  Future<bool> _attendanceListGet(BuildContext context) async {
    attendance_list_response.AttendanceListResponse response = await _viewModel.attendanceListGet();
    if (response.success) {
      data = response.items!;
    }
    return response.success;
  }

  List<String> getSelectedDays(int index) {
    List<String> selectedDays = [];
    List<String> daysList = data[index].attendance.days ?? [];
    for (String day in daysList) {
      String koreanDay = dayMappings[day] ?? "null";
      selectedDays.add(koreanDay);
    }
    return selectedDays;
  }

  // 한국어 요일명을 숫자 리스트로 변환
  List<int> convertDaysToIntList(List<String> days) {
    return days.map((day) => dayIntMaps[day]).where((element) => element != null).cast<int>().toList();
  }

  String formatDays(List<int> sortedDays) {
    if (sortedDays.isEmpty) return '';
    sortedDays.sort();
    List<String> dayNames = sortedDays.map((day) => intToDayMappings[day]!).toList();

    List<String> formattedDays = [];
    int start = 0; // 연속된 요일의 시작 인덱스
    for (int i = 0; i < dayNames.length; i++) {
      // 다음 요일이 현재 요일의 바로 다음 요일이 아니거나, 리스트의 끝에 도달한 경우
      if (i == dayNames.length - 1 || dayIntMaps[dayMappings[dayNames[i + 1]]!]! != dayIntMaps[dayMappings[dayNames[i]]!]! + 1) {
        // 현재 요일이 시작 요일과 같은 경우 (단일 요일)
        if (i == start) {
          formattedDays.add(dayMappings[dayNames[i]]!);
        } else {
          // 현재 요일이 시작 요일과 다른 경우 (연속된 요일)
          formattedDays.add("${dayMappings[dayNames[start]]!}-${dayMappings[dayNames[i]]!}");
        }
        start = i + 1; // 다음 연속된 요일의 시작 인덱스를 업데이트
      }
    }

    return formattedDays.join(", ");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Text(
                "$date $formattedDate",
                style: const TextStyle(fontSize: 14),
              ),
              const Text(
                "님, 안녕하세요.",
                style: TextStyle(fontSize: 20),
              ),
              Expanded(
                child: data.isNotEmpty
                    ? GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 4.0,
                          mainAxisSpacing: 4.0,
                        ),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AttendanceCheckScreen(
                                    attendanceData: data[index],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFF59996B),
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Card(
                                clipBehavior: Clip.antiAlias,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Image.network(
                                        data[index].attendance.imageUrl ??
                                            "https://play-lh.googleusercontent.com/ADg24o30zrA8aN9PpFBVrgFX2G7A8mgf3tLIcGjpihXlg0NonhtjiowXmpSzB0v8F60=w480-h960-rw",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Text(
                                      data[index].attendance.title,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      data[index].attendance.description ?? "",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF797979),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            formatDays(convertDaysToIntList(getSelectedDays(index))),
                                            // convertDaysToIntList(getSelectedDays(index)).toString(),
                                            // getSelectedDays(index).toString(),
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Color(0xFF797979),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : const Center(
                        child: Text('데이터 없음.'),
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return const FractionallySizedBox(
                heightFactor: 0.9, // 모달의 높이를 화면 높이의 90%로 설정
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: AttendanceAddScreen(),
                ),
              );
            },
          ).then((value) {
            if (value == true) {
              _loadAttendanceList();
            }
          });
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        backgroundColor: const Color(0xFF054302),
        child: const Icon(Icons.add),
      ),
    );
  }
}
