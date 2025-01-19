import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:heyiisched/Dashbord/calendrier_enseignant/view_calendrier_enseignant.dart';
import 'package:heyiisched/Dashbord/widget_admin_dash.dart';
import 'package:heyiisched/services/AuthService_y.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int selectedIndex = 0;

  String getCurrentDate() {
    return DateFormat('EEEE, d MMMM yyyy').format(DateTime.now());
  }

  void _logoutUser() async {
    try {
      final authService = AuthService();
      await authService.logout();
      print("Logged out successfully.");
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      print("Error during logout: $e");
    }
  }

  final List<String> menuOptions = [
    'Dashboard',
    'Calendrier enseignant',
    'Liste enseignants',
    'Planification des salles',
    'Gestion des matières',
    'Classes',
    'Voeux Prof',
    'Specialite',
    'Modifier Profil',
    'Déconnexion',
  ];

  Widget getSelectedContent() {
    switch (selectedIndex) {
      case 0:
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DashboardStats(),
                SizedBox(height: 5),
              ],
            ),
          ),
        );
      case 1:
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushNamed(context, '/Enseignants');
        });
        return Container();
      case 2:
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushNamed(context, '/enseignants/retrieve-all-enseignants');
        });
        return Container();
      case 3:
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushNamed(context, '/planification_salles');
        });
        return Container();
      case 4:
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushNamed(context, '/Matieres');
        });
        return Container();
      case 5:
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushNamed(context, '/classe');
        });
        return Container();
      case 6:
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushNamed(context, '/voeuxProf');
        });
        return Container();
      case 7:
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushNamed(context, '/Specialite');
        });
        return Container();
      case 8:
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushNamed(context, '/Edit');
        });
        return Container();
      case 9:
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _logoutUser();
        });
        return Container();
      default:
        return Center(child: Text('Sélectionnez une option.'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Row(
          children: [
            NavigationRailTheme(
              data: NavigationRailThemeData(
                backgroundColor: Color(0xFF5C5792),
                selectedIconTheme:
                    const IconThemeData(color: Colors.white, size: 20),
                unselectedIconTheme:
                    const IconThemeData(color: Colors.white70, size: 18),
                selectedLabelTextStyle:
                    const TextStyle(fontSize: 10, color: Colors.white),
                unselectedLabelTextStyle:
                    const TextStyle(fontSize: 8, color: Colors.white70),
              ),
              child: NavigationRail(
                minWidth: 20, // Largeur minimale du rail
                selectedIndex: selectedIndex,
                onDestinationSelected: (int index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                labelType: NavigationRailLabelType.all,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.dashboard),
                    label: Text('Dashboard'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.calendar_today),
                    label: Text('Calendrier'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.people),
                    label: Text('Enseignants'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.meeting_room),
                    label: Text('Salles'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.book),
                    label: Text('Matières'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.school),
                    label: Text('Classes'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.meeting_room),
                    label: Text('Voeux'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.school),
                    label: Text('Specialite'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.edit),
                    label: Text('Modifier Profil'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.logout),
                    label: Text('Déconnexion'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.grey[100],
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundImage:
                                    AssetImage('assets/images/user.JPG'),
                              ),
                              SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Bienvenue, Admin',
                                    style: TextStyle(
                                      color: Color(0xFF5C5792),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Dashboard',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: TextField(
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                  hintText: 'Rechercher...',
                                  prefixIcon: Icon(Icons.search),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Stack(
                            children: [
                              IconButton(
                                icon: Icon(Icons.notifications_none),
                                onPressed: () {},
                                color: Color(0xFF5C5792),
                              ),
                              Positioned(
                                right: 5,
                                top: 5,
                                child: Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    '3',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 8,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(child: getSelectedContent()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardStats extends StatefulWidget {
  @override
  _DashboardStatsState createState() => _DashboardStatsState();
}

class _DashboardStatsState extends State<DashboardStats> {
  late Future<List<int>> totalStats;

  @override
  void initState() {
    super.initState();
    ApiService apiService =
        ApiService('http://192.168.56.1:8084'); // Remplacez par votre URL
    totalStats = Future.wait([
      apiService.getTotalEnseignants(),
      apiService.getTotalEtudiants(),
      apiService.getTotalMatieres(),
      apiService.getTotalGrpClasses(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<int>>(
      future: totalStats,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          int totalEnseignantsCount = snapshot.data![0];
          int totalEtudiantsCount = snapshot.data![1];
          int totalMatieresCount = snapshot.data![2];
          int totalGrpClassesCount = snapshot.data![3];

          return GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: [
              StatCard(
                  title: 'Total Enseignants',
                  value: totalEnseignantsCount.toString(),
                  icon: Icons.people,
                  color: Color(0xFF5C5792)),
              StatCard(
                title: 'Total Etudiants',
                value: totalEtudiantsCount.toString(),
                icon: Icons.school,
                color: Color(0xFF7E6DB3),
              ),
              StatCard(
                title: 'Total Matières',
                value: totalMatieresCount.toString(),
                icon: Icons.book,
                color: Color(0xFF9F8DC3),
              ),
              StatCard(
                title: 'Total Classes',
                value: totalGrpClassesCount
                    .toString(), // Afficher le nombre de groupes de classes
                icon: Icons.group,
                color: Color(0xFF8F7FB1),
              ),
            ],
          );
        } else {
          return Center(child: Text('Aucune donnée disponible.'));
        }
      },
    );
  }
}
/*
class DashboardStats extends StatefulWidget {
  @override
  _DashboardStatsState createState() => _DashboardStatsState();
}
class _DashboardStatsState extends State<DashboardStats> {
  late Future<List<int>> totalStats;  // Remplacer par Future<List<int>>

  @override
  void initState() {
    super.initState();
    ApiService apiService = ApiService('http://192.168.56.1:8084'); // Remplacez par votre URL de backend
    totalStats = Future.wait([
      apiService.getTotalEnseignants(),
      apiService.getTotalEtudiants(),
      apiService.getTotalMatieres(),
      apiService.getTotalGrpClasses(), // Ajouter cette ligne pour récupérer les groupes de classes
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<int>>(
      future: totalStats,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          int totalEnseignantsCount = snapshot.data![0]; // Premier élément = totalEnseignants
          int totalEtudiantsCount = snapshot.data![1];   // Deuxième élément = totalEtudiants
          int totalMatieresCount = snapshot.data![2];     // Troisième élément = totalMatieres
          int totalGrpClassesCount = snapshot.data![3];   // Quatrième élément = totalGrpClasses

          return GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2, // Ajustez selon la taille de l'écran
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: [
              StatCard(
                title: 'Total Enseignants',
                value: totalEnseignantsCount.toString(),
                icon: Icons.people,
                color: Color(0xFF5C5792),
              ),
              StatCard(
                title: 'Total Etudiants',
                value: totalEtudiantsCount.toString(),
                icon: Icons.school,
                color: Color(0xFF7E6DB3),
              ),
              StatCard(
                title: 'Total Matières',
                value: totalMatieresCount.toString(),
                icon: Icons.book,
                color: Color(0xFF9F8DC3),
              ),
              StatCard(
                title: 'Total Classes',
                value: totalGrpClassesCount.toString(), // Afficher le nombre de groupes de classes
                icon: Icons.group,
                color: Color(0xFF8F7FB1),
              ),
            ],
          );
        } else {
          return Center(child: Text('No data available'));
        }
      },
    );
  }
}

*/

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: color),
            SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: 5),
            Text(
              title,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  Future<int> getTotalEnseignants() async {
    final response = await http
        .get(Uri.parse('$baseUrl/enseignant/retrieve-all-enseignants'));

    if (response.statusCode == 200) {
      List<dynamic> enseignants = json.decode(response.body);
      return enseignants.length; // Retourne le nombre total d'enseignants
    } else {
      throw Exception('Failed to load enseignants');
    }
  }

  Future<int> getTotalEtudiants() async {
    final response =
        await http.get(Uri.parse('$baseUrl/etudiant/retrieve-all-etudiants'));

    if (response.statusCode == 200) {
      List<dynamic> etudiants = json.decode(response.body);
      return etudiants.length; // Retourne le nombre total d'étudiants
    } else {
      throw Exception('Failed to load etudiants');
    }
  }

  Future<int> getTotalMatieres() async {
    final response =
        await http.get(Uri.parse('$baseUrl/matiere/retrieve-all-matieres'));
    if (response.statusCode == 200) {
      List<dynamic> matieres = json.decode(response.body);
      return matieres.length; // Retourne le nombre total de matières
    } else {
      throw Exception('Failed to load matieres');
    }
  }

  Future<int> getTotalGrpClasses() async {
    final response = await http
        .get(Uri.parse('$baseUrl/Grpclasses/retrieve-all-GrpClasses'));
    if (response.statusCode == 200) {
      List<dynamic> grpClasses = json.decode(response.body);
      return grpClasses
          .length; // Retourne le nombre total de groupes de classes
    } else {
      throw Exception('Failed to load grp classes');
    }
  }
}
