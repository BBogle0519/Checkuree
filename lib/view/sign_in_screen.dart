import 'package:checkuuree/model/sign_in_response.dart';
import 'package:checkuuree/view/main_screen.dart';
import 'package:checkuuree/view/sign_up_screen.dart';
import 'package:checkuuree/view_model/sign_in_view_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  void showToast() {
    Fluttertoast.showToast(
        msg: "ID 또는 PW가 정확하지 않습니다.",
        //메세지입력
        toastLength: Toast.LENGTH_SHORT,
        //메세지를 보여주는 시간(길이)
        gravity: ToastGravity.CENTER,
        //위치지정
        timeInSecForIosWeb: 1,
        //ios및 웹용 시간
        backgroundColor: Colors.black,
        //배경색
        textColor: Colors.white,
        //글자색
        fontSize: 16.0 //폰트 사이즈
        );
  }

  // 토큰 저장
  Future<void> saveData() async {
    // print("access: $accessToken");
    // print("refresh: $refreshToken");
    _prefs.setString('accessToken', accessToken);
    _prefs.setString('refreshToken', refreshToken);
  }

  // 토큰 로드
  // Future<void> loadData() async {
  //   final accessToken = _prefs.getString('accessToken');
  //   print("accessToken load ::::: $accessToken");
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkuree 로그인"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
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
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      // print("로그인 누름");
                      if (_formKey.currentState?.validate() ?? false) {
                        bool loginStatus = await _login(context);
                        if (loginStatus) {
                          // Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MainScreen(),
                            ),
                          );
                        } else {
                          showToast();
                        }
                      } else {
                        // print("폼 비정상임");
                        showToast();
                      }
                    },
                    child: const Text("로그인"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpScreen(),
                        ),
                      );
                    },
                    child: const Text("회원가입"),
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
