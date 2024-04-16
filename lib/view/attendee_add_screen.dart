import 'package:flutter/material.dart';

class AttendeeAddScreen extends StatefulWidget {
  //이전 화면에서 전달받은 데이터
  final String attendanceId;
  //출석부 요일도 받을 예정

  const AttendeeAddScreen({super.key, required this.attendanceId});

  @override
  State<AttendeeAddScreen> createState() => _AttendeeAddScreenState();
}

class _AttendeeAddScreenState extends State<AttendeeAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _phoneNumController = TextEditingController();
  bool _selectedValue = true;

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
                const SizedBox(height: 8),
                const Text("생년월일"),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _dateController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                    ),
                    hintText: "YYYY/MM/DD",
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
                      return "날짜를 입력하세요.";
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: 16),
                const Text("핸드폰 번호"),
                const SizedBox(height: 8),
                TextFormField(
                  keyboardType: TextInputType.number,
                  // inputFormatters: <TextInputFormatter>[
                  //   FilteringTextInputFormatter.allow(RegExp(r'^01[0-9]{8,9}$')),
                  // ],
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
