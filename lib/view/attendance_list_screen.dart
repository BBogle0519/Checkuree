import 'package:checkuuree/model/attendance_list_response.dart';
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
  List<Items> data = [];
  final DateTime now = DateTime.now();
  late final String formattedDate;
  late final String date;

  // print($date);
  // print("요일: $formattedDate");

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
        title: const Text("출석부 목록"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 4.0,
                          mainAxisSpacing: 4.0,
                        ),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {

                            },
                            child: Card(
                              clipBehavior: Clip.antiAlias, // 둥근 모서리 적용을 위함
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Image.network(
                                      '이미지 URL',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  ListTile(
                                    title: Text(
                                        '$index, ${data[index].attendance.title}'),
                                    subtitle: Text(
                                        '$index, ${data[index].attendance.description}'),
                                  ),
                                ],
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
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => addAttendanceScreen()),
          // );
        },
        backgroundColor: const Color(0xFF054302),
        child: const Icon(Icons.add),
      ),
    );
  }
}
