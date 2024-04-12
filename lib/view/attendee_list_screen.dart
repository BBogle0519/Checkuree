import 'package:flutter/material.dart';

class AttendeeListScreen extends StatefulWidget {
  const AttendeeListScreen({super.key});

  @override
  State<AttendeeListScreen> createState() => _AttendeeListScreenState();
}

class _AttendeeListScreenState extends State<AttendeeListScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _showBottomSheet = true;

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
                    onPressed: () {},
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
                    onPressed: () {},
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
                      child: true
                          // data.isNotEmpty
                          ? GridView.builder(
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                childAspectRatio: 5.5,
                                crossAxisSpacing: 4.0,
                                mainAxisSpacing: 1.0,

                              ),
                              itemCount: 1,
                              // data.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) => AttendanceCheckScreen(attendanceId: data[index].attendanceId),
                                    //   ),
                                    // );
                                  },
                                  child: Flexible(
                                    flex: 1,
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
                                        child: const Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "이름",
                                              // data[index].attendance.title,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    "요일",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Color(0xFF797979),
                                                    ),
                                                  ),
                                                ),
                                                Icon(Icons.mood),
                                                // Text("$presentCount"),
                                                Icon(Icons.access_time),
                                                // Text("$tardyCount"),
                                                Icon(Icons.cancel_outlined),
                                                // Text("$absentCount"),
                                              ],
                                            )
                                          ],
                                        ),
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
            buildBottomSheet(context),
          ],
        ),
      ),
    );
  }
}
