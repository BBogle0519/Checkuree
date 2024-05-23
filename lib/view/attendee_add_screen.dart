import 'package:checkuuree/model/schedule_add_response.dart';
import 'package:checkuuree/view_model/schedule_add_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:checkuuree/model/attendance_list_response.dart' as attendance_list_response;
import 'package:checkuuree/model/attendee_list_response.dart' as attendee_list_response;

import '../model/attendee_add_response.dart';
import '../utils/show_toast.dart';
import '../view_model/attendee_add_view_model.dart';

class AttendeeAddScreen extends StatefulWidget {
  //이전 화면에서 전달받은 데이터
  final attendance_list_response.Items attendanceData;
  final attendee_list_response.Items? attendeeData;
  final bool modifyVisible;

  const AttendeeAddScreen({super.key, required this.attendanceData, this.attendeeData, required this.modifyVisible});

  @override
  State<AttendeeAddScreen> createState() => _AttendeeAddScreenState();
}

class _AttendeeAddScreenState extends State<AttendeeAddScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _dateController;
  late final TextEditingController _phoneNumController;
  final AttendeeAddViewModel _viewAttendeeAddModel = AttendeeAddViewModel();
  final ScheduleAddViewModel _viewScheduleAddModel = ScheduleAddViewModel();

  late bool _selectedValue;

  List<String> daysOfWeekKOR = ['월', '화', '수', '목', '금', '토', '일'];
  List<String> daysOfWeekENG = ['MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY', 'SUNDAY'];

  Map<String, int> dayOrder = {'월': 1, '화': 2, '수': 3, '목': 4, '금': 5, '토': 6, '일': 7};
  Map<String, int> dayMappings = {'MONDAY': 0, 'TUESDAY': 1, 'WEDNESDAY': 2, 'THURSDAY': 3, 'FRIDAY': 4, 'SATURDAY': 5, 'SUNDAY': 6};

  bool _modifyVisible = false;
  bool _isDaySelectedErrorVisible = false;
  DateTime? _selectedDate;
  late String birth;
  late int birthYear;
  late String birthDay;
  late String _selectedGenderText;

  late List<String> timeList;
  late List<int> mappedDays;

  List<ToggleStatus> toggleStatuses = [];
  List<String> selectedTimes = [];

  @override
  void initState() {
    super.initState();
    timeList = _timePickerItems(widget.attendanceData.attendance.availableFrom, widget.attendanceData.attendance.availableTo);
    mappedDays = widget.attendanceData.attendance.days?.map((day) => dayMappings[day] ?? -1).toList() ?? [];
    mappedDays.sort();
    toggleStatuses = List.generate(mappedDays.length, (_) => ToggleStatus());
    _modifyVisible = widget.modifyVisible;

    _nameController = TextEditingController(text: widget.attendeeData?.name ?? '');
    _dateController = TextEditingController(text: widget.attendeeData?.birth ?? '');
    _phoneNumController = TextEditingController(text: widget.attendeeData?.mobileNumber ?? '');
    _selectedGenderText = widget.attendeeData?.gender ?? 'MALE';
    if (_selectedGenderText == 'MALE') {
      _selectedValue = true;
    } else if (_selectedGenderText == 'FEMALE') {
      _selectedValue = false;
    }
  }

  Future<bool> _addAttendee(BuildContext context) async {
    String attendanceId = widget.attendanceData.attendanceId;
    String name = _nameController.text;
    String gender = _selectedGenderText;
    String mobileNumber = _phoneNumController.text;
    String subMobileNumber = "01012345678";
    String birth = _dateController.text;
    String course = "강의명 입력 없음";
    String grade = "유치부";
    String school = "학교명 입력 없음";
    String description = "설명 입력 없음";

    AttendeeAddResponse response = await _viewAttendeeAddModel.attendeeAddPost(
      attendanceId,
      name,
      gender,
      mobileNumber,
      subMobileNumber,
      birth,
      course,
      grade,
      school,
      description,
    );

    if (response.success) {
      String id = response.data!.id;
      bool scheduleAdded = await _scheduleAdd(id);
      if (!scheduleAdded) {
        // 롤백 로직 실행
        // await _rollbackAttendee(id);
        return false;
      }
      return true;
    }
    return false;
  }

  // Future<void> _rollbackAttendee(String attendeeId) async {
  //   // 롤백 API 호출 코드
  //   await _viewAttendeeAddModel.deleteAttendee(attendeeId);
  // }

  Future<bool> _scheduleAdd(String attendeeId) async {
    String attendanceId = widget.attendanceData.attendanceId;
    List<SingleSchedules> singleSchedules = convertStatuses(toggleStatuses);

    ScheduleAddResponse response = await _viewScheduleAddModel.scheduleAddPost(
      attendanceId,
      attendeeId,
      singleSchedules,
    );
    return response.success;
  }

  List<SingleSchedules> convertStatuses(List<ToggleStatus> statuses) {
    List<SingleSchedules> converted = [];

    for (int i = 0; i < mappedDays.length; i++) {
      statuses[i].day = mappedDays[i];
    }

    for (int i = 0; i < statuses.length; i++) {
      var status = statuses[i];
      if (status.status == -1 || status.times.isEmpty) {
        continue;
      }

      for (var time in status.times) {
        String formattedTime = time.replaceAll(':', '');
        converted.add(SingleSchedules(day: daysOfWeekENG[status.day], time: formattedTime));
      }
    }
    // for (int i = 0; i < statuses.length; i++) {
    //   var status = statuses[i];
    //   if (status.status == -1 || status.times.isEmpty) {
    //     continue;
    //   }
    //
    //   for (var time in status.times) {
    //     String formattedTime = time.replaceAll(':', '');
    //     converted.add(SingleSchedules(day: daysOfWeekENG[i], time: formattedTime));
    //   }
    // }

    return converted;
  }

  //토글 상태 관리
  void handleToggleTap(int index) {
    setState(() {
      if (toggleStatuses[index].status == 1) {
        // 선택 중 상태에서 다시 탭했을 때
        toggleStatuses[index].status = -1;
        toggleStatuses[index].clearTimes();
      } else {
        // 다른 버튼이 선택 데이터 있음 상태로 변경
        for (int i = 0; i < toggleStatuses.length; i++) {
          if (i == index) {
            toggleStatuses[i].status = 1; // 현재 탭된 버튼은 선택 중으로 변경
          } else if (toggleStatuses[i].times.isNotEmpty) {
            toggleStatuses[i].status = 0; // 다른 버튼들은 선택 데이터 있음 상태로 변경
          } else {
            toggleStatuses[i].status = -1; // 데이터가 없다면 기본 상태 유지
          }
        }
      }
    });
  }

  //토글 위젯
  Widget buildToggle(int index) {
    var toggle = toggleStatuses[index];

    return InkWell(
      onTap: () => handleToggleTap(index),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 8.0,
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: toggle.status == 1 ? const Color(0xFFF0FFF4) : (toggle.status == 0 ? const Color(0x70F0FFF4) : Colors.transparent),
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: toggle.status == 1 ? const Color(0xFF59996B) : (toggle.status == 0 ? const Color(0x7059996B) : const Color(0xFFC9C9C9)),
          ),
        ),
        child: Text(
          // '${daysOfWeekKOR[mappedDays[index]]} (${toggle.times.join(", ")})',
          daysOfWeekKOR[mappedDays[index]],
          style: TextStyle(
            color: toggle.status == 1 ? const Color(0xFF59996B) : (toggle.status == 0 ? const Color(0x7059996B) : const Color(0xFFC9C9C9)),
          ),
        ),
      ),
    );
  }

  //체크 박스 위젯
  Widget buildTimePicker() {
    int selectedIndex = toggleStatuses.indexWhere((t) => t.status == 1);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      child: Column(
        children: [
          ...timeList.map(
            (time) {
              return Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Expanded(child: Text(time)),
                      Checkbox(
                        value: toggleStatuses[selectedIndex].times.contains(time),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        activeColor: Colors.transparent,
                        checkColor: const Color(0xFF59996B),
                        onChanged: (bool? selected) {
                          setState(() {
                            if (selected == true) {
                              toggleStatuses[selectedIndex].times.add(time);
                              if (!selectedTimes.contains(time)) {
                                selectedTimes.add(time);
                              }
                              toggleStatuses[selectedIndex].times.sort();
                              selectedTimes.sort();
                            } else {
                              toggleStatuses[selectedIndex].times.remove(time);
                              selectedTimes.remove(time);
                              toggleStatuses[selectedIndex].times.sort();
                              selectedTimes.sort();
                            }
                          });
                        },
                      ),
                    ],
                  ),
                  const Divider(height: 0),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  // 타임 슬롯 취소 처리 로직
  void onTimeSlotCancel(String time, int toggleIndex) {
    setState(() {
      toggleStatuses[toggleIndex].times.remove(time);
      if (toggleStatuses[toggleIndex].times.isEmpty) {
        toggleStatuses[toggleIndex].status = -1;
      }
    });
  }

  // 개별 타임 슬롯 위젯
  Widget buildTimeSlot(String time, int toggleIndex) {
    return Container(
      height: 30,
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF59996B)),
        color: const Color(0xFFF0FFF4),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              textAlign: TextAlign.center,
              time,
              style: const TextStyle(color: Color(0xFF59996B)),
            ),
          ),
          IconButton(
            padding: const EdgeInsets.only(right: 0),
            icon: const Icon(Icons.cancel),
            color: const Color(0xFF59996B),
            onPressed: () {
              onTimeSlotCancel(time, toggleIndex);
            },
          ),
        ],
      ),
    );
  }

  // 타임 슬롯 위젯 동적 생성
  Widget buildTimeSlots() {
    List<Widget> timeSlots = [];
    for (int i = 0; i < toggleStatuses.length; i++) {
      if (toggleStatuses[i].status == 1) {
        // 선택된 토글에 대해서만 타임 슬롯 표시
        timeSlots.addAll(toggleStatuses[i].times.map((time) {
          return buildTimeSlot(time, i);
        }).toList());
      }
    }
    return Column(children: timeSlots);
  }

  //달력 생성, 선택시 textformfield에 적용
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        String date;
        _selectedDate = picked;
        date = DateFormat('yyyy-MM-dd').format(_selectedDate!);
        birth = date.replaceAll('-', '');
        // print(date);
        // print(birth);
        birthYear = int.parse(birth.substring(0, 4));
        birthDay = birth.substring(4, 8);
        _dateController.text = date;
      });
    }
  }

  List<String> _timePickerItems(String availableFrom, String availableTo) {
    List<String> timeList = [];
    String start = "${availableFrom.substring(0, 2)}:${availableFrom.substring(2)}";
    String end = "${availableTo.substring(0, 2)}:${availableTo.substring(2)}";

    DateFormat formatter = DateFormat("HH:mm");
    DateTime startTime = formatter.parse(start);
    DateTime endTime = formatter.parse(end);
    DateTime currentTime = startTime;

    while (currentTime.isBefore(endTime) || currentTime.isAtSameMomentAs(endTime)) {
      timeList.add(DateFormat("HH:mm").format(currentTime));
      currentTime = currentTime.add(const Duration(minutes: 30));
    }

    return timeList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("이름"),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                    ),
                    hintText: "이름을 입력해주세요.",
                    hintStyle: TextStyle(
                      fontSize: 16,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 8,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "이름을 입력하세요.";
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: 16),
                const Text("성별"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _selectedValue = true;
                        });
                      },
                      child: Row(
                        children: [
                          Radio<bool>(
                            value: true,
                            groupValue: _selectedValue,
                            onChanged: (value) {
                              setState(() {
                                _selectedValue = value!;
                                _selectedGenderText = '남';
                              });
                            },
                          ),
                          const Padding(
                            padding: EdgeInsets.only(
                              right: 8.0,
                            ),
                            child: Text("남"),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _selectedValue = false;
                        });
                      },
                      child: Row(
                        children: [
                          Radio<bool>(
                            value: false,
                            groupValue: _selectedValue,
                            onChanged: (value) {
                              setState(() {
                                _selectedValue = value!;
                                _selectedGenderText = '여';
                              });
                            },
                          ),
                          const Padding(
                            padding: EdgeInsets.only(
                              right: 0.0,
                            ),
                            child: Text("여"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Text("생년월일"),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: _dateController,
                      decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.calendar_month),
                        border: OutlineInputBorder(),
                        hintText: "YYYY-MM-DD",
                        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "생년월일을 선택해주세요.";
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text("핸드폰 번호"),
                const SizedBox(height: 8),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _phoneNumController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "-없이 입력하세요.",
                    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Phone을 입력하세요.";
                    } else {
                      if (!RegExp(r'^01[0-9]{8,9}$').hasMatch(value)) {
                        return "올바른 휴대폰 번호를 입력하세요.";
                      }
                      return null;
                    }
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text("요일 선택"),
                    const SizedBox(width: 4),
                    if (_isDaySelectedErrorVisible)
                      const Expanded(
                        child: Text(
                          "요일을 선택해 주세요.",
                          style: TextStyle(
                            color: Color(0xFFba1a1a),
                            fontFamily: 'Roboto',
                            fontSize: 12,
                            letterSpacing: 0.4,
                            leadingDistribution: TextLeadingDistribution.even,
                            inherit: false,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                  ],
                ),
                const SizedBox(height: 8),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // ...List.generate(
                        //   toggleStatuses.length,
                        //       (index) => Expanded(child: buildToggle(index)),
                        // ),
                        for (int i = 0; i < toggleStatuses.length; i++) ...[
                          Expanded(child: buildToggle(i)),
                          if (i != toggleStatuses.length - 1) const SizedBox(width: 4),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: const Color(0xFFC9C9C9),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                              height: 150,
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    buildTimeSlots(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Container(
                              width: 1,
                              height: 150,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                color: Color(0xFFC9C9C9),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: SizedBox(
                              height: 150,
                              child: ListView(
                                shrinkWrap: true,
                                children: [
                                  if (toggleStatuses.any((t) => t.status == 1)) buildTimePicker(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 2.0,
                        ),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0FFF4),
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: const Color(0xFF59996B),
                          ),
                        ),
                        child: const Text(
                          "전체 스케줄보기",
                          style: TextStyle(
                            color: Color(0xFF59996B),
                          ),
                        ),
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 2.0,
                        ),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0FFF4),
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: const Color(0xFF59996B),
                          ),
                        ),
                        child: const Text(
                          "출석 히스토리",
                          style: TextStyle(
                            color: Color(0xFF59996B),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (_modifyVisible)
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                              vertical: 8.0,
                            ),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color(0xFFDE6161),
                              borderRadius: BorderRadius.circular(4.0),
                              // border: Border.all(
                              //   color: const Color(0xFF59996B),
                              // ),
                            ),
                            child: const Text(
                              "비활성화",
                              style: TextStyle(
                                color: Color(0xFFFFFFFF),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          // print(mappedDays);
                          // print(toggleStatuses.toString());
                          // print(convertStatuses(toggleStatuses));
                          bool isFormValid = _formKey.currentState?.validate() ?? false;
                          bool isDaySelected = !toggleStatuses.every((status) => status.status == -1);
                          if (isFormValid && isDaySelected) {
                            await _addAttendee(context);
                            Navigator.pop(context, true);
                          } else {
                            print("폼 비정상임");
                            setState(() {
                              _isDaySelectedErrorVisible = !isDaySelected;
                            });
                            showToast("입력하지 않은 값이 있습니다.");
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 8.0,
                          ),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xFF59996B),
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                              color: const Color(0xFF59996B),
                            ),
                          ),
                          child: const Text(
                            "저장",
                            style: TextStyle(
                              color: Color(0xFFFFFFFF),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ToggleStatus {
  int status; // -1: 기본, 0: 선택 데이터 있음, 1: 선택 중
  int day;
  List<String> times;

  ToggleStatus({this.status = -1, this.day = -1, List<String>? times}) : times = times ?? [];

  void clearTimes() => times.clear();

  void addTime(String time) => times.add(time);

  void removeTime(String time) => times.remove(time);

  @override
  String toString() {
    return 'status: $status, day: $day, times: $times';
  }
}
