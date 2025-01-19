import 'package:flutter/material.dart';
import 'package:heyiisched/authuser/login.dart';

import 'package:heyiisched/etudiant/Dashbord.dart';
import 'package:heyiisched/etudiant/Schedule.dart';

 // Make sure this imports your SchedulePage

void main() {
  runApp(MyAppEtudiant());
}

class MyAppEtudiant extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Heyii Sched',
      theme: ThemeData(
        primaryColor: Color(0xFF9F8DC3),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/student',
      // Define the routes here
      routes: {
        '/student': (context) => DashboardPage(),
        '/emploi': (context) => StudentTimetable(), 
        '/login': (context) => HomePage(),// Route to timetable
       
      },
    );
  }
}
/*import 'package:flutter/material.dart';

import 'package:heyiisched/etudiant/Dashbord.dart';
import 'package:heyiisched/etudiant/Schedule.dart'; // Make sure this imports your SchedulePage

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Heyii Sched',
      theme: ThemeData(
        primaryColor: Color(0xFF9F8DC3),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Define the routes here
      routes: {
        '/': (context) => DashboardPage(),
        '/emploi': (context) => SchedulePage(), // Route to timetable
      },
    );
  }
}

*/