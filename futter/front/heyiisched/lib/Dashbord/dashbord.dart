import 'package:flutter/material.dart';
import 'package:heyiisched/Dashbord/calendrier_enseignant/view_calendrier_enseignant.dart';
import 'package:intl/intl.dart'; // For date formatting


class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int selectedIndex = 0;

  String getCurrentDate() {
    return DateFormat('EEEE, d MMMM yyyy').format(DateTime.now());
  }

  final List<String> menuOptions = [
    'Dashbord',
    'Emploi du temps',
    'Calendrier enseignant',
    'Planification des salles',
    'Gestion des matières',
    'Déconnexion',
  ];

  Widget getSelectedContent() {
    switch (selectedIndex) {
      case 0:
        return Center(child: Text('Dashboard', style: TextStyle(fontSize: 24)));
      case 1:
        return Center(child: Text('Emploi du temps', style: TextStyle(fontSize: 24)));
      case 2:
        return CalendrierEnseignantPage(); // La page Calendrier Enseignant
      case 3:
        return Center(child: Text('Planification des salles', style: TextStyle(fontSize: 24)));
      case 4:
        return Center(child: Text('Gestion des matières', style: TextStyle(fontSize: 24)));
      case 5:
        return Center(child: Text('Déconnexion...', style: TextStyle(fontSize: 24)));
      default:
        return Center(child: Text('Sélectionner une option', style: TextStyle(fontSize: 24)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: selectedIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  selectedIndex = index;
                });
              },
              backgroundColor: Color(0xFF5C5792),
              selectedIconTheme: IconThemeData(color: Colors.white),
              unselectedIconTheme: IconThemeData(color: Colors.white70),
              labelType: NavigationRailLabelType.all,
              destinations: [
                NavigationRailDestination(
                  icon: Icon(Icons.adb),
                  label: Text('Dashbord'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.schedule),
                  label: Text('Emploi du temps'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.calendar_today),
                  label: Text('Calendrier enseignant'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.meeting_room),
                  label: Text('Planification des salles'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.book),
                  label: Text('Gestion des matières'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.logout),
                  label: Text('Déconnexion'),
                ),
              ],
            ),
            Expanded(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    color: Colors.grey.withOpacity(0.2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundImage: AssetImage('assets/images/user.JPG'),
                            ),
                            SizedBox(width: 8),
                            Text('Welcome, Admin', style: TextStyle(color: Color(0XFF9F8DC3))),
                          ],
                        ),
                        Container(
                          width: 200,
                          child: TextField(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Search...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.notifications, color: Colors.white),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  Expanded(child: getSelectedContent()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
