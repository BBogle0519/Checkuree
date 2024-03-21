import 'package:checkuuree/model/sign_in_response.dart';
import 'package:checkuuree/view/sign_up_screen.dart';
import 'package:checkuuree/view_model/sign_in_view_model.dart';
import 'package:flutter/material.dart';
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
  late String token;

  void _login(BuildContext context) async {
    _prefs = await SharedPreferences.getInstance();
    String id = _idController.text;
    String pw = _pwController.text;

    // print("id: $id, pw: $pw");
    SignInResponse response = await _viewModel.signInPost(id, pw);
    // print("response :::: $response");
    token = response.data.accessToken;
    saveData();
  }

  // 토큰 저장
  Future<void> saveData() async {
    _prefs.setString('accessToken', token);
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
                if (value == null || value.isEmpty) {
                  return "ID를 입력하세요.";
                }
                return null;
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
                if (value == null || value.isEmpty) {
                  return "PW를 입력하세요.";
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    print("로그인 누름");
                    _login(context);
                    if (_formKey.currentState?.validate() ?? false) {
                      // _login(context);
                      print("폼 정상작성댐");
                    } else {
                      print("폼 비정상임");
                    }
                  },
                  child: const Text("로그인"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const signUpScreen(),
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
    );
  }
}
