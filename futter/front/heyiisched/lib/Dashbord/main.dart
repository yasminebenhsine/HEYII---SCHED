import 'package:flutter/material.dart';
import 'package:heyiisched/Dashbord/calendrier_enseignant/enseignant_list_page.dart';
import 'package:heyiisched/Dashbord/calendrier_enseignant/view_calendrier_enseignant.dart';
import 'package:heyiisched/Dashbord/calendrier_salles/SallesPage%20.dart';
import 'package:heyiisched/Dashbord/calendrier_salles/view_liste.salles.dart';
import 'package:heyiisched/Dashbord/details/GroupClassesView.dart';
import 'package:heyiisched/Dashbord/details/GrpClassListPage.dart';
//import 'package:heyiisched/Dashbord/details/GrpClassListPage.dart';
import 'package:heyiisched/Dashbord/details/SpecialiteListPage.dart';
import 'package:heyiisched/Dashbord/calendrier_etudiants/view_liste_etudiants.dart';
//import 'package:heyiisched/Dashbord/calendrier_salles/SallesPage%20.dart';
//import 'package:heyiisched/Dashbord/calendrier_salles/view_liste.salles.dart';
import 'package:heyiisched/Dashbord/details/MatiereListPage.dart';
import 'package:heyiisched/Dashbord/details/VoeuxListPage.dart';
//import 'package:heyiisched/Dashbord/details/test.dart';
//import 'package:heyiisched/Dashbord/details/test.dart';
import 'package:heyiisched/Dashbord/main__admin_dash.dart';
import 'package:heyiisched/authuser/login.dart';
import 'package:heyiisched/authuser/update_admin_etud/updateProfile.dart';
//import 'package:heyiisched/authuser/updateProfile.dart';

void main() {
  runApp(AdminMain());
}

class AdminMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HEYII SCHED Admin Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      // Le Dashboard est défini comme la page principale
      initialRoute: '/admin/dashboard',
      routes: {
        '/admin/dashboard': (context) => AdminDashboard(),
        '/Enseignants': (context) => CalendrierEnseignantPage(),
        '/etudiant/retrieve-all-etudiants': (context) => EtudiantPage(),
        '/salles/retrieve-all-salles': (context) => SallePage(),
        '/enseignants/retrieve-all-enseignants': (context) =>
            EnseignantListPage(),
        '/Specialite': (context) => SpecialiteListPage(),
        '/planification_salles': (context) => SallesPage(),
        '/Matieres': (context) => MatiereListPage(),
        '/voeuxProf': (context) => VoeuxListPage(),

        //'/Lesclasses':(context) => GrpClassListPage(),
        '/login': (context) => HomePage(),
        //'/classe':(context) => GroupClassesView(),
        '/classe': (context) => GrpClassListScreen(),
        //'/Edit':(context) => EditProfileDialog(),
        '/Edit': (context) => EditProfileDialog(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
