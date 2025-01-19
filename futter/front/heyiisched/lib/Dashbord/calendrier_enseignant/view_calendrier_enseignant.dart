import 'package:flutter/material.dart';
import 'package:heyiisched/Dashbord/calendrier_enseignant/EmploiListPage.dart';
import 'package:heyiisched/services/EnseignantService.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:heyiisched/models/Modeles.dart';
import 'package:flutter/material.dart';
import 'package:heyiisched/Dashbord/calendrier_enseignant/EmploiListPage.dart';
import 'package:heyiisched/services/EnseignantService.dart';
import 'package:heyiisched/models/Modeles.dart';
import 'form_add_prof.dart';

class CalendrierEnseignantPage extends StatefulWidget {
  @override
  _CalendrierEnseignantPageState createState() =>
      _CalendrierEnseignantPageState();
}

class _CalendrierEnseignantPageState extends State<CalendrierEnseignantPage> {
  final List<Enseignant> enseignants = [];
  List<Enseignant> filteredEnseignants = [];
  final TextEditingController searchController = TextEditingController();
  Grade? selectedGrade;

  @override
  void initState() {
    super.initState();
    fetchEnseignants();
    searchController.addListener(_filterEnseignants);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _filterEnseignants() {
    String searchTerm = searchController.text.toLowerCase();

    setState(() {
      filteredEnseignants = enseignants.where((enseignant) {
        bool matchesSearch =
            enseignant.nom?.toLowerCase().contains(searchTerm) == true ||
                enseignant.prenom.toLowerCase().contains(searchTerm);

        bool matchesGrade = true;
        if (selectedGrade != null) {
          matchesGrade = enseignant.grade == selectedGrade;
        }

        return matchesSearch && matchesGrade;
      }).toList();
    });
  }

  Future<void> fetchEnseignants() async {
    try {
      EnseignantService enseignantService = EnseignantService();
      List<Enseignant> fetchedEnseignants =
          await enseignantService.fetchEnseignants();

      setState(() {
        enseignants.clear();
        enseignants.addAll(fetchedEnseignants);
        filteredEnseignants = fetchedEnseignants;
      });
    } catch (e) {
      print('Erreur lors de la récupération des enseignants: $e');
    }
  }

  void onAddTeacher() {
    showDialog(
      context: context,
      builder: (context) {
        return AddTeacherForm(
          onAddTeacher: (Enseignant newTeacher) {
            setState(() {
              enseignants.add(newTeacher);
              _filterEnseignants();
            });
          },
        );
      },
    );
  }

  void onViewEmploi(Enseignant enseignant) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmploisPage(
            enseignantId: enseignant.id), // Passer l'ID de l'enseignant
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendrier Enseignant'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, '/admin/dashboard');
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildFilters(),
            SizedBox(height: 16),
            buildTeacherTable(
              filteredEnseignants,
              onViewEmploi,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFilters() {
    return Column(
      children: [
        TextField(
          controller: searchController,
          decoration: InputDecoration(
            labelText: "Search Teacher",
            hintText: "Enter name or surname",
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        SizedBox(height: 8),
        Container(
          width: double.infinity,
          child: InputDecorator(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            child: Row(
              children: [
                Text('Grade Filter: ', style: TextStyle(fontSize: 16)),
                SizedBox(width: 8),
                DropdownButton<Grade>(
                  value: selectedGrade,
                  hint: Text('All Grades'),
                  underline: Container(),
                  onChanged: (Grade? newValue) {
                    setState(() {
                      selectedGrade = newValue;
                      _filterEnseignants();
                    });
                  },
                  items: [
                    DropdownMenuItem<Grade>(
                        value: null, child: Text('All Grades')),
                    ...Grade.values.map<DropdownMenuItem<Grade>>((Grade grade) {
                      return DropdownMenuItem<Grade>(
                        value: grade,
                        child:
                            Text('Grade ${grade.toString().split('.').last}'),
                      );
                    }).toList(),
                  ],
                ),
                if (selectedGrade != null)
                  IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        selectedGrade = null;
                        _filterEnseignants();
                      });
                    },
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildTeacherTable(
    List<Enseignant> teachers,
    Function(Enseignant) onViewEmploi,
  ) {
    if (teachers.isEmpty) {
      return Expanded(
        child: Center(
          child: Text('No teachers found with the selected criteria'),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        itemCount: teachers.length,
        itemBuilder: (context, index) {
          final enseignant = teachers[index];
          return Card(
            elevation: 2,
            margin: EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              title: Text(
                "${enseignant.nom} ${enseignant.prenom}",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                  "Grade: ${enseignant.grade?.toString().split('.').last ?? 'N/A'}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.visibility),
                    onPressed: () => onViewEmploi(enseignant),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class EmploiService {
  final String baseUrl = 'http://localhost:8084/api/emplois';

  Future<List<Emploi>> getEmploisByEnseignantId(String enseignantId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/enseignants/$enseignantId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to load emplois: ${response.statusCode}');
      }

      final List<dynamic> emploisJson = json.decode(response.body);
      final emplois = emploisJson.map((json) => Emploi.fromJson(json)).toList();
      return emplois;
    } catch (e) {
      throw Exception('Failed to fetch emplois: $e');
    }
  }
}

class EmploisPage extends StatefulWidget {
  final String enseignantId; // ID de l'enseignant passé en paramètre

  const EmploisPage({Key? key, required this.enseignantId}) : super(key: key);

  @override
  _EmploisPageState createState() => _EmploisPageState();
}

class _EmploisPageState extends State<EmploisPage> {
  late Future<List<Emploi>> emploisFuture;

  static const Map<String, String> dayMap = {
    'Lundi': 'Lundi',
    'Mardi': 'Mardi',
    'Mercredi': 'Mercredi',
    'Jeudi': 'Jeudi',
    'Vendredi': 'Vendredi',
    'Samedi': 'Samedi'
  };

  static const List<String> timeSlots = [
    '08:30:00 - 10:00:00',
    '10:05:00 - 11:35:00',
    '11:40:00 - 13:10:00',
    '13:15:00 - 14:30:00',
    '14:50:00 - 16:00:00',
    '16:25:00 - 17:30:00'
  ];

  static const double timeColumnWidth = 60.0;
  static const double dayColumnWidth = 75.0;
  static const double cellHeight = 60.0;

  @override
  void initState() {
    super.initState();
    // Chargement des emplois lorsque l'ID de l'enseignant est disponible
    emploisFuture =
        EmploiService().getEmploisByEnseignantId(widget.enseignantId);
  }

  String _formatTimeSlot(String heureDebut, String heureFin) {
    return '$heureDebut - $heureFin';
  }

  Widget _buildTimeTableHeader() {
    return Container(
      height: 40,
      color: Colors.purple[100],
      child: Row(
        children: [
          SizedBox(
            width: timeColumnWidth,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Color.fromRGBO(190, 156, 199, 1)!),
              ),
              child: const Text(
                'Heure',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0XFF5C5792),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          ...dayMap.values
              .map((day) => SizedBox(
                    width: dayColumnWidth,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Color.fromRGBO(190, 156, 199, 1)!),
                      ),
                      child: Text(
                        day,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0XFF5C5792),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildTimeSlot(String timeSlot, List<Emploi> emplois) {
    return Container(
      height: cellHeight,
      child: Row(
        children: [
          SizedBox(
            width: timeColumnWidth,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.purple[100]!),
                color: Colors.purple[50],
              ),
              child: Text(
                timeSlot,
                style: TextStyle(
                  color: Color(0XFF211A44),
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          ...dayMap.keys.map((day) {
            final coursDay = emplois.where((e) {
              final emploiTimeSlot =
                  _formatTimeSlot(e.heureDebut, e.heureFin).trim();
              return e.jour.trim().toLowerCase() == day.toLowerCase() &&
                  (e.heureDebut == timeSlot.split(" - ")[0] ||
                      e.heureFin == timeSlot.split(" - ")[1]);
            }).toList();

            print(
                'Jour: $day, Créneau: $timeSlot, Emplois: ${coursDay.length}');

            return SizedBox(
              width: dayColumnWidth,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.purple[100]!),
                  color: coursDay.isNotEmpty ? Colors.purple[50] : Colors.white,
                ),
                child: coursDay.isEmpty
                    ? const Center(child: Text('-'))
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (var c in coursDay[0].cours!)
                            Column(
                              children: [
                                Text(
                                  c.matiere?.nom ?? 'Sans nom',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (coursDay[0].salles.isNotEmpty)
                                  Text(
                                    coursDay[0].salles[0].nom ??
                                        'Salle non définie',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0XFF5C5792),
                                    ),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                              ],
                            ),
                        ],
                      ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTeacherInfo(List<Emploi> emplois) {
    if (emplois.isEmpty || emplois[0].cours!.isEmpty) {
      return const SizedBox.shrink();
    }

    final enseignant = emplois[0].cours?[0].enseignant;

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.purple[50],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            'assets/images/logo.png',
            width: 100,
            height: 50,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enseignant: ${enseignant!.nom} ${enseignant.prenom}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0XFF5C5792),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Grade: ${enseignant.grade}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0XFF5C5792),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emploi du Temps'),
        backgroundColor: Color(0XFFBE9CC7),
      ),
      body: FutureBuilder<List<Emploi>>(
        future: emploisFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Erreur : ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Aucun emploi trouvé.'),
            );
          }

          final emplois = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              children: [
                _buildTeacherInfo(emplois),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: timeColumnWidth + (dayColumnWidth * dayMap.length),
                    child: Column(
                      children: [
                        _buildTimeTableHeader(),
                        ...timeSlots
                            .map(
                                (timeSlot) => _buildTimeSlot(timeSlot, emplois))
                            .toList(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
/*import 'package:flutter/material.dart';
import 'package:heyiisched/Dashbord/calendrier_enseignant/EmploiListPage.dart';
import 'package:heyiisched/models/Modeles.dart';
import 'package:heyiisched/models/classe_models.dart';
import 'package:heyiisched/services/EnseignantService.dart';
import 'form_add_prof.dart'; 

class CalendrierEnseignantPage extends StatefulWidget {
  @override
  _CalendrierEnseignantPageState createState() => _CalendrierEnseignantPageState();
}
class _CalendrierEnseignantPageState extends State<CalendrierEnseignantPage> {
  final List<Enseignant> enseignants = [];  // Liste vide au départ

  @override
  void initState() {
    super.initState();
    fetchEnseignants(); // Récupère les enseignants au démarrage
  }
  Future<void> fetchEnseignants() async {
    try {
      EnseignantService enseignantService = EnseignantService();
      List<Enseignant> fetchedEnseignants = await enseignantService.fetchEnseignants();
      setState(() {
        enseignants.clear();
        enseignants.addAll(fetchedEnseignants);  // Met à jour la liste des enseignants
      });
    } catch (e) {
      print('Erreur lors de la récupération des enseignants: $e');
    }
  }
  void onAddTeacher() {
    showDialog(
      context: context,
      builder: (context) {
        return AddTeacherForm(
          onAddTeacher: (Enseignant newTeacher) {
            setState(() {
              enseignants.add(newTeacher); // Ajoute le nouvel enseignant à la liste
            });
          },
        );
      },
    );
  }
  void onDeleteTeacher(Enseignant enseignant) {
    print("Delete teacher: ${enseignant.nom}");
  }
  void onEditTeacher(Enseignant enseignant) {
    // Implémenter l'édition
    print("Edit teacher: ${enseignant.nom}");
  }
 void onViewEmploi(Enseignant enseignant) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => EmploiListPage(enseignant: enseignant),
    ),
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendrier Enseignant'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, '/admin/dashboard'); // Retour à AdminDashboard
          },
        ),
         // backgroundColor: Colors.purple[200],
         backgroundColor: Color.fromARGB(255, 129, 123, 194),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildSearchBar(),
            SizedBox(height: 16),
            buildTeacherTable(
              enseignants,
              onDeleteTeacher,
              onEditTeacher,
              onViewEmploi,
            ),
            SizedBox(height: 16),
          //  buildAddTeacherButton(onAddTeacher),  // Bouton pour afficher le formulaire d'ajout
          ],
        ),
      ),
    );
  }
  Widget buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        labelText: "Search Teacher",
        border: OutlineInputBorder(),
      ),
    );
  }
  Widget buildTeacherTable(
    List<Enseignant> enseignants,
    Function(Enseignant) onDeleteTeacher,
    Function(Enseignant) onEditTeacher,
    Function(Enseignant) onViewEmploi,
  ) {
    return Expanded(
      child: ListView.builder(
        itemCount: enseignants.length,
        itemBuilder: (context, index) {
          final enseignant = enseignants[index];
          return Card(
            child: ListTile(
              title: Text("${enseignant.nom} ${enseignant.prenom}"),
              subtitle: Text("Grade: ${enseignant.grade.toString()}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /*IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => onEditTeacher(enseignant),
                  ),*/
                  IconButton(
                    icon: Icon(Icons.visibility),
                    onPressed: () => onViewEmploi(enseignant),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
 //Widget buildAddTeacherButton(Function onAddTeacher) {
    return ElevatedButton(
      onPressed: () => onAddTeacher(),
      child: Text("Add Teacher"),
    );
  }
}*/
