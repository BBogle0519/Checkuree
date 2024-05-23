import 'package:checkuuree/view/sign_in_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future loadData() async {
    // 시뮬레이션을 위해 3초간 대기
    await Future.delayed(const Duration(seconds: 2));
    // 로딩이 끝난 후 메인 화면으로 이동
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SignInScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Image.asset(
          'assets/icons/checkuree_splash.png',
          fit: BoxFit.fitWidth,
        ), // 이미지 사용
      ),
    );
  }
}
