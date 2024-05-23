import 'package:checkuuree/model/sign_in_response.dart';
import 'package:checkuuree/view/attendance_list_screen.dart';
import 'package:checkuuree/view/sign_up_screen.dart';
import 'package:checkuuree/view_model/sign_in_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/show_toast.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final SignInViewModel _viewModel = SignInViewModel();
  late SharedPreferences _prefs;
  late String accessToken;
  late String refreshToken;

  Future<bool> _login(BuildContext context) async {
    _prefs = await SharedPreferences.getInstance();
    String id = _idController.text;
    String pw = _pwController.text;

    // print("id: $id, pw: $pw");
    SignInResponse response = await _viewModel.signInPost(
      id,
      pw,
    );
    // print("test:: ${response.success}")
    if (response.success) {
      accessToken = response.data!.accessToken!;
      refreshToken = response.data!.refreshToken!;

      saveData();
    }
    return response.success;
  }

  // 토큰 저장
  Future<void> saveData() async {
    // print("access: $accessToken");
    // print("refresh: $refreshToken");
    _prefs.setString('accessToken', accessToken);
    _prefs.setString('refreshToken', refreshToken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 150),
                const Text(
                  "로그인",
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _idController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "ID",
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
                const SizedBox(height: 8),
                TextFormField(
                  controller: _pwController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "PW",
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "PW를 입력하세요.";
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF59996B),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(12), // 내부 패딩
                        ),
                        onPressed: () async {
                          // print("로그인 누름");
                          if (_formKey.currentState?.validate() ?? false) {
                            bool loginStatus = await _login(context);
                            if (loginStatus) {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AttendanceListScreen(),
                                ),
                              );
                            } else {
                              showToast("ID 또는 PW가 정확하지 않습니다.");
                            }
                          } else {
                            // print("폼 비정상임");
                            showToast("ID 또는 PW가 정확하지 않습니다.");
                          }
                        },
                        child: const Text(
                          "로그인 하기",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpScreen(),
                          ),
                        );
                      },
                      child: const Text("회원가입"),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpScreen(),
                          ),
                        );
                      },
                      child: const Text("아이디/비밀번호 찾기"),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow,
                          foregroundColor: Colors.black,
                        ),
                        onPressed: () async {
                          // print("카카오로그인 누름");
                        },
                        child: const Text(
                          "카카오 로그인",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00BF19),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {},
                        child: const Text(
                          "네이버 로그인",
                          style: TextStyle(fontWeight: FontWeight.bold),
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
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/icons/checkuree_letter_logo.svg',
            width: 200,
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
