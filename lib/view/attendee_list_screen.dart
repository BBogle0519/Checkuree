import 'package:checkuuree/view/attendance_check_screen.dart';
import 'package:checkuuree/model/attendance_list_response.dart' as attendance_list_response;
import 'package:checkuuree/model/attendee_list_response.dart' as attendees_list_response;
import 'package:checkuuree/view/attendee_add_screen.dart';
import 'package:flutter/material.dart';
import '../view_model/attendee_list_view_model.dart';

class AttendeeListScreen extends StatefulWidget {
  //이전 화면에서 전달받은 데이터
  final attendance_list_response.Items attendanceData;

  const AttendeeListScreen({super.key, required this.attendanceData});

  @override
  State<AttendeeListScreen> createState() => _AttendeeListScreenState();
}

class _AttendeeListScreenState extends State<AttendeeListScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _showBottomSheet = true;
  bool _floatingButton = true;
  final AttendeeListViewModel _viewModel = AttendeeListViewModel();
  late List<attendees_list_response.Items> data = [];

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

  List<String> getDaysListFromSchedules(int index) {
    if (index < data.length && data[index].schedules != null) {
      // print(data[index].schedules!.map((schedule) => schedule.day ?? '').toSet().toList());
      return data[index].schedules!.map((schedule) => schedule.day ?? '').toSet().toList();
    }
    return [];
  }

  List<String> getSelectedDays(int index) {
    // data[index].schedules?[index].day
    List<String> selectedDays = [];
    List<String> daysList = getDaysListFromSchedules(index);
    for (String day in daysList) {
      String koreanDay = dayMappings[day] ?? "null";
      selectedDays.add(koreanDay);
    }
    return selectedDays;
  }

  // '${data[index].schedules?[index].day}',
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
  void initState() {
    super.initState();
    _loadAttendeesList();
  }

  Future<void> _loadAttendeesList() async {
    bool success = await _attendeesListGet(context);
    if (success) {
      setState(() {});
    }
  }

  Future<bool> _attendeesListGet(BuildContext context) async {
    attendees_list_response.AttendeeListResponse response = await _viewModel.attendeeListGet(widget.attendanceData.attendanceId);
    if (response.success) {
      data = response.items!;
    }
    return response.success;
  }

  Positioned buildBottomSheet(BuildContext context) {
    Widget content = BottomSheet(
      onClosing: () {},
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF054302),
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.how_to_reg,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) => AttendanceCheckScreen(
                            attendanceData: widget.attendanceData,
                          ),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ),
                      );
                    },
                  ),
                  const Text(
                    "출석 체크",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.show_chart,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ),
                  const Text(
                    "출석 통계",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.list,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {});
                    },
                  ),
                  const Text(
                    "명단 관리",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.tune,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ),
                  const Text(
                    "출석부 설정",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    return Positioned(
      left: 0,
      right: 0,
      bottom: 30,
      child: _showBottomSheet ? content : const SizedBox(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification is ScrollStartNotification) {
            // 스크롤이 시작될 때 숨기기
            setState(() {
              _showBottomSheet = false;
              _floatingButton = false;
            });
          } else if (scrollNotification is ScrollEndNotification) {
            // 스크롤이 종료될 때 표시
            setState(() {
              _showBottomSheet = true;
              _floatingButton = true;
            });
          }
          return false;
        },
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                "출석부 이름",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: data.isNotEmpty
                          ? GridView.builder(
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                childAspectRatio: 5.5,
                                crossAxisSpacing: 4.0,
                                mainAxisSpacing: 8.0,
                              ),
                              itemCount: data.length + 1,
                              itemBuilder: (context, index) {
                                if (index == data.length) {
                                  //최하단 항목이 메뉴에 가리는 문제 해결 위함
                                  return const SizedBox(
                                    height: 150.0,
                                  );
                                } else {
                                  return InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        builder: (BuildContext context) {
                                          return FractionallySizedBox(
                                            heightFactor: 0.9, // 모달의 높이를 화면 높이의 90%로 설정
                                            child: ClipRRect(
                                              borderRadius: const BorderRadius.only(
                                                topLeft: Radius.circular(20),
                                                topRight: Radius.circular(20),
                                              ),
                                              child: AttendeeAddScreen(
                                                attendanceData: widget.attendanceData,
                                                attendeeData: data[index],
                                                modifyVisible: true,
                                              ),
                                            ),
                                          );
                                        },
                                      ).then((value) {
                                        if (value == true) {
                                          _loadAttendeesList();
                                        }
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: const Color(0xFF59996B),
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Card(
                                        elevation: 0,
                                        color: Colors.transparent,
                                        clipBehavior: Clip.antiAlias,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Column(
                                          // mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                '${data[index].name} ',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      // formatDays(convertDaysToIntList(getSelectedDays())),
                                                      // '${data[index].schedules?[index].day}',
                                                      formatDays(convertDaysToIntList(getSelectedDays(index))),
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Color(0xFF797979),
                                                      ),
                                                    ),
                                                  ),
                                                  const Icon(Icons.mood),
                                                  // Text("$presentCount"),
                                                  const Icon(Icons.access_time),
                                                  // Text("$tardyCount"),
                                                  const Icon(Icons.cancel_outlined),
                                                  // Text("$absentCount"),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }
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
            if (_floatingButton)
              Positioned(
                right: 10,
                bottom: 120,
                child: FloatingActionButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return FractionallySizedBox(
                          heightFactor: 0.9, // 모달의 높이를 화면 높이의 90%로 설정
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            child: AttendeeAddScreen(
                              attendanceData: widget.attendanceData,
                              modifyVisible: false,
                            ),
                          ),
                        );
                      },
                    ).then((value) {
                      if (value == true) {
                        _loadAttendeesList();
                      }
                    });
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  backgroundColor: const Color(0xFF054302),
                  child: const Icon(Icons.add),
                ),
              ),
            buildBottomSheet(context),
          ],
        ),
      ),
    );
  }
}
