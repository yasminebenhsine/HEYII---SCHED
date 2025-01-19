import 'package:flutter/material.dart';

import 'package:heyiisched/Prof/my_widget/app_bar_clipper.dart';
import 'package:heyiisched/Prof/widget_prof.dart';
import 'package:heyiisched/models/emploi.dart';

import 'package:heyiisched/services/timeEtud.dart';

class Timetable extends StatefulWidget {
  @override
  _TimetableState createState() => _TimetableState();
}

class _TimetableState extends State<Timetable> {
  final List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  final List<String> timeSlots = [
    '08:00',
    '10:00',
    '12:00',
    '14:00',
    '16:00',
    '18:00',
  ];

  late Future<List<Emploi>> timetable;

  @override
  void initState() {
    super.initState();
    timetable = TimetableService().fetchTimetable(); // Fetch timetable data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 248, 243, 246),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with back arrow, logo, and greeting
            Stack(
              children: [
                ClipPath(
                  clipper: AppBarClipper(),
                  child: Container(
                    height: 240,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF9F8DC3),
                          Color(0xFFBE9CC7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 20,
                  left: 20,
                  right: 20,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyHomePage(),
                            ),
                          );
                        },
                      ),
                      SizedBox(width: 10),
                      Image.asset(
                        'assets/images/logo.png',
                        width: 180,
                        height: 180,
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          'Bonjour Madame/Monsieur',
                          style: TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 30,
                  right: 20,
                  child: GestureDetector(
                    onTap: () {
                      showMenu(
                        context: context,
                        position: RelativeRect.fromLTRB(200, 100, 20, 100),
                        items: [
                          PopupMenuItem(
                            child: Text("Logout"),
                            value: "logout",
                          ),
                        ],
                      ).then((value) {
                        if (value == "logout") {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Logged out checked!'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      });
                    },
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/images/user.JPG'),
                    ),
                  ),
                ),
              ],
            ),

            // Timetable Grid Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Hello, Professor!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Grid for timetable
                  Container(
                    height: 500, // Add height to make sure the grid fits
                    child: FutureBuilder<List<Emploi>>(
                      future: timetable,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Center(child: Text('No data available'));
                        } else {
                          List<Emploi> emplois = snapshot.data!;

                          return GridView.builder(
                            itemCount:
                                (timeSlots.length + 1) * (days.length + 1),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: days.length + 1,
                              childAspectRatio: 2,
                              crossAxisSpacing: 4,
                              mainAxisSpacing: 4,
                            ),
                            itemBuilder: (context, index) {
                              int row = index ~/ (days.length + 1);
                              int column = index % (days.length + 1);

                              // If it's the first row or first column, display headers
                              if (row == 0 && column == 0) {
                                return Container(); // Empty corner
                              }

                              if (row == 0) {
                                // Day headers (first row)
                                return Container(
                                  padding: const EdgeInsets.all(10),
                                  color: Color(0xFFBE9CC7),
                                  child: Center(
                                    child: Text(
                                      days[column - 1],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                );
                              }

                              if (column == 0) {
                                // Time headers (first column) with grey background
                                return Container(
                                  padding: const EdgeInsets.all(10),
                                  color: Colors.grey[300],
                                  child: Center(
                                    child: Text(
                                      timeSlots[row - 1],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                );
                              }

                              // Fetching the relevant Emploi for this cell
                              Emploi emploi = emplois.firstWhere(
                                (e) =>
                                    e.jour == days[column - 1] &&
                                    e.heureDebut == timeSlots[row - 1],
                                orElse: () => Emploi(
                                    idEmploi: '',
                                    typeEmploi: '',
                                    jour: '',
                                    heureDebut: '',
                                    heureFin: '',
                                    enseignants: [],
                                    salles: [],
                                    grpClasses: []),
                              );

                              // Cells for "Matières"
                              return Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(8.0),
                                color: (column % 2 == 0)
                                    ? Color(
                                        0xFFE5DFF2) // Light purple for alternating
                                    : Colors
                                        .white, // White background for alternating
                                child: Text(
                                  emploi.idEmploi.isEmpty
                                      ? '**'
                                      : emploi.cours?.toString() ?? 'No course',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
/*
class Timetable extends StatelessWidget {
  final List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  final List<String> timeSlots = [
    '8:00',
    '10:00',
    '12:00',
    '14:00',
    '16:00',
    '18:00'
  ];

  final List<Enseignant> enseignants = [
    Enseignant(
      id: '1',
      nom: 'M. Dupont',
      prenom: 'Jean',
      email: 'dupont@example.com',
      nbHeure: 20,
      grade: Grade.A,
      matieres: [
        Matiere(nom: 'Mathématiques1', code: '3', credits: 20),
      ],
      cours: [],
      filieres: [],
      specialites: [],
      reclamations: [],
      emploi: Emploi(
        typeEmploi: 'CM',
        jour: 'Monday',
        heureDebut: '10:00',
        heureFin: '12:00',
        enseignant: [],
        groupeClasse: [],
        salle: [],
        matiere: Matiere(nom: 'Mathématiques1', code: '3', credits: 20),
      ),
      voeux: [],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon EMPLOI'),
        centerTitle: true,
        backgroundColor: const Color(0xFF5C5792),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // En-tête des jours
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: days.map((day) {
                  return Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: day == 'Saturday' || day == 'Sunday'
                            ? Colors.grey[300]
                            : Colors.blue[100],
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Text(
                        day,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              // Tableau des horaires
              Row(
                children: [
                  // Colonne des horaires
                  Container(
                    width: 120,
                    child: Column(
                      children: timeSlots.map((time) {
                        return Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Text(time, textAlign: TextAlign.center),
                        );
                      }).toList(),
                    ),
                  ),
                  // Grille des matières
                  Expanded(
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        childAspectRatio: 2,
                      ),
                      itemCount: timeSlots.length * days.length,
                      itemBuilder: (context, index) {
                        int row = index ~/ 7;
                        int column = index % 7;

                        String day = days[column];
                        String timeSlot = timeSlots[row];

                        // Logique pour trouver la matière
                        String matiere = '';
                        for (var enseignant in enseignants) {
                          var emploi = enseignant.emploi; // Un seul emploi
                          if (emploi != null &&
                              emploi.jour == day &&
                              emploi.heureDebut == timeSlot) {
                            matiere = emploi.matiere.nom;
                          }
                        }

                        return Container(
                          decoration: BoxDecoration(
                            color: (column == 5 || column == 6)
                                ? Colors.grey[300]
                                : Colors.blueAccent,
                            border: Border.all(color: Colors.grey),
                          ),
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: matiere.isNotEmpty
                                ? Text(
                                    matiere,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: Colors.white),
                                  )
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/
