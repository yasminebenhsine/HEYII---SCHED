import 'package:flutter/material.dart';
import 'package:heyiisched/authuser/main.dart';
import 'package:heyiisched/authuser/splash_screen.dart';
// Your login page

void main() {
  runApp(const MyAppScreen());
}

class MyAppScreen extends StatelessWidget {
  const MyAppScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(
        nextScreen: MyApp(), // Your login page widget
      ),
    );
  }
}
