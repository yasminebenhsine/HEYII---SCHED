import 'package:flutter/material.dart';
import 'package:heyiisched/Prof/MatiereListPage.dart';
import 'package:heyiisched/Prof/TimetablePage.dart';

//import 'package:heyiisched/Prof/TimetablePage.dart';

import 'package:heyiisched/Prof/View/AddVoeuxPage.dart';
import 'package:heyiisched/Prof/View/ReclamationView.dart';
import 'package:heyiisched/Prof/test1.dart';

import 'package:heyiisched/authuser/login.dart';

import 'widget_prof.dart';
// Import the new timetable screen

void main() {
  runApp(const MyAppProf());
}

class MyAppProf extends StatelessWidget {
  const MyAppProf({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Prof Interface',
      theme: ThemeData(primarySwatch: Colors.indigo),
      initialRoute: '/profi', // The initial route should be '/prof'
      routes: {
        '/profi': (context) => MyHomePage(), 
        //'/timetable': (context) => MomEmploiPage(),
        '/timetable': (context) => EmploisPage(),
        
        '/add_voeux': (context) => AddVoeuxPage(),
        '/reclamation': (context) => AddReclamationPage(),
        '/matiere': (context) => MatiereListPageRoute(),
        '/login': (context) => HomePage(), // Login route
      },
    );
  }
}

/*
Future<String> getEnseignantId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String enseignantId = prefs.getString('enseignantId') ?? '';  // Fallback to empty string if not found
    print("Fetched enseignantId: $enseignantId");
    return enseignantId;
  }
  */
/*
class CoursRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: MyAppProf().getEnseignantId(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: Text('Loading')),
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: Text('Error')),
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: Text('Error')),
            body: Center(child: Text('No teacher ID found. Please log in or select a teacher.')),
          );
        } else {
          // Once the enseignantId is fetched, pass it to CoursScreen
          return GrpClassListScreen(enseignantId: snapshot.data!);
        }
      },
    );
  }*/

