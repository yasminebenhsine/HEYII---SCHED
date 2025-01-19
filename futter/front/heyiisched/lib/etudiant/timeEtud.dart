import 'package:flutter/material.dart';
import 'package:heyiisched/models/emploi.dart';
import 'package:heyiisched/services/timeEtud.dart';

class StudentTimetable extends StatefulWidget {
  const StudentTimetable({super.key});

  @override
  State<StudentTimetable> createState() => _StudentTimetableState();
}

class _StudentTimetableState extends State<StudentTimetable> {
  late Future<List<Emploi>> _timetableFuture;

  @override
  void initState() {
    super.initState();
    // Initialize the future to fetch timetable data
    _timetableFuture = TimetableService().fetchTimetable();
  }

  Widget _buildTextLabelWithIcon(String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF211A44)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCell(String content, {bool isHeader = false}) {
    return Container(
      constraints: const BoxConstraints(minHeight: 70),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8),
      color: isHeader ? const Color(0xFF5C5792) : Colors.white,
      child: Text(
        content,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          fontSize: 16,
          color: isHeader ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Widget _buildEventCell(String day, String timeSlot, List<Emploi>? timetable) {
    // Find the event based on the day and timeSlot
    final event = timetable?.firstWhere(
      (emploi) =>
          emploi.jour == day &&
          emploi.heureDebut == timeSlot.split(' - ')[0] &&
          emploi.heureFin == timeSlot.split(' - ')[1],
      orElse: () => Emploi(
        idEmploi: '',
        typeEmploi: '',
        jour: '',
        heureDebut: '',
        heureFin: '',
        enseignants: [],
        salles: [],
        grpClasses: [],
        admin: null,
        cours: null,
      ),
    );

    if (event != null && event.idEmploi.isNotEmpty) {
      return Container(
        constraints: const BoxConstraints(minHeight: 70),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8),
        color: Colors.grey[200],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(event.typeEmploi.isNotEmpty ? event.typeEmploi : 'No data'),
            if (event.enseignants.isNotEmpty)
              Text('Prof: ${event.enseignants[0] ?? 'No data'}'),
            if (event.salles.isNotEmpty)
              Text('Salle: ${event.salles[0] ?? 'No data'}'),
          ],
        ),
      );
    } else {
      return Container(
        constraints: const BoxConstraints(minHeight: 70),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8),
        color: Colors.grey[200],
        child: const Text('No Data'), // Placeholder for missing data
      );
    }
  }

  Widget _buildTimetable(List<Emploi>? timetable) {
    final List<String> days = [
      'Lundi',
      'Mardi',
      'Mercredi',
      'Jeudi',
      'Vendredi'
    ];
    final List<String> timeSlots = [
      '08:00 - 10:00',
      '10:15 - 12:15',
      '13:00 - 15:00',
      '15:15 - 17:15'
    ];

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
                    'Emploi du Temps de La Classe : Group 1',
                    Icons.group,
                  ),
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
                            days[i], time, timetable), // Dynamic event cell
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF5C5792), Color(0xFF9C92D9)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          'Emploi du Temps',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.person),
          ),
        ],
      ),
      body: FutureBuilder<List<Emploi>>(
        future: _timetableFuture,
        builder: (context, snapshot) {
          // Log the state of the snapshot for debugging
          print("Snapshot state: ${snapshot.connectionState}");
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No timetable available'),
            );
          } else {
            return _buildTimetable(snapshot.data);
          }
        },
      ),
    );
  }
}