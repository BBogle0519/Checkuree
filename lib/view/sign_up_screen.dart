import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../model/sign_up_response.dart';
import '../view_model/sign_up_view_model.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumController = TextEditingController();
  final SignUpViewModel _viewModel = SignUpViewModel();

  DateTime? _selectedDate;
  late String birth;
  late int birthYear;
  late String birthDay;

  bool isPassWordValid(String input) {
    // 영문, 숫자, 특수 기호 중 하나 이상이 포함되었는지 확인하는 정규표현식
    RegExp regex = RegExp(r'(?=.*[a-zA-Z])(?=.*\d)(?=.*[@#$%^&+=!]).*$');
    return regex.hasMatch(input);
  }

  bool isEmailValid(String email) {
    // 이메일 형식의 정규 표현식
    final RegExp emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  void _signUp(BuildContext context) async {
    String name = _nameController.text;
    String id = _idController.text;
    String pw = _pwController.text;
    String email = _emailController.text;
    String phoneNum = _phoneNumController.text;

    // print(
    //   "name: $name, id: $id, pw: $pw, email: $email, phone: $phoneNum, birth: $birth",
    // );
    SignUpResponse response = await _viewModel.signUpPost(
      id,
      pw,
      name,
      phoneNum,
      birthYear,
      birthDay,
      email,
    );
    print("response :::: $response");
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
        _dateController.text = date; // 선택한 날짜를 TextFormField에 표시
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("회원가입"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      "이름:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      flex: 10,
                      child: TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "이름",
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "이름을 입력하세요.";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      "ID:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: TextFormField(
                        controller: _idController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "ID",
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "ID를 입력하세요.";
                          } else {
                            if (value.length <= 5) {
                              return "ID는 최소 6글자 이상입니다.";
                            }
                            return null;
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      "PW:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: TextFormField(
                        controller: _pwController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "PW",
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "PW를 입력하세요.";
                          } else {
                            if (value.length <= 5 || value.length >= 13) {
                              return "PW는 최소 6글자 이상 12글자 이하입니다.";
                            } else if (!isPassWordValid(value)) {
                              return "PW는 하나 이상의 영문, 숫자, 특수문자를 포함해야 합니다.";
                            }
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      "Email:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Email",
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Email을 입력하세요.";
                          } else {
                            if (!isEmailValid(value)) {
                              return "올바르지 않은 Email입니다.";
                            }
                            return null;
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      "Phone:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        // inputFormatters: <TextInputFormatter>[
                        //   FilteringTextInputFormatter.allow(RegExp(r'^01[0-9]{8,9}$')),
                        // ],
                        controller: _phoneNumController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "-없이 입력하세요.",
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 12, horizontal: 8),
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
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      "birth:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: GestureDetector(
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
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 8),
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
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          _signUp(context);
                        } else {
                          print("폼 비정상임");
                        }
                      },
                      child: const Text("확인"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("취소"),
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
