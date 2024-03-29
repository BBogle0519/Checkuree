import 'package:checkuuree/model/attendance_list_response.dart';
import 'package:checkuuree/view_model/attendance_list_view_model.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _formKey = GlobalKey<FormState>();
  final AttendanceListViewModel _viewModel = AttendanceListViewModel();
  late List<Items> data = [];
  bool _showBottomSheet = true;

  @override
  void initState() {
    super.initState();
    _loadAttendanceList();
  }

  Future<void> _loadAttendanceList() async {
    bool success = await _attendanceListGet(context);
    if (success) {
      setState(() {});
    }
  }

  Future<bool> _attendanceListGet(BuildContext context) async {
    AttendanceListResponse response = await _viewModel.attendanceListGet();
    if (response.success) {
      data = response.items!;
    }
    return response.success;
  }

  Future<bool> test() async {
    AttendanceListResponse response = await _viewModel.attendanceListGet();
    if (response.success) {
      data = response.items!;
    }
    return response.success;
  }

  @override
  Widget build(BuildContext context) {
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
                    const Text(
                      "학원 이름",
                      style: TextStyle(fontSize: 20),
                    ),
                    Expanded(
                      child: data.isNotEmpty
                          ? ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                                'title $index, ${data[index].attendance
                                    .title}'),
                            subtitle: Text(
                                'description $index, ${data[index].attendance
                                    .description}'),
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
                builder: (context) =>
                    Container(
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
                              onPressed: () {
                                test();
                              },
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
