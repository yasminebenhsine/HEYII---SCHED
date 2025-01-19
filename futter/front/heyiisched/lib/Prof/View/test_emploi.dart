import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:heyiisched/Prof/model/profEmploi.dart';
import 'package:heyiisched/services/emploiProf.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class TimetablePage extends StatefulWidget {
  @override
  _TimetablePageState createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  late Future<List<Cours>> futureCours;

  @override
  void initState() {
    super.initState();
    futureCours = Future.value([]); // Initialisation avec une liste vide
    _loadCoursForConnectedUser();
  }

  void _loadCoursForConnectedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId'); // Récupérez l'ID de l'enseignant connecté

    if (userId != null) {
      if (mounted) {
        setState(() {
          futureCours = CoursService().getCoursByEnseignant(userId);
        });
      }
    } else {
      // Gérer le cas où l'utilisateur n'est pas connecté
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Utilisateur non connecté.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Emploi du temps')),
      body: FutureBuilder<List<Cours>>(
        future: futureCours,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucun cours disponible.'));
          } else {
            final coursList = snapshot.data!;
            return _buildTimetable(coursList);
          }
        },
      ),
    );
  }
Widget _buildTimetable(List<Cours> timetable) {
  final List<String> days = ['Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi'];
  final List<String> timeSlots = [
    '08:00 - 10:00',
    '10:15 - 12:15',
    '13:00 - 15:00',
    '15:15 - 17:15'
  ];

  // Créez une carte pour accéder facilement aux cours par jour et créneau horaire
  Map<String, Map<String, Cours>> coursByDayAndTime = {};

  // Initialiser les jours et les créneaux horaires pour chaque jour
  for (var day in days) {
    coursByDayAndTime[day] = {};
    for (var timeSlot in timeSlots) {
      // Remplir avec des détails valides si nécessaire
      coursByDayAndTime[day]![timeSlot] = Cours(
        idCours: 'ID Inconnu', // Remplir avec un ID valide ou un champ vide si non disponible
        matiere: Matiere.defaultInstance(), // Remplir avec des détails par défaut
        enseignant: Enseignant.defaultInstance(), // Remplir avec des détails par défaut
        grpClass: GrpClass.defaultInstance(), // Remplir avec des détails par défaut
        emploi: null,  // Vous pouvez assigner un emploi valide ici si vous avez les données
      );
    }
  }

  // Organisez les cours en fonction de leur index et placez-les dans la bonne cellule
  int i = 0;
  for (var cours in timetable) {
    int dayIndex = i % days.length; // Utiliser un index pour répartir les cours
    int timeIndex = i % timeSlots.length; // Répartir les cours sur les créneaux horaires

    String day = days[dayIndex];
    String timeSlot = timeSlots[timeIndex];

    // Remplir les informations réelles du cours
    coursByDayAndTime[day]![timeSlot] = Cours(
      idCours: cours.idCours ?? 'ID Inconnu', // Utilisez les données réelles de votre cours
      matiere: cours.matiere ?? Matiere.defaultInstance(),
      enseignant: cours.enseignant ?? Enseignant.defaultInstance(),
      grpClass: cours.grpClass ?? GrpClass.defaultInstance(),
      emploi: cours.emploi, // Assigner l'Emploi du cours s'il est disponible
    );

    i++; // Incrémenter l'index
  }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  _buildTextLabelWithIcon(
                    'Département : Informatique & Spécialité : IA',
                    Icons.school,
                  ),
                  _buildTextLabelWithIcon(
                    'Année Universitaire : 2023 - 2024',
                    Icons.calendar_today,
                  ),
                  _buildTextLabelWithIcon(
                    'Semestre : 1',
                    Icons.timeline,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Table(
              defaultColumnWidth: const FixedColumnWidth(100.0),
              border: TableBorder.all(color: Colors.grey),
              children: [
                TableRow(
                  children: [
                    _buildCell('Time', isHeader: true),
                    for (var day in days) _buildCell(day, isHeader: true),
                  ],
                ),
                for (var time in timeSlots)
                  TableRow(
                    children: [
                      _buildCell(time, isHeader: true),
                      for (int i = 0; i < days.length; i++)
                        _buildEventCell(
                          days[i],
                          time,
                          coursByDayAndTime,
                        ), // Cellule dynamique
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCell(String day, String time, Map<String, Map<String, Cours>> coursByDayAndTime) {
    // Récupérer le cours pour ce jour et ce créneau horaire
    Cours? cours = coursByDayAndTime[day]?[time];

    if (cours != null && cours.matiere.nom != null) {
      // Si un cours existe, l'afficher
      return _buildCell(
        '${cours.matiere.nom ?? 'Inconnu'}',
        isHeader: false,
      );
    } else {
      // Sinon, afficher une cellule vide
      return _buildCell('Aucun cours', isHeader: false);
    }
  }

  Widget _buildCell(String text, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        alignment: Alignment.center,
        color: isHeader ? Colors.grey[300] : Colors.transparent,
        child: Text(
          text,
          style: TextStyle(fontWeight: isHeader ? FontWeight.bold : FontWeight.normal),
        ),
      ),
    );
  }

  Widget _buildTextLabelWithIcon(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 24),
        const SizedBox(width: 8),
        Text(text, style: TextStyle(fontSize: 16)),
      ],
    );
  }
}
