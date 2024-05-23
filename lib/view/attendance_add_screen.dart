import 'package:checkuuree/model/attendance_add_response.dart';
import 'package:checkuuree/utils/show_toast.dart';
import 'package:checkuuree/view_model/attendance_add_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AttendanceAddScreen extends StatefulWidget {
  const AttendanceAddScreen({super.key});

  @override
  State<AttendanceAddScreen> createState() => _AttendanceAddScreenState();
}

class _AttendanceAddScreenState extends State<AttendanceAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final AttendanceAddViewModel _viewModel = AttendanceAddViewModel();
  final TextEditingController _nameController = TextEditingController();
  final List<bool> _isSelected = List.generate(7, (_) => false);
  String? _startDropSelectedValue;
  String? _endDropSelectedValue;
  bool _selectedValue = true;
  bool _isDaySelectedErrorVisible = false;
  List<String> daysOfWeek = ['월', '화', '수', '목', '금', '토', '일'];
  Map<String, String> dayMappings = {
    '월': 'MONDAY',
    '화': 'TUESDAY',
    '수': 'WEDNESDAY',
    '목': 'THURSDAY',
    '금': 'FRIDAY',
    '토': 'SATURDAY',
    '일': 'SUNDAY'
  };

  List<DropdownMenuItem<String>> _getEndDropdownItems() {
    if (_startDropSelectedValue == null) {
      // 첫 번째 드롭다운에서 시간이 선택되지 않았으면, 모든 시간을 포함하는 리스트 반환
      return List.generate(25, (index) => '${index.toString().padLeft(2, '0')}:00').map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList();
    } else {
      // 첫 번째 드롭다운에서 선택된 시간의 다음 시간부터 리스트 반환
      int startHour = int.parse(_startDropSelectedValue!.split(':')[0]);
      return List.generate(24 - startHour, (index) => '${(startHour + index + 1).toString().padLeft(2, '0')}:00')
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList();
    }
  }

  List<String> getSelectedDays() {
    List<String> selectedDays = [];
    for (int i = 0; i < _isSelected.length; i++) {
      if (_isSelected[i]) {
        String dayInEnglish = dayMappings[daysOfWeek[i]]!;
        selectedDays.add(dayInEnglish);
      }
    }
    return selectedDays;
  }

  Future<bool> _addAttendance(BuildContext context) async {
    String title = _nameController.text;
    String description = "설명 입력란이 아직은 없어요";
    String availableFrom = _startDropSelectedValue!.replaceAll(":", "");
    String availableTo = _endDropSelectedValue!.replaceAll(":", "");
    bool allowLateness = _selectedValue;
    List<String> attendanceDays = getSelectedDays();
    AttendanceAddResponse response = await _viewModel.attendanceAddPost(
      title,
      description,
      availableFrom,
      availableTo,
      allowLateness,
      attendanceDays,
    );

    return response.success;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "정보 입력",
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 24),
                      const Text("출석부 이미지"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 92,
                            height: 92,
                            color: Colors.black,
                            margin: const EdgeInsets.only(
                              top: 8.0,
                              bottom: 4.0,
                              right: 4.0,
                            ),
                          ),
                          const Text(
                            "jpg, png 형식만 지원합니다.",
                            style: TextStyle(
                              color: Color(0xFFc9c9c9),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text("출석부 이름"),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                          ),
                          hintText: "출석부 이름을 입력해주세요.",
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
                            return "출석부 이름을 입력하세요.";
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(height: 8),
                      const Text("출석부 지각 사용 여부"),
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
                                    });
                                  },
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(
                                    right: 8.0,
                                  ),
                                  child: Text("사용함"),
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
                                    });
                                  },
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(
                                    right: 0.0,
                                  ),
                                  child: Text("사용하지 않음"),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List.generate(
                          7,
                          (index) {
                            return Flexible(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _isSelected[index] = !_isSelected[index];
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0,
                                      vertical: 8.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _isSelected[index] ? Colors.green : Colors.transparent,
                                      borderRadius: BorderRadius.circular(8.0),
                                      border: Border.all(
                                        color: _isSelected[index] ? Colors.green : Colors.grey,
                                      ),
                                    ),
                                    child: Text(
                                      daysOfWeek[index],
                                      style: TextStyle(
                                        color: _isSelected[index] ? Colors.white : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text("시간 선택"),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButtonFormField<String>(
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return "시작 시간을 선택해주세요.";
                                  } else {
                                    return null;
                                  }
                                },
                                value: _startDropSelectedValue,
                                borderRadius: BorderRadius.circular(8.0),
                                isExpanded: true,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0xFFD5D5D5)),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0xFFD5D5D5)),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                hint: const Text(
                                  '시작 시간 선택',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFFD5D5D5),
                                  ),
                                ),
                                items: <String>[
                                  '00:00',
                                  '01:00',
                                  '02:00',
                                  '03:00',
                                  '04:00',
                                  '05:00',
                                  '06:00',
                                  '07:00',
                                  '08:00',
                                  '09:00',
                                  '10:00',
                                  '11:00',
                                  '12:00',
                                  '13:00',
                                  '14:00',
                                  '15:00',
                                  '16:00',
                                  '17:00',
                                  '18:00',
                                  '19:00',
                                  '20:00',
                                  '21:00',
                                  '22:00',
                                  '23:00',
                                ].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _startDropSelectedValue = newValue;
                                    _endDropSelectedValue = null;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Flexible(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButtonFormField<String>(
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return "종료 시간을 선택해주세요.";
                                  } else {
                                    return null;
                                  }
                                },
                                value: _endDropSelectedValue,
                                borderRadius: BorderRadius.circular(8.0),
                                isExpanded: true,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0xFFD5D5D5)),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0xFFD5D5D5)),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                hint: const Text(
                                  '종료 시간 선택',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFFD5D5D5),
                                  ),
                                ),
                                items: _getEndDropdownItems(),
                                onChanged: _startDropSelectedValue != null
                                    ? (newValue) {
                                        setState(() {
                                          _endDropSelectedValue = newValue;
                                        });
                                      }
                                    : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC9C9C9),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        padding: const EdgeInsets.all(12), // 내부 패딩
                      ),
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: const Text("취소"),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF59996B),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        padding: const EdgeInsets.all(12), // 내부 패딩
                      ),
                      onPressed: () async {
                        bool isFormValid = _formKey.currentState?.validate() ?? false;
                        bool isDaySelected = !_isSelected.every((element) => !element);

                        if (isFormValid && isDaySelected) {
                          await _addAttendance(context);
                          Navigator.pop(context, true);
                        } else {
                          // print("폼 비정상임");
                          setState(() {
                            _isDaySelectedErrorVisible = !isDaySelected;
                          });
                          showToast("입력하지 않은 값이 있습니다.");
                        }
                      },
                      child: const Text("저장"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
