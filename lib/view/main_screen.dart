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
      data = response.items;
    }
    return response.success;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("출석부 목록(메인)"),
      ),
      body: Padding(
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
                            title: Text('Data ${index + 1}'),
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
    );
  }
}
