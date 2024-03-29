import 'package:checkuuree/service/api_service.dart';
import 'package:checkuuree/view/sign_in_screen.dart';
import 'package:flutter/material.dart';

void main() {
  ApiService.onTokenRefreshFailed = () {
    MyApp._navigatorKey.currentState?.pushReplacement(
      MaterialPageRoute(
        builder: (context) => const SignInScreen(),
      ),
    );
  };
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final GlobalKey<NavigatorState> _navigatorKey =
      GlobalKey<NavigatorState>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SignInScreen(),
    );
  }
}
