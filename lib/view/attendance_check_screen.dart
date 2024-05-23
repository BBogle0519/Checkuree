import 'package:checkuuree/model/attendee_list_response.dart' as attendees_list_response;
import 'package:checkuuree/model/attendance_list_response.dart' as attendance_list_response;
import 'package:checkuuree/view/attendee_list_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import '../view_model/attendee_list_view_model.dart';

class AttendanceCheckScreen extends StatefulWidget {
  //이전 화면에서 전달받은 데이터
  final attendance_list_response.Items attendanceData;

  const AttendanceCheckScreen({
    super.key,
    required this.attendanceData,
  });

  @override
  State<AttendanceCheckScreen> createState() => _AttendanceCheckScreenState();
}

class _AttendanceCheckScreenState extends State<AttendanceCheckScreen> {
  final _formKey = GlobalKey<FormState>();
  final AttendeeListViewModel _viewModel = AttendeeListViewModel();
  late List<attendees_list_response.Items> data = [];
  bool _showBottomSheet = true;
  bool _showSave = false;
  DateTime currentDate = DateTime.now();
  final daysInMonth = DateUtils.getDaysInMonth;

  int presentCount = 0;
  int tardyCount = 0;
  int absentCount = 0;

  final Map<int, bool> _isFormItemVisible = {};
  Map<int, Map<String, dynamic>> attendanceStates = {};
  Map<int, Map<String, dynamic>> tardyStates = {};
  Map<int, Map<String, dynamic>> absentStates = {};

  final List<String> mainStates = ['selectedAttendance', 'selectedTardy', 'selectedAbsent'];
  final List<String> tardyDetails = ['5Minute', '10Minute', '15Minute', '20moreMinute'];
  final List<String> absentDetails = ['Excused', 'Sick', 'Unexcused', 'Other'];

  @override
  void initState() {
    super.initState();
    _loadAttendeesList();
  }

  Positioned buildBottomSheet(BuildContext context) {
    Widget content = _showSave
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 3,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFFFFF),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.all(16), // 내부 패딩
                    ),
                    onPressed: () {},
                    child: const Text(
                      "취소",
                      style: TextStyle(fontSize: 16, color: Color(0xFF59996B), fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 5,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF59996B),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.all(16), // 내부 패딩
                    ),
                    onPressed: () {},
                    child: const Text(
                      "저장",
                      style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          )
        : BottomSheet(
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
                            setState(() {});
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
                            Navigator.pushReplacement(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, animation1, animation2) => AttendeeListScreen(attendanceData: widget.attendanceData),
                                transitionDuration: Duration.zero,
                                reverseTransitionDuration: Duration.zero,
                              ),
                            );
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

  void toggleItemSelection(Map<int, Map<String, dynamic>> statesMap, int index, String stateKey) {
    setState(() {
      final currentStates = statesMap[index] ?? {};
      bool isSelected = currentStates[stateKey] ?? false;

      // 모든 상태를 초기화
      for (var state in mainStates) {
        currentStates[state] = false;
      }
      for (var detail in tardyDetails) {
        currentStates[detail] = false;
      }
      for (var detail in absentDetails) {
        currentStates[detail] = false;
      }

      // 현재 상태를 업데이트
      currentStates[stateKey] = !isSelected;

      // 세부 사유가 선택된 경우, 관련된 주요 상태를 true로 설정
      if (tardyDetails.contains(stateKey)) {
        currentStates['selectedTardy'] = true;
      } else if (absentDetails.contains(stateKey)) {
        currentStates['selectedAbsent'] = true;
      }

      // 주요 상태가 변경되었을 경우, 관련된 세부 사유를 초기화하지 않고, 단순히 현재 상태만 업데이트
      if (mainStates.contains(stateKey)) {
        // 세부 사유 선택 로직 추가가 필요할 수 있음
      }

      // 변경된 상태를 statesMap에 반영
      statesMap[index] = currentStates;
      // 로깅을 통해 상태 변경 확인
      print("index=$index, stateKey=$stateKey, \n states=${statesMap[index]}");
      // print("");

      if (statesMap[index]!.values.any((value) => value == true)) {
        _showSave = true;
      }
      if (statesMap[index]!.values.every((value) => value == false)) {
        _showSave = false;
      }
    });
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

  void _incrementDay() {
    setState(() {
      currentDate = currentDate.add(const Duration(days: 1));
    });
  }

  void _decrementDay() {
    setState(() {
      currentDate = currentDate.subtract(const Duration(days: 1));
    });
  }

  @override
  Widget build(BuildContext context) {
    String weekday = DateFormat('EE', 'ko').format(currentDate);

    return Scaffold(
      appBar: AppBar(),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification is ScrollStartNotification) {
            // 스크롤이 시작될 때 하단 메뉴바 숨기기
            setState(() {
              _showBottomSheet = false;
            });
          } else if (scrollNotification is ScrollEndNotification) {
            // 스크롤이 종료될 때 하단 메뉴바 표시
            setState(() {
              _showBottomSheet = true;
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
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Expanded(
                              child: Text(
                                "출석부 이름",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.chevron_left),
                                  onPressed: _decrementDay,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 2.0,
                                    vertical: 2.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(2.0),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(2.0),
                                        ),
                                        child: Text(
                                          currentDate.month.toString().padLeft(2, '0'),
                                        ),
                                      ),
                                      const SizedBox(width: 2),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(2.0),
                                        ),
                                        child: Text(
                                          currentDate.day.toString().padLeft(2, '0'),
                                        ),
                                      ),
                                      const SizedBox(width: 2),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(2.0),
                                        ),
                                        child: Text(weekday),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.chevron_right),
                                  onPressed: _incrementDay,
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.groups),
                            Text("${data.length}"),
                            const Icon(Icons.mood),
                            Text("$presentCount"),
                            const Icon(Icons.access_time),
                            Text("$tardyCount"),
                            const Icon(Icons.cancel_outlined),
                            Text("$absentCount"),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: data.isNotEmpty
                          ? ListView.builder(
                              itemCount: data.length + 1,
                              itemBuilder: (context, index) {
                                if (index == data.length) {
                                  //최하단 항목이 메뉴에 가리는 문제 해결 위함
                                  return const SizedBox(
                                    height: 150.0,
                                  );
                                } else {
                                  return Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 0.0,
                                          vertical: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8.0),
                                          border: Border.all(
                                            width: 1,
                                            color: const Color(0xFF59996B),
                                          ),
                                          color: (attendanceStates[index]?['selectedAttendance'] == true)
                                              ? const Color(0xFFEDF9E3)
                                              : (attendanceStates[index]?['selectedTardy'] == true)
                                                  ? const Color(0xFFEDC588)
                                                  : (attendanceStates[index]?['selectedAbsent'] == true)
                                                      ? const Color(0xFFE9B3B3)
                                                      : Colors.white,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                '${data[index].name} ',
                                                style: const TextStyle(fontSize: 16),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    final currentItemVisibility = _isFormItemVisible[index] ?? false;
                                                    _isFormItemVisible[index] = !currentItemVisibility;
                                                  });
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.zero,
                                                  width: 20.0,
                                                  height: 20.0,
                                                  child: const Icon(
                                                    size: 20,
                                                    Icons.arrow_drop_down_circle,
                                                  ),
                                                ),
                                              ),
                                              Flexible(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: List.generate(
                                                    3,
                                                    (statusIndex) {
                                                      String stateKey;
                                                      switch (statusIndex) {
                                                        case 0:
                                                          stateKey = 'selectedAttendance';
                                                          break;
                                                        case 1:
                                                          stateKey = 'selectedTardy';
                                                          break;
                                                        case 2:
                                                          stateKey = 'selectedAbsent';
                                                          break;
                                                        default:
                                                          stateKey = 'null';
                                                      }
                                                      return Flexible(
                                                        child: Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                                          child: InkWell(
                                                            onTap: () => toggleItemSelection(attendanceStates, index, stateKey),
                                                            child: Container(
                                                              padding: const EdgeInsets.symmetric(
                                                                horizontal: 10.0,
                                                                vertical: 4.0,
                                                              ),
                                                              decoration: BoxDecoration(
                                                                color: (attendanceStates[index]?[stateKey] == true)
                                                                    ? Colors.black
                                                                    : Colors.transparent,
                                                                borderRadius: BorderRadius.circular(21.0),
                                                                border: Border.all(
                                                                  color: (attendanceStates[index]?[stateKey] == true)
                                                                      ? Colors.black
                                                                      : Colors.grey,
                                                                ),
                                                              ),
                                                              child: Text(
                                                                [
                                                                  '출석',
                                                                  '지각',
                                                                  '결석',
                                                                ][statusIndex],
                                                                style: TextStyle(
                                                                  color: (attendanceStates[index]?[stateKey] == true)
                                                                      ? Colors.white
                                                                      : Colors.black,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      if (_isFormItemVisible[index] == true &&
                                          attendanceStates[index]?.values.any((value) => value) == true)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 0.0,
                                              vertical: 0.0,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8.0),
                                              color: (attendanceStates[index]?["selectedAttendance"] == true)
                                                  ? const Color(0xFFEDF9E3)
                                                  : (attendanceStates[index]?["selectedTardy"] == true)
                                                      ? const Color(0xFFEDC588)
                                                      : (attendanceStates[index]?["selectedAbsent"] == true)
                                                          ? const Color(0xFFE9B3B3)
                                                          : Colors.white,
                                            ),
                                            child: Column(
                                              children: [
                                                attendanceStates[index]?["selectedTardy"] == true
                                                    ? Row(
                                                        children: List.generate(
                                                          4,
                                                          (statusIndex) {
                                                            String stateKey;
                                                            switch (statusIndex) {
                                                              case 0:
                                                                stateKey = '5Minute';
                                                                break;
                                                              case 1:
                                                                stateKey = '10Minute';
                                                                break;
                                                              case 2:
                                                                stateKey = '15Minute';
                                                                break;
                                                              case 3:
                                                                stateKey = '20moreMinute';
                                                                break;
                                                              default:
                                                                stateKey = 'null';
                                                            }
                                                            return Flexible(
                                                              child: Padding(
                                                                padding: const EdgeInsets.symmetric(
                                                                  horizontal: 4.0,
                                                                  vertical: 4.0,
                                                                ),
                                                                child: InkWell(
                                                                  onTap: () => toggleItemSelection(tardyStates, index, stateKey),
                                                                  child: Container(
                                                                    padding: const EdgeInsets.symmetric(
                                                                      horizontal: 8.0,
                                                                      vertical: 0.0,
                                                                    ),
                                                                    decoration: BoxDecoration(
                                                                      color: (tardyStates[index]?[stateKey] == true)
                                                                          ? Colors.black
                                                                          : Colors.transparent,
                                                                      borderRadius: BorderRadius.circular(21.0),
                                                                      border: Border.all(
                                                                        color: (tardyStates[index]?[stateKey] == true)
                                                                            ? Colors.black
                                                                            : Colors.transparent,
                                                                      ),
                                                                    ),
                                                                    child: Text(
                                                                      [
                                                                        '5분',
                                                                        '10분',
                                                                        '15분',
                                                                        '20분 이상',
                                                                      ][statusIndex],
                                                                      style: TextStyle(
                                                                        fontSize: 12,
                                                                        color: (tardyStates[index]?[stateKey] == true)
                                                                            ? Colors.white
                                                                            : Colors.black,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      )
                                                    : attendanceStates[index]?["selectedAbsent"] == true
                                                        ? Row(
                                                            children: [
                                                              ...List.generate(
                                                                4,
                                                                (statusIndex) {
                                                                  String stateKey;
                                                                  switch (statusIndex) {
                                                                    case 0:
                                                                      stateKey = 'Excused';
                                                                      break;
                                                                    case 1:
                                                                      stateKey = 'Sick';
                                                                      break;
                                                                    case 2:
                                                                      stateKey = 'Unexcused';
                                                                      break;
                                                                    case 3:
                                                                      stateKey = 'Other';
                                                                      break;
                                                                    default:
                                                                      stateKey = 'null';
                                                                  }
                                                                  return Flexible(
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.symmetric(
                                                                        horizontal: 4.0,
                                                                        vertical: 4.0,
                                                                      ),
                                                                      child: InkWell(
                                                                        onTap: () => toggleItemSelection(absentStates, index, stateKey),
                                                                        child: Container(
                                                                          padding: const EdgeInsets.symmetric(
                                                                            horizontal: 8.0,
                                                                            vertical: 0.0,
                                                                          ),
                                                                          decoration: BoxDecoration(
                                                                            color: (absentStates[index]?[stateKey] == true)
                                                                                ? Colors.black
                                                                                : Colors.transparent,
                                                                            borderRadius: BorderRadius.circular(21.0),
                                                                            border: Border.all(
                                                                              color: (absentStates[index]?[stateKey] == true)
                                                                                  ? Colors.black
                                                                                  : Colors.transparent,
                                                                            ),
                                                                          ),
                                                                          child: Text(
                                                                            [
                                                                              '공결',
                                                                              '병결',
                                                                              '무단',
                                                                              '기타',
                                                                            ][statusIndex],
                                                                            style: TextStyle(
                                                                              fontSize: 12,
                                                                              color: (absentStates[index]?[stateKey] == true)
                                                                                  ? Colors.white
                                                                                  : Colors.black,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                            ],
                                                          )
                                                        : Container(),
                                                // if (_isFormVisible &&
                                                //     selectedAttendanceIndex != null)

                                                if (_isFormItemVisible[index] == true &&
                                                    (attendanceStates[index]?.values.any((value) => value == true) ?? true)) ...[
                                                  Padding(
                                                    padding: const EdgeInsets.all(6.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(8.0),
                                                      ),
                                                      child: TextFormField(
                                                        keyboardType: TextInputType.multiline,
                                                        maxLines: null,
                                                        textAlignVertical: TextAlignVertical.top,
                                                        decoration: const InputDecoration(
                                                          hintText: "설명 입력",
                                                          border: InputBorder.none,
                                                          filled: true,
                                                          fillColor: Colors.transparent,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ]
                                              ],
                                            ),
                                          ),
                                        ),
                                      const SizedBox(height: 4.0),
                                    ],
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
            buildBottomSheet(context),
          ],
        ),
      ),
    );
  }
}
