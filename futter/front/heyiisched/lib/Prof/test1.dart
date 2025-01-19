import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/Modeles.dart'; // Assurez-vous que ce chemin est correct
import 'package:http/http.dart' as http;

class EmploisPage extends StatefulWidget {
  const EmploisPage({Key? key}) : super(key: key);

  @override
  _EmploisPageState createState() => _EmploisPageState();
}

class _EmploisPageState extends State<EmploisPage> {
  late Future<List<Emploi>> emploisFuture = Future.value([]);
  String? enseignantId;

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
  static const double cellHeight =
      60.0; // Increased height to accommodate salle

  @override
  void initState() {
    super.initState();
    _loadEnseignantId();
  }

  Future<void> _loadEnseignantId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('userData') ?? '{}';
    final Map<String, dynamic> userData = json.decode(userDataString);

    final String userId = userData['id'] ?? '';
    print('UserID récupéré: $userId');

    if (userId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("ID de l'enseignant introuvable.")),
      );
      setState(() {
        emploisFuture = Future.error('ID de l\'enseignant introuvable.');
      });
      return;
    }

    setState(() {
      emploisFuture = EmploiService().getEmploisByEnseignantId(userId);
    });
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
        mainAxisAlignment:
            MainAxisAlignment.start, // Alignement des éléments au début
        children: [
          // Affichage du logo
          Image.asset(
            'assets/images/logo.png', // Chemin du logo
            width: 100, // Largeur du logo
            height: 50, // Hauteur du logo
          ),
          const SizedBox(width: 16), // Espacement entre le logo et les détails

          // Détails de l'enseignant
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
      print('Réponse API: $emploisJson'); // Debug print

      final emplois = emploisJson.map((json) => Emploi.fromJson(json)).toList();
      print('Emplois parsés: ${emplois.length}'); // Debug print

      return emplois;
    } catch (e) {
      print('Erreur lors de la récupération des emplois: $e'); // Debug print
      throw Exception('Failed to fetch emplois: $e');
    }
  }
}
/*
class EmploisPage extends StatefulWidget {
  const EmploisPage({Key? key}) : super(key: key);

  @override
  _EmploisPageState createState() => _EmploisPageState();
}

class _EmploisPageState extends State<EmploisPage> {
  late Future<List<Emploi>> emploisFuture = Future.value([]); // Initialiser avec une liste vide
  String? enseignantId;

  @override
  void initState() {
    super.initState();
    _loadEnseignantId();
  }

  /// Charge l'ID de l'enseignant depuis `SharedPreferences`.
  Future<void> _loadEnseignantId() async {
    // Récupérer les données de SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('userData') ?? '{}'; // Défaut : chaîne JSON vide
    final Map<String, dynamic> userData = json.decode(userDataString);

    // Vérifier et récupérer l'ID utilisateur
    final String userId = userData['id'] ?? '';
    print('Enseignant ID récupéré : $userId'); // Débogage

    if (userId.isEmpty) {
      print('Erreur : ID de l\'enseignant est vide');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("ID de l'enseignant introuvable.")),
      );
      setState(() {
        emploisFuture = Future.error('ID de l\'enseignant introuvable.');
      });
      return; // Si l'ID est introuvable, on arrête l'exécution.
    }

    // Si l'ID est trouvé, charger les emplois correspondants
    setState(() {
      emploisFuture = EmploiService().getEmploisByEnseignantId(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emplois de l\'enseignant'),
      ),
      body: FutureBuilder<List<Emploi>>(
        future: emploisFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucun emploi trouvé.'));
          }

          final emplois = snapshot.data!;

          return ListView.builder(
            itemCount: emplois.length,
            itemBuilder: (context, index) {
              final emploi = emplois[index];
              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text('Jour : ${emploi.jour}'),
                subtitle: Text(
  'Heure : ${emploi.heureDebut} - ${emploi.heureFin}  *\n'
  'Cours : ${emploi.cours != null && emploi.cours!.isNotEmpty 
    ? emploi.cours!.map((c) => c.matiere?.nom).join(', ') 
    : "Aucun cours"} - ${emploi.jour}',
),


                ),
              );
            },
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
        Uri.parse('$baseUrl/enseignants/$enseignantId'), // Ajout de l'ID à l'URL
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to load emplois: ${response.statusCode}');
      }
      
      final List<dynamic> emploisJson = json.decode(response.body);
      print("Emplois reçus: $emploisJson");

      return emploisJson
          .map((json) => Emploi.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch emplois: $e');
    }
  }
}*/
