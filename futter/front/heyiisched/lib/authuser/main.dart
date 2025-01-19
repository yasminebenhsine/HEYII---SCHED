import 'package:flutter/material.dart';
import 'package:heyiisched/Dashbord/main.dart';

import 'package:heyiisched/Prof/mainProf.dart';
import 'package:heyiisched/authuser/login.dart';

import 'package:heyiisched/etudiant/main.dart';

import 'package:shared_preferences/shared_preferences.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HEYII SCHED',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: FutureBuilder<String>(
        future: _getUserRole(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          String role = snapshot.data ?? '';
          if (role == 'admin') {
            return AdminMain();
          } else if (role == 'enseignant') {
            return MyAppProf();
          } else if (role == 'etudiant') {
            return MyAppEtudiant();
          } else {
            return HomePage(); // Default to HomePage if no role is found
          }
        },
      ),
      initialRoute: '/login',
      routes: {
       
        '/login': (context) => HomePage(),
        '/admin/dashboard': (context) => AdminMain(),
        '/profi': (context) => MyAppProf(),
        '/student': (context) => MyAppEtudiant(),
        
      },
    );
  }

  Future<String> _getUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('role') ?? '';
  }
}