import 'package:checkuuree/model/attendance_check_response.dart'
    as check_response;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../view_model/attendance_check_view_model.dart';

class AttendanceCheckScreen extends StatefulWidget {
  //이전 화면에서 전달받은 데이터
  final String attendanceId;

  const AttendanceCheckScreen({super.key, required this.attendanceId});

  @override
  State<AttendanceCheckScreen> createState() => _AttendanceCheckScreenState();
}

class _AttendanceCheckScreenState extends State<AttendanceCheckScreen> {
  final _formKey = GlobalKey<FormState>();
  final AttendanceCheckViewModel _viewModel = AttendanceCheckViewModel();
  late List<check_response.Items> data = [];
  bool _showBottomSheet = true;
  DateTime currentDate = DateTime.now();
  final daysInMonth = DateUtils.getDaysInMonth;

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
    check_response.AttendanceCheckResponse response =
        await _viewModel.attendeesListGet(widget.attendanceId);
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
      appBar: AppBar(
        title: const Text("출석부 목록(메인)"),
      ),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Expanded(
                          child: Text(
                            "출석부 이름",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 2.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(2.0),
                                    ),
                                    child: Text(
                                      currentDate.month
                                          .toString()
                                          .padLeft(2, '0'),
                                    ),
                                  ),
                                  const SizedBox(width: 2),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 2.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(2.0),
                                    ),
                                    child: Text(
                                      currentDate.day
                                          .toString()
                                          .padLeft(2, '0'),
                                    ),
                                  ),
                                  const SizedBox(width: 2),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 2.0),
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
                    Expanded(
                      child: data.isNotEmpty
                          ? ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title:
                                      Text('name $index : ${data[index].name}'),
                                  subtitle:
                                      Text('age $index : ${data[index].age}'),
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
            Positioned(
              left: 0,
              right: 0,
              bottom: 30,
              child: _showBottomSheet
                  ? BottomSheet(
                      onClosing: () {}, // 필요에 따라 구현
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
                              IconButton(
                                icon: const Icon(
                                  Icons.home,
                                  color: Colors.white,
                                ),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.search,
                                  color: Colors.white,
                                ),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
