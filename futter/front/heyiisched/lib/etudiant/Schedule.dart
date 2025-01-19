import 'package:flutter/material.dart';
import 'package:heyiisched/Prof/model/model_emploi.dart';
import 'package:heyiisched/services/AuthService_y.dart';
import 'package:heyiisched/services/emp_etudiant.dart';

class StudentTimetable extends StatefulWidget {
  const StudentTimetable({Key? key}) : super(key: key);

  @override
  State<StudentTimetable> createState() => _StudentTimetableState();
}

class _StudentTimetableState extends State<StudentTimetable> {
  late final AuthService _authService;
  late final EmploiService _emploiService;
  List<Emploi> emplois = [];
  bool isLoading = true;
  String? error;
  String studentName = '';
  String groupeName = '';

  final List<String> days = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam'];
  final Map<String, String> dayMap = {
    'Lun': 'Lundi',
    'Mar': 'Mardi',
    'Mer': 'Mercredi',
    'Jeu': 'Jeudi',
    'Ven': 'Vendredi',
    'Sam': 'samedi'
  };
  final List<String> timeSlots = [
    '08:30:00 - 10:00:00',
    '10:05:00 - 11:35:00',
    '11:40:00 - 13:10:00',
    '13:15:00 - 14:30:00',
    '14:50:00 - 16:00:00',
    '16:25:00 - 17:30:00'
  ];

  @override
  void initState() {
    super.initState();
    _authService = AuthService();
    _emploiService = EmploiService(authService: _authService);
    _loadStudentInfo();
    _fetchEmplois();
  }

  Future<void> _loadStudentInfo() async {
    try {
      final student = await _authService.getCurrentStudent();
      if (mounted && student != null) {
        setState(() {
          studentName = '${student.prenom ?? ''} ${student.nom ?? ''}'.trim();
          groupeName = student.grpClass?.nom ?? 'Non assigné';
        });
      } else {
        setState(() {
          error = 'Student data not found';
        });
      }
    } catch (e) {
      print('Error loading student info: $e');
      if (mounted) {
        setState(() {
          error = 'Error loading student information';
        });
      }
    }
  }

  Future<void> _fetchEmplois() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });
      final fetchedEmplois = await _emploiService.getEmploiByStudentId();
      if (mounted) {
        setState(() {
          emplois = fetchedEmplois
              .where((emploi) =>
                  emploi.jour != null &&
                  emploi.heureDebut != null &&
                  emploi.heureFin != null)
              .toList();
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          error = 'Unable to load schedule: ${e.toString()}';
          isLoading = false;
        });
      }
    }
  }

// Modifications dans _buildClassCell et _buildHeaderCell
  Widget _buildClassCell(String day, String timeSlot) {
    final String fullDayName = dayMap[day] ?? day;
    final timeRange = timeSlot.split(' - ');
    final startTime = timeRange[0].trim();
    final endTime = timeRange[1].trim();

    final matchingEmplois = emplois.where((e) {
      return e.jour == fullDayName &&
          e.heureDebut != null &&
          e.heureFin != null &&
          _isTimeInRange(
              e.heureDebut!, e.heureFin!, "$startTime:00", "$endTime:00");
    }).toList();

    if (matchingEmplois.isNotEmpty && matchingEmplois.first.cours.isNotEmpty) {
      final currentCours = matchingEmplois.first.cours.first;
      return Container(
        constraints:
            const BoxConstraints(minHeight: 50), // Hauteur encore réduite
        padding: const EdgeInsets.all(2), // Moins de padding
        color: const Color(0xFFEEEEE),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              currentCours.matiere?.nom ?? 'No Subject',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 8, // Police encore plus petite
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 1), // Espacement réduit
            if (matchingEmplois.first.typeEmploi != null)
              Text(
                matchingEmplois.first.typeEmploi!,
                style: const TextStyle(fontSize: 8), // Police plus petite
              ),
            if (matchingEmplois.first.salles.isNotEmpty)
              Text(
                matchingEmplois.first.salles.first.nom ?? 'No Room',
                style: const TextStyle(fontSize: 8), // Police plus petite
              ),
            if (currentCours.enseignant != null)
              Text(
                '${currentCours.enseignant.nom ?? ''} ${currentCours.enseignant.prenom ?? ''}'
                    .trim(),
                style: const TextStyle(fontSize: 8), // Police plus petite
              ),
          ],
        ),
      );
    }

    return Container(
      constraints:
          const BoxConstraints(minHeight: 50), // Hauteur encore réduite
      padding: const EdgeInsets.all(2), // Moins de padding
      color: const Color.fromARGB(255, 171, 168, 218),
    );
  }

  bool _isTimeInRange(
      String emploiStart, String emploiEnd, String slotStart, String slotEnd) {
    try {
      final empStart = _parseTime(emploiStart);
      final empEnd = _parseTime(emploiEnd);
      final slStart = _parseTime(slotStart);
      final slEnd = _parseTime(slotEnd);

      return (empStart.isBefore(slEnd) || empStart.isAtSameMomentAs(slEnd)) &&
          (empEnd.isAfter(slStart) || empEnd.isAtSameMomentAs(slStart));
    } catch (e) {
      print('Error parsing time range: $e');
      return false;
    }
  }

  DateTime _parseTime(String timeStr) {
    try {
      final parts = timeStr.split(':');
      if (parts.length < 2) return DateTime(2024, 1, 1);
      return DateTime(
          2024, 1, 1, int.tryParse(parts[0]) ?? 0, int.tryParse(parts[1]) ?? 0);
    } catch (e) {
      print('Error parsing time: $e');
      return DateTime(2024, 1, 1);
    }
  }

  Widget _buildHeaderCell(String text) {
    return Container(
      padding: const EdgeInsets.all(4), // Réduction du padding
      color: const Color.fromARGB(255, 159, 155, 198),
      height: 60, // Réduction de la hauteur
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Color.fromARGB(255, 239, 238, 238),
            fontWeight: FontWeight.bold,
            fontSize: 12, // Taille de police réduite
          ),
        ),
      ),
    );
  }

  Widget _buildTimetableWidget() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        defaultColumnWidth: const FixedColumnWidth(50.0),
        border:
            TableBorder.all(color: const Color.fromARGB(255, 240, 239, 239)),
        children: [
          TableRow(
            children: [
              _buildHeaderCell('Horaire'),
              ...days.map((day) => _buildHeaderCell(day)),
            ],
          ),
          ...timeSlots.map((timeSlot) => _buildTimeSlotRow(timeSlot)).toList(),
        ],
      ),
    );
  }

  TableRow _buildTimeSlotRow(String timeSlot) {
    return TableRow(
      children: [
        _buildHeaderCell(timeSlot),
        ...days.map((day) => _buildClassCell(day, timeSlot)),
      ],
    );
  }

  Widget _buildStudentInfoCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7),
      ),
      child: Padding(
        padding: const EdgeInsets.all(7.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextLabelWithIcon('Étudiant: $studentName', Icons.person),
            _buildTextLabelWithIcon('Groupe: $groupeName', Icons.group),
            _buildTextLabelWithIcon(
                'Année Universitaire: 2023-2024', Icons.calendar_today),
          ],
        ),
      ),
    );
  }

  Widget _buildTextLabelWithIcon(String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, color: const Color(0XFF211A44)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
        title: const Text('Emploi du Temps'),
        centerTitle: true,
        backgroundColor: const Color(0xFF9F8DC3),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            _buildStudentInfoCard(),
            const SizedBox(height: 15),
            if (isLoading)
              const CircularProgressIndicator()
            else if (error != null)
              Text(
                error!,
                style: const TextStyle(color: Colors.red),
              )
            else
              Expanded(child: _buildTimetableWidget())
          ],
        ),
      ),
    );
  }
}/*import 'package:flutter/material.dart';
import 'package:heyiisched/Prof/model/model_emploi.dart';
import 'package:heyiisched/services/AuthService_y.dart';
import 'package:heyiisched/services/emp_etudiant.dart';

class StudentTimetable extends StatefulWidget {
  const StudentTimetable({Key? key}) : super(key: key);

  @override
  State<StudentTimetable> createState() => _StudentTimetableState();
}

class _StudentTimetableState extends State<StudentTimetable> {
  late final AuthService _authService;
  late final EmploiService _emploiService;
  List<Emploi> emplois = [];
  bool isLoading = true;
  String? error;
  String studentName = '';
  String groupeName = '';

  final List<String> days = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven'];
  final Map<String, String> dayMap = {
    'Lun': 'Lundi',
    'Mar': 'Mardi',
    'Mer': 'Mercredi',
    'Jeu': 'Jeudi',
    'Ven': 'Vendredi'
  };
  final List<String> timeSlots = [
    '08:30:00 - 10:00:00',
    '10:05:00 - 11:35:00',
    '11:40:00 - 13:10:00',
    '13:15:00 - 14:30:00',
    '14:50:00 - 16:00:00',
    '16:25:00 - 17:30:00'
  ];

  @override
  void initState() {
    super.initState();
    _authService = AuthService();
    _emploiService = EmploiService(authService: _authService);
    _loadStudentInfo();
    _fetchEmplois();
  }

  Future<void> _loadStudentInfo() async {
    try {
      final student = await _authService.getCurrentStudent();
      if (mounted && student != null) {
        setState(() {
          studentName = '${student.prenom ?? ''} ${student.nom ?? ''}'.trim();
          groupeName = student.grpClass?.nom ?? 'Non assigné';
        });
      } else {
        setState(() {
          error = 'Student data not found';
        });
      }
    } catch (e) {
      print('Error loading student info: $e');
      if (mounted) {
        setState(() {
          error = 'Error loading student information';
        });
      }
    }
  }

  Future<void> _fetchEmplois() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });
      final fetchedEmplois = await _emploiService.getEmploiByStudentId();
      if (mounted) {
        setState(() {
          emplois = fetchedEmplois
              .where((emploi) =>
                  emploi.jour != null &&
                  emploi.heureDebut != null &&
                  emploi.heureFin != null)
              .toList();
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          error = 'Unable to load schedule: ${e.toString()}';
          isLoading = false;
        });
      }
    }
  }

  Widget _buildClassCell(String day, String timeSlot) {
    final String fullDayName = dayMap[day] ?? day;
    final timeRange = timeSlot.split(' - ');
    final startTime = timeRange[0].trim();
    final endTime = timeRange[1].trim();

    final matchingEmplois = emplois.where((e) {
      return e.jour == fullDayName &&
          e.heureDebut != null &&
          e.heureFin != null &&
          _isTimeInRange(
              e.heureDebut!, e.heureFin!, "$startTime:00", "$endTime:00");
    }).toList();

    if (matchingEmplois.isNotEmpty && matchingEmplois.first.cours.isNotEmpty) {
      final currentCours = matchingEmplois.first.cours.first;
      return Container(
        constraints:
            const BoxConstraints(minHeight: 60), // Réduction de la hauteur
        padding: const EdgeInsets.all(4), // Réduction du padding
        color: const Color(0xFFEEEEE),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              currentCours.matiere?.nom ?? 'No Subject',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 10, // Taille de police réduite
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2), // Réduction de l'espacement
            if (matchingEmplois.first.typeEmploi != null)
              Text(
                matchingEmplois.first.typeEmploi!,
                style: const TextStyle(fontSize: 10),
              ),
            if (matchingEmplois.first.salles.isNotEmpty)
              Text(
                matchingEmplois.first.salles.first.nom ?? 'No Room',
                style: const TextStyle(fontSize: 10),
              ),
            if (currentCours.enseignant != null)
              Text(
                '${currentCours.enseignant.nom ?? ''} ${currentCours.enseignant.prenom ?? ''}'
                    .trim(),
                style: const TextStyle(fontSize: 10),
              ),
          ],
        ),
      );
    }

    return Container(
      constraints: const BoxConstraints(minHeight: 60),
      padding: const EdgeInsets.all(4),
      color: const Color.fromARGB(255, 171, 168, 218),
    );
  }

  bool _isTimeInRange(
      String emploiStart, String emploiEnd, String slotStart, String slotEnd) {
    try {
      final empStart = _parseTime(emploiStart);
      final empEnd = _parseTime(emploiEnd);
      final slStart = _parseTime(slotStart);
      final slEnd = _parseTime(slotEnd);

      return (empStart.isBefore(slEnd) || empStart.isAtSameMomentAs(slEnd)) &&
          (empEnd.isAfter(slStart) || empEnd.isAtSameMomentAs(slStart));
    } catch (e) {
      print('Error parsing time range: $e');
      return false;
    }
  }

  DateTime _parseTime(String timeStr) {
    try {
      final parts = timeStr.split(':');
      if (parts.length < 2) return DateTime(2024, 1, 1);
      return DateTime(
          2024, 1, 1, int.tryParse(parts[0]) ?? 0, int.tryParse(parts[1]) ?? 0);
    } catch (e) {
      print('Error parsing time: $e');
      return DateTime(2024, 1, 1);
    }
  }

  Widget _buildHeaderCell(String text) {
    return Container(
      padding: const EdgeInsets.all(4), // Réduction du padding
      color: const Color.fromARGB(255, 159, 155, 198),
      height: 60, // Réduction de la hauteur
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Color.fromARGB(255, 239, 238, 238),
            fontWeight: FontWeight.bold,
            fontSize: 12, // Taille de police réduite
          ),
        ),
      ),
    );
  }

  Widget _buildTimetableWidget() {
    return Table(
      defaultColumnWidth:
          const FixedColumnWidth(80.0), // Réduction de la largeur des colonnes
      border: TableBorder.all(color: const Color.fromARGB(255, 240, 239, 239)),
      children: [
        TableRow(
          children: [
            _buildHeaderCell('Horaire'),
            ...days.map((day) => _buildHeaderCell(day)),
          ],
        ),
        ...timeSlots.map((timeSlot) => _buildTimeSlotRow(timeSlot)).toList(),
      ],
    );
  }

  TableRow _buildTimeSlotRow(String timeSlot) {
    return TableRow(
      children: [
        _buildHeaderCell(timeSlot),
        ...days.map((day) => _buildClassCell(day, timeSlot)),
      ],
    );
  }

  Widget _buildStudentInfoCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7),
      ),
      child: Padding(
        padding: const EdgeInsets.all(7.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextLabelWithIcon('Étudiant: $studentName', Icons.person),
            _buildTextLabelWithIcon('Groupe: $groupeName', Icons.group),
            _buildTextLabelWithIcon(
                'Année Universitaire: 2023-2024', Icons.calendar_today),
          ],
        ),
      ),
    );
  }

  Widget _buildTextLabelWithIcon(String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, color: const Color(0XFF211A44)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
        title: const Text('Emploi du Temps'),
        centerTitle: true,
        backgroundColor: const Color(0xFF9F8DC3),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            _buildStudentInfoCard(),
            const SizedBox(height: 15),
            if (isLoading)
              const CircularProgressIndicator()
            else if (error != null)
              Text(
                error!,
                style: const TextStyle(color: Colors.red),
              )
            else
              Expanded(child: _buildTimetableWidget())
          ],
        ),
      ),
    );
  }
}
*/