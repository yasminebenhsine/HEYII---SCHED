import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:heyiisched/Dashbord/details/StudentsPage.dart';
import 'package:http/http.dart' as http;

class EtudiantListScreen extends StatefulWidget {
  final GrpClass grpClass;

  const EtudiantListScreen({Key? key, required this.grpClass})
      : super(key: key);

  @override
  _EtudiantListScreenState createState() => _EtudiantListScreenState();
}

class _EtudiantListScreenState extends State<EtudiantListScreen> {
  final GrpClassService _grpClassService = GrpClassService();
  List<Etudiant> _etudiants = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadEtudiants();
  }

  Future<void> _loadEtudiants() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final etudiants =
          await _grpClassService.getEtudiantsForGrpClass(widget.grpClass.idGrp);

      setState(() {
        _etudiants = etudiants;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load students: $e';
        _isLoading = false;
      });
      print('Error loading students: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Students - ${widget.grpClass.nom}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadEtudiants,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadEtudiants,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_etudiants.isEmpty) {
      return const Center(
        child: Text('No students found in this class'),
      );
    }

    return ListView.builder(
      itemCount: _etudiants.length,
      itemBuilder: (context, index) {
        final etudiant = _etudiants[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              child: Text(
                '${etudiant.prenom?[0]}${etudiant.nom?[0]}',
                style: const TextStyle(fontSize: 14),
              ),
            ),
            title: Text('${etudiant.prenom} ${etudiant.nom}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Email: ${etudiant.email ?? "N/A"}'),
                Text('Phone: ${etudiant.telephone ?? "N/A"}'),
              ],
            ),
            isThreeLine: true,
          ),
        );
      },
    );
  }
}

class EmploiDetailScreen extends StatefulWidget {
  final GrpClass grpClass;

  const EmploiDetailScreen({Key? key, required this.grpClass})
      : super(key: key);

  @override
  _EmploiDetailScreenState createState() => _EmploiDetailScreenState();
}

class _EmploiDetailScreenState extends State<EmploiDetailScreen> {
  final GrpClassService _grpClassService = GrpClassService();
  bool _isLoading = true;
  List<Emploi> _emplois = [];
  String? _error;

  final List<String> timeSlots = [
    '08:30-10:00',
    '10:00-11:30',
    '11:30-13:00',
    '13:00-14:30',
    '14:30-16:00',
    '16:00-17:30'
  ];

  final List<String> weekDays = [
    'Lundi',
    'Mardi',
    'Mercredi',
    'Jeudi',
    'Vendredi',
    'Samedi'
  ];

  @override
  void initState() {
    super.initState();
    _loadEmploi();
  }

  Future<void> _loadEmploi() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final emplois =
          await _grpClassService.getEmploiForGrpClass(widget.grpClass.idGrp);

      setState(() {
        _emplois = emplois;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load schedule: $e';
        _isLoading = false;
      });
    }
  }

  Widget _buildCell(BuildContext context, String day, String timeSlot) {
    Cours? matchingCours;
    Emploi? matchingEmploi;

    for (var emploi in _emplois) {
      if (emploi.jour == day &&
          _isTimeMatching(emploi.heureDebut ?? '', timeSlot)) {
        matchingEmploi = emploi;
        if (emploi.cours?.isNotEmpty == true) {
          matchingCours = emploi.cours!.first;
        }
        break;
      }
    }

    return Container(
      width: 60,
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.purple.shade100),
        color: matchingCours != null
            ? Colors.purple.shade50
            : Colors.purple.shade100.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: matchingCours != null
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    matchingCours.matiere?.nom ?? 'N/A',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.deepPurple,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    matchingCours.enseignant?.nom ?? 'N/A',
                    style: const TextStyle(fontSize: 11, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                  if (matchingEmploi?.salles?.isNotEmpty ?? false) ...[
                    const SizedBox(height: 2),
                    Text(
                      matchingEmploi!.salles!.first.nom ?? 'N/A',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            )
          : const Center(child: Text('No class')),
    );
  }

  bool _isTimeMatching(String courseTime, String timeSlot) {
    final courseStartTime = courseTime.substring(0, 5);
    final slotStartTime = timeSlot.split('-')[0].trim();
    return courseStartTime == slotStartTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Schedule - ${widget.grpClass.nom}',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 167, 163, 216),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadEmploi,
          ),
        ],
      ),
      body: _buildBody(),
      backgroundColor: Colors.purple.shade50,
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadEmploi,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 167, 163, 216),
              ),
              child: const Text('Retry', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            ...timeSlots
                .map((timeSlot) => _buildTimeSlotRow(timeSlot))
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 60,
          height: 100,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.purple.shade100),
            color: Colors.purple.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text('Time',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              )),
        ),
        ...weekDays.map((day) => Container(
              width: 60,
              height: 100,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.purple.shade100),
                color: Colors.purple.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(day,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  )),
            )),
      ],
    );
  }

  Widget _buildTimeSlotRow(String timeSlot) {
    return Row(
      children: [
        Container(
          width: 60,
          height: 100,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.purple.shade100),
            color: Colors.purple.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            timeSlot,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        ...weekDays.map((day) => _buildCell(context, day, timeSlot)),
      ],
    );
  }
}

class GrpClassListScreen extends StatefulWidget {
  @override
  _GrpClassListScreenState createState() => _GrpClassListScreenState();
}

class _GrpClassListScreenState extends State<GrpClassListScreen> {
  final GrpClassService _grpClassService = GrpClassService();
  List<GrpClass> _grpClasses = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadGrpClasses();
  }

  Future<void> _loadGrpClasses() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final grpClasses = await _grpClassService.getAllGrpClasses();

      setState(() {
        _grpClasses = grpClasses;
        _isLoading = false;
      });

      // Debug print to verify data
      print('Loaded ${_grpClasses.length} classes:');
      for (var grpClass in _grpClasses) {
        print('Class: ${grpClass.nom} (${grpClass.idGrp})');
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to load classes: $e';
        _isLoading = false;
      });
      print('Error in _loadGrpClasses: $e');
    }
  }

  void _viewEmploi(GrpClass grpClass) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmploiDetailScreen(grpClass: grpClass),
      ),
    );
  }

  void _viewStudents(GrpClass grpClass) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EtudiantListScreen(grpClass: grpClass),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Class Groups'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(
                context, '/admin/dashboard'); // Retour à AdminDashboard
          },
        ),
        //backgroundColor: Colors.purple[200],
        backgroundColor: Color.fromARGB(255, 129, 123, 194),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadGrpClasses,
          ),
        ],
      ),
      body: _buildBody(),
      backgroundColor: Colors.purple[50],
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
          child: CircularProgressIndicator(color: Colors.purple));
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _error!,
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadGrpClasses,
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.purple[300]),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_grpClasses.isEmpty) {
      return const Center(
        child: Text(
          'No class groups found',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadGrpClasses,
      color: Colors.purple,
      child: ListView.builder(
        itemCount: _grpClasses.length,
        itemBuilder: (context, index) {
          final grpClass = _grpClasses[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.purple[100],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: Text(
                grpClass.nom,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Color(0XFF5C5792)),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Speciality: ${grpClass.specialite ?? "N/A"}',
                    style: const TextStyle(color: Colors.black54),
                  ),
                  if (grpClass.filiere != null)
                    Text(
                      'Department: ${grpClass.filiere?.nom ?? "N/A"}',
                      style: const TextStyle(color: Colors.black54),
                    ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.schedule, color: Color(0XFF5C5792)),
                    onPressed: () => _viewEmploi(grpClass),
                  ),
                  /*IconButton(
                    icon: const Icon(Icons.people, color: Colors.purple),
                    onPressed: () => _viewStudents(grpClass),
                  ),
                   IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _showForm(grpClass: grpClass),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await _apiService.deleteGrpClass(grpClass.idGrp);
                        await _fetchData();
                      },
                    ),*/
                  IconButton(
                      icon: Icon(Icons.info, color: Color(0XFF5C5792)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                StudentsPage(groupeId: '${grpClass.idGrp}'),
                          ),
                        );
                      }),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Color(0XFF5C5792)),
                    onPressed: () async =>
                        await _grpClassService.deleteGrpClass(grpClass.idGrp),
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

class GrpClassService {
  final String baseUrl = 'http://localhost:8084';

  Future<List<GrpClass>> getAllGrpClasses() async {
    print('Fetching all GrpClasses...');
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Grpclasses/retrieve-all-GrpClasses'),
        headers: {'Content-Type': 'application/json'},
      );

      print('GrpClasses Response Status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        print('Successfully fetched ${jsonData.length} GrpClasses');

        final grpClasses = jsonData
            .map((json) {
              try {
                return GrpClass.fromJson(json as Map<String, dynamic>);
              } catch (e) {
                print('Error parsing individual GrpClass: $e');
                print('Problematic JSON: $json');
                return null;
              }
            })
            .where((grpClass) => grpClass != null)
            .toList();

        return grpClasses.cast<GrpClass>();
      } else {
        throw Exception('Failed to load GrpClasses: ${response.body}');
      }
    } catch (e) {
      print('Error fetching GrpClasses: $e');
      throw Exception('Failed to fetch GrpClasses: $e');
    }
  }

  Future<List<Emploi>> getEmploiForGrpClass(String grpClassId) async {
    print('Fetching Emploi for GrpClass ID: $grpClassId');
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/emplois'),
        headers: {'Content-Type': 'application/json'},
      );

      print('Emplois Response Status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonData =
            json.decode(response.body) as List<dynamic>;

        // Filter and map the emplois that contain courses for the specified group
        List<Emploi> emplois = jsonData
            .map((emploiJson) {
              Emploi emploi = Emploi.fromJson(emploiJson);

              // Filter courses for the specific group
              if (emploi.cours != null) {
                emploi.cours!.removeWhere(
                    (cours) => cours?.grpClass?.idGrp != grpClassId);
              }

              return emploi;
            })
            .where((emploi) => emploi.cours?.isNotEmpty == true)
            .toList();

        return emplois;
      }

      throw Exception('Failed to load emplois: ${response.statusCode}');
    } catch (e) {
      print('Error fetching Emploi: $e');
      throw Exception('Failed to fetch Emploi: $e');
    }
  }

  Future<List<Etudiant>> getEtudiantsForGrpClass(String grpClassId) async {
    print('Fetching students for GrpClass ID: $grpClassId');
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Grpclasses/grpClass/$grpClassId/etudiants'),
        headers: {'Content-Type': 'application/json'},
      );

      print('Students Response Status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        if (response.body == 'null') return [];

        final List<dynamic> jsonData =
            json.decode(response.body) as List<dynamic>;
        return jsonData.map((json) => Etudiant.fromJson(json)).toList();
      }
      throw Exception('Failed to load students: ${response.statusCode}');
    } catch (e) {
      print('Error fetching students: $e');
      throw Exception('Failed to fetch students: $e');
    }
  }

  Future<void> deleteGrpClass(String id) async {
    final url = 'http://localhost:8084/Grpclasses/delete/$id';
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete GrpClass. Error: ${response.body}');
    }
  }
}

class GrpClass {
  final String idGrp;
  final String nom;
  final List<dynamic>? etudiants;
  final String? specialite;
  final Filiere? filiere;
  final Emploi? emploi;
  final Admin? admin;
  final List<dynamic>? cours;

  GrpClass({
    required this.idGrp,
    required this.nom,
    this.etudiants,
    this.specialite,
    this.filiere,
    this.emploi,
    this.admin,
    this.cours,
  });

  factory GrpClass.fromJson(Map<String, dynamic> json) {
    try {
      return GrpClass(
        idGrp: json['idGrp']?.toString() ?? '',
        nom: json['nom']?.toString() ?? '',
        etudiants: json['etudiants'] as List<dynamic>?, // Keep as dynamic list
        specialite: json['specialite']?.toString(),
        filiere: json['filiere'] != null
            ? Filiere.fromJson(json['filiere'] as Map<String, dynamic>)
            : null,
        emploi: json['emploi'] != null
            ? Emploi.fromJson(json['emploi'] as Map<String, dynamic>)
            : null,
        admin: json['admin'] != null
            ? Admin.fromJson(json['admin'] as Map<String, dynamic>)
            : null,
        cours: json['cours'] as List<dynamic>?, // Keep as dynamic list
      );
    } catch (e) {
      print('Error parsing GrpClass: $e');
      print('JSON data: $json');
      rethrow;
    }
  }
  static GrpClass defaultInstance() {
    return GrpClass(idGrp: '', nom: 'Default Group');
  }
}

// lib/models/matiere.dart
class Matiere {
  final String idMatiere;
  final String nom;
  final int semestre;
  final int niveau;

  Matiere({
    required this.idMatiere,
    required this.nom,
    required this.semestre,
    required this.niveau,
  });

  factory Matiere.fromJson(Map<String, dynamic> json) {
    return Matiere(
      idMatiere: json['idMatiere'] as String,
      nom: json['nom'] as String,
      semestre: json['semestre'] as int,
      niveau: json['niveau'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idMatiere': idMatiere,
      'nom': nom,
      'semestre': semestre,
      'niveau': niveau,
    };
  }

  static Matiere defaultInstance() {
    return Matiere(
        idMatiere: '', nom: 'Default Matiere', semestre: 0, niveau: 0);
  }
}

class Reclamation {
  final String text;
  final String date;
  final bool isLu;
  final StatutReclamation statut;
  final Enseignant enseignant;
  //final Admin admin;

  Reclamation({
    required this.text,
    required this.date,
    required this.isLu,
    required this.statut,
    required this.enseignant,
    //required this.admin,
  });

  factory Reclamation.fromJson(Map<String, dynamic> json) {
    return Reclamation(
      text: json['text'],
      date: json['date'],
      isLu: json['isLu'],
      statut: StatutReclamation.values.firstWhere(
          (e) => e.toString() == 'StatutReclamation.' + json['statut']),
      enseignant: Enseignant.fromJson(json['enseignant']),
      //admin: Admin.fromJson(json['admin']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'date': date,
      'isLu': isLu,
      'statut': statut.toString().split('.').last,
      'enseignant': enseignant.toJson(),
      //'admin': admin.toJson(),
    };
  }
}

enum StatutReclamation {
  ACCEPTEE,
  REFUSEE,
  EN_ATTENTE,
}

// In your Modeles.dart, update the Salle class:
class Salle {
  final String idSalle;
  final String type;
  final String nom;
  final int capacite;
  final bool isDispo;
  final List<Matiere> matieres;
  final List<Datee> datees;
  final Admin? admin;
  final Emploi? emploi;
  final List<Voeux> voeux;
  final List<Cours> cours;

  Salle({
    required this.idSalle,
    required this.type,
    required this.nom,
    required this.capacite,
    required this.isDispo,
    required this.matieres,
    required this.datees,
    this.admin,
    this.emploi,
    required this.voeux,
    required this.cours,
  });

  factory Salle.fromJson(Map<String, dynamic> json) {
    return Salle(
      idSalle: json['idSalle']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      nom: json['nom']?.toString() ?? '',
      capacite: int.tryParse(json['capacite']?.toString() ?? '0') ?? 0,
      isDispo: json['isDispo'] as bool? ?? false,
      matieres: (json['matieres'] as List<dynamic>? ?? [])
          .map((item) => Matiere.fromJson(item as Map<String, dynamic>))
          .toList(),
      datees: (json['datees'] as List<dynamic>? ?? [])
          .map((item) => Datee.fromJson(item as Map<String, dynamic>))
          .toList(),
      admin: json['admin'] != null
          ? Admin.fromJson(json['admin'] as Map<String, dynamic>)
          : null,
      emploi: json['emploi'] != null
          ? Emploi.fromJson(json['emploi'] as Map<String, dynamic>)
          : null,
      voeux: (json['voeux'] as List<dynamic>? ?? [])
          .map((item) => Voeux.fromJson(item as Map<String, dynamic>))
          .toList(),
      cours: (json['cours'] as List<dynamic>? ?? [])
          .map((item) => Cours.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idSalle': idSalle,
      'type': type,
      'nom': nom,
      'capacite': capacite,
      'isDispo': isDispo,
      'matieres': matieres.map((item) => item.toJson()).toList(),
      'datees': datees.map((item) => item.toJson()).toList(),
      'admin': admin?.toJson(),
      'emploi': emploi?.toJson(),
      'voeux': voeux.map((item) => item.toJson()).toList(),
    };
  }
}

// lib/models/specialite.dart
class Specialite {
  final String nom;
  final String description;

  Specialite({
    required this.nom,
    required this.description,
  });

  factory Specialite.fromJson(Map<String, dynamic> json) {
    return Specialite(
      nom: json['nom'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'description': description,
    };
  }
}

class User {
  final String idUser;
  late final String nom;
  final String prenom;
  final String dateNaissance;
  final String email;
  final int? cin;
  final String telephone;
  final String login;
  final String motDePasse;

  User({
    required this.idUser,
    required this.nom,
    required this.prenom,
    required this.dateNaissance,
    required this.email,
    required this.cin,
    required this.telephone,
    required this.login,
    required this.motDePasse,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      idUser: json['idUser'],
      nom: json['nom'],
      prenom: json['prenom'],
      dateNaissance: json['dateNaissance'],
      email: json['email'],
      cin: json['cin'],
      telephone: json['telephone'],
      login: json['login'],
      motDePasse: json['motDePasse'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idUser': idUser,
      'nom': nom,
      'prenom': prenom,
      'dateNaissance': dateNaissance,
      'email': email,
      'cin': cin,
      'telephone': telephone,
      'login': login,
      'motDePasse': motDePasse,
    };
  }
}

class Voeux {
  String? idVoeu;
  String? datee;
  String? matiere;
  String? enseignant;
  String? salle;
  String? admin;
  String typeVoeu;
  String dateSoumission;
  int priorite;
  String etat;
  String? commentaire;

  // Constructeur
  Voeux({
    this.idVoeu,
    this.datee,
    this.matiere,
    this.enseignant,
    this.salle,
    this.admin,
    required this.typeVoeu,
    required this.dateSoumission,
    required this.priorite,
    required this.etat,
    this.commentaire,
  });

  // Méthode fromJson
  factory Voeux.fromJson(Map<String, dynamic> json) {
    return Voeux(
      idVoeu: json['idVoeu'],
      datee: json['datee'],
      matiere: json['matiere'],
      enseignant: json['enseignant'],
      salle: json['salle'],
      admin: json['admin'],
      typeVoeu: json['typeVoeu'],
      dateSoumission: json['dateSoumission'],
      priorite: json['priorite'],
      etat: json['etat'],
      commentaire: json['commentaire'],
    );
  }

  // Méthode toJson
  Map<String, dynamic> toJson() => {
        "idVoeu": idVoeu,
        "datee": datee,
        "matiere": matiere,
        "enseignant": enseignant,
        "salle": salle,
        "admin": admin,
        "typeVoeu": typeVoeu,
        "dateSoumission": dateSoumission,
        "priorite": priorite,
        "etat": etat,
        "commentaire": commentaire,
      };
}

// lib/models/admin.dart
class Admin extends User {
  final String role;
  final List<Reclamation> reclamations;
  final List<Voeux> voeux;
  final List<Salle> salles;
  final List<Matiere> matieres;
  final List<Specialite> specialites;
  final List<Filiere> filieres;
  final List<Etudiant> etudiants;
  final List<Emploi> emplois;
  final List<GrpClass> grpClasses;
  final List<Enseignant> enseignants;
  Admin({
    required super.idUser,
    required super.nom,
    required super.prenom,
    required super.dateNaissance,
    required super.email,
    required super.cin,
    required super.telephone,
    required super.login,
    required super.motDePasse,
    required this.role,
    this.reclamations = const [],
    this.voeux = const [],
    this.salles = const [],
    this.matieres = const [],
    this.specialites = const [],
    this.filieres = const [],
    this.etudiants = const [],
    this.emplois = const [],
    this.grpClasses = const [],
    this.enseignants = const [],
  });

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      idUser: json['idUser'],
      nom: json['nom'],
      prenom: json['prenom'],
      dateNaissance: json['dateNaissance'],
      email: json['email'],
      cin: json['cin'],
      telephone: json['telephone'],
      login: json['login'],
      motDePasse: json['motDePasse'],
      role: json['role'],
      reclamations: (json['reclamations'] as List?)
              ?.map((e) => Reclamation.fromJson(e))
              .toList() ??
          [],
      voeux: (json['voeux'] as List?)?.map((e) => Voeux.fromJson(e)).toList() ??
          [],
      salles:
          (json['salles'] as List?)?.map((e) => Salle.fromJson(e)).toList() ??
              [],
      matieres: (json['matieres'] as List?)
              ?.map((e) => Matiere.fromJson(e))
              .toList() ??
          [],
      specialites: (json['specialites'] as List?)
              ?.map((e) => Specialite.fromJson(e))
              .toList() ??
          [],
      filieres: (json['filieres'] as List?)
              ?.map((e) => Filiere.fromJson(e))
              .toList() ??
          [],
      etudiants: (json['etudiants'] as List?)
              ?.map((e) => Etudiant.fromJson(e))
              .toList() ??
          [],
      emplois:
          (json['emplois'] as List?)?.map((e) => Emploi.fromJson(e)).toList() ??
              [],
      grpClasses: (json['grpClasses'] as List?)
              ?.map((e) => GrpClass.fromJson(e))
              .toList() ??
          [],
      enseignants: (json['enseignants'] as List?)
              ?.map((e) => Enseignant.fromJson(e))
              .toList() ??
          [],
    );
  }
}

// lib/models/cours.dart
class Cours {
  final String idCours;
  final Matiere matiere;
  final Enseignant enseignant;
  final GrpClass grpClass;
  final Emploi? emploi;

  Cours({
    required this.idCours,
    required this.matiere,
    required this.enseignant,
    required this.grpClass,
    this.emploi,
  });

  factory Cours.fromJson(Map<String, dynamic> json) {
    return Cours(
      idCours: json['idCours']?.toString() ?? '',
      matiere: json['matiere'] != null
          ? Matiere.fromJson(json['matiere'])
          : Matiere.defaultInstance(),
      enseignant: json['enseignant'] != null
          ? Enseignant.fromJson(json['enseignant'])
          : Enseignant.defaultInstance(),
      grpClass: json['grpClass'] != null
          ? GrpClass.fromJson(json['grpClass'])
          : GrpClass.defaultInstance(),
      emploi: json['emploi'] != null ? Emploi.fromJson(json['emploi']) : null,
    );
  }
}

// lib/models/datee.dart
class Datee {
  String? idDate; // Matches the MongoDB ID type
  String? jour;
  String? heure;
  List<Voeux>? voeux; // Reference to the list of Voeux
  List<Salle>? salles; // Reference to the list of Salles

  Datee({
    this.idDate,
    this.jour,
    this.heure,
    this.voeux,
    this.salles,
  });

  // Factory constructor to create an instance from a JSON object
  factory Datee.fromJson(Map<String, dynamic> json) {
    return Datee(
      idDate: json['idDate'] as String?,
      jour: json['jour'] as String?,
      heure: json['heure'] as String?,
      voeux: (json['voeux'] as List<dynamic>?)
          ?.map((item) => Voeux.fromJson(item as Map<String, dynamic>))
          .toList(),
      salles: (json['salles'] as List<dynamic>?)
          ?.map((item) => Salle.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  // Method to convert the instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'idDate': idDate,
      'jour': jour,
      'heure': heure,
      'voeux': voeux?.map((item) => item.toJson()).toList(),
      'salles': salles?.map((item) => item.toJson()).toList(),
    };
  }
}

// lib/models/emploi.dart
class Emploi {
  final String idEmploi;
  final String? typeEmploi;
  final String? jour;
  final String? heureDebut;
  final String? heureFin;
  final List<Enseignant> enseignants;
  final List<Salle> salles;
  final List<GrpClass> groupeClasse;
  final List<Cours?> cours;
  final Admin? admin;

  Emploi({
    required this.idEmploi,
    this.typeEmploi,
    this.jour,
    this.heureDebut,
    this.heureFin,
    this.enseignants = const [],
    this.salles = const [],
    this.groupeClasse = const [],
    this.cours = const [],
    this.admin,
  });

  factory Emploi.fromJson(Map<String, dynamic> json) {
    try {
      return Emploi(
        idEmploi: json['idEmploi']?.toString() ?? '',
        typeEmploi: json['typeEmploi']?.toString(),
        jour: json['jour']?.toString(),
        heureDebut: json['heureDebut']?.toString(),
        heureFin: json['heureFin']?.toString(),
        enseignants: (json['enseignants'] as List<dynamic>?)
                ?.map((e) => Enseignant.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        salles: (json['salles'] as List<dynamic>?)
                ?.map((e) => Salle.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        groupeClasse: (json['grpClasses'] as List<dynamic>?)
                ?.map((e) => GrpClass.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        cours: (json['cours'] as List<dynamic>?)
                ?.map((e) => Cours.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        admin: json['admin'] != null
            ? Admin.fromJson(json['admin'] as Map<String, dynamic>)
            : null,
      );
    } catch (e) {
      print('Error parsing Emploi JSON: $e');
      print('Problematic JSON: $json');
      rethrow;
    }
  }
  // Getter for first salle
  Salle? get salle => salles.isNotEmpty ? salles.first : null;

  toJson() {}
}

class Enseignant extends User {
  final int nbHeure;
  final Grade? grade;
  final List<Matiere>? matieres;
  final Admin? admin;
  final List<Cours>? cours;
  final List<Filiere>? filieres;
  final List<Specialite>? specialites;
  final List<Reclamation>? reclamations;
  final Emploi? emploi;
  final List<Voeux>? voeux;

  Enseignant({
    required super.idUser,
    required super.nom,
    required super.prenom,
    required super.dateNaissance,
    required super.email,
    required super.cin,
    required super.telephone,
    required super.login,
    required super.motDePasse,
    required this.nbHeure,
    this.grade,
    this.matieres,
    this.admin,
    this.cours,
    this.filieres,
    this.specialites,
    this.reclamations,
    this.emploi,
    this.voeux,
  });

  factory Enseignant.fromJson(Map<String, dynamic> json) {
    return Enseignant(
      idUser: json['idUser'] ?? '',
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      dateNaissance: json['dateNaissance'] ?? '',
      email: json['email'] ?? '',
      cin: json['cin'],
      telephone: json['telephone'] ?? '',
      login: json['login'] ?? '',
      motDePasse: json['motDePasse'] ?? '',
      nbHeure: json['nbHeure'] ?? 0,
      grade: json['grade'] != null
          ? Grade.values.firstWhere(
              (e) => e.toString() == 'Grade.${json['grade']}',
              orElse: () => Grade.A)
          : null,
      matieres: json['matieres'] != null
          ? (json['matieres'] as List).map((e) => Matiere.fromJson(e)).toList()
          : [],
      admin: json['admin'] != null ? Admin.fromJson(json['admin']) : null,
      cours: json['cours'] != null
          ? (json['cours'] as List).map((e) => Cours.fromJson(e)).toList()
          : [],
      filieres: json['filieres'] != null
          ? (json['filieres'] as List).map((e) => Filiere.fromJson(e)).toList()
          : [],
      specialites: json['specialites'] != null
          ? (json['specialites'] as List)
              .map((e) => Specialite.fromJson(e))
              .toList()
          : [],
      reclamations: json['reclamations'] != null
          ? (json['reclamations'] as List)
              .map((e) => Reclamation.fromJson(e))
              .toList()
          : [],
      emploi: json['emploi'] != null ? Emploi.fromJson(json['emploi']) : null,
      voeux: json['voeux'] != null
          ? (json['voeux'] as List).map((e) => Voeux.fromJson(e)).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idUser': idUser,
      'nom': nom,
      'prenom': prenom,
      'dateNaissance': dateNaissance,
      'email': email,
      'cin': cin,
      'telephone': telephone,
      'login': login,
      'motDePasse': motDePasse,
      'nbHeure': nbHeure,
      'grade': grade?.toString().split('.').last,
      'matieres': matieres?.map((e) => e.toJson()).toList(),
      'admin': admin?.toJson(),
      'specialites': specialites?.map((e) => e.toJson()).toList(),
      'reclamations': reclamations?.map((e) => e.toJson()).toList(),
      'emploi': emploi?.toJson(),
      'voeux': voeux?.map((e) => e.toJson()).toList(),
    };
  }

  static Enseignant defaultInstance() {
    return Enseignant(
        idUser: '',
        nom: 'Default Enseignant',
        prenom: '',
        dateNaissance: '',
        cin: 0,
        email: '',
        telephone: '',
        login: '',
        motDePasse: '',
        nbHeure: 0);
  }
}

class Etudiant extends User {
  final int niveau;
  final GrpClass grpClass;
  final Admin? admin;

  Etudiant({
    required super.idUser,
    required super.nom,
    required super.prenom,
    required super.dateNaissance,
    required super.email,
    required super.cin,
    required super.telephone,
    required super.login,
    required super.motDePasse,
    required this.niveau,
    required this.grpClass,
    this.admin,
  });

  factory Etudiant.fromJson(Map<String, dynamic> json) {
    return Etudiant(
      idUser: json['idUser']?.toString() ?? '',
      nom: json['nom']?.toString() ?? 'Unknown',
      prenom: json['prenom']?.toString() ?? 'Unknown',
      dateNaissance: json['dateNaissance']?.toString() ?? '2000-01-01',
      email: json['email']?.toString() ?? '',
      cin: int.tryParse(json['cin']?.toString() ?? '0') ??
          0, // Convert string to int
      telephone: json['telephone']?.toString() ?? '00000000',
      login: json['login']?.toString() ?? 'default_login',
      motDePasse: json['motDePasse']?.toString() ?? '',
      niveau: int.tryParse(json['niveau']?.toString() ?? '0') ??
          0, // Parse string to int
      grpClass: json['grpClass'] != null
          ? GrpClass.fromJson(json['grpClass'] as Map<String, dynamic>)
          : GrpClass.defaultInstance(),
      admin: json['admin'] != null
          ? Admin.fromJson(json['admin'] as Map<String, dynamic>)
          : null,
    );
  }
}

class Filiere {
  final String idFiliere;
  final String? nom;
  final List<dynamic>? enseignants;
  final Admin? admin;

  Filiere({
    required this.idFiliere,
    this.nom,
    this.enseignants,
    this.admin,
  });

  factory Filiere.fromJson(Map<String, dynamic> json) {
    try {
      return Filiere(
        idFiliere: json['idFiliere']?.toString() ?? '',
        nom: json['nom']?.toString(),
        enseignants:
            json['enseignants'] as List<dynamic>?, // Keep as dynamic list
        admin: json['admin'] != null
            ? Admin.fromJson(json['admin'] as Map<String, dynamic>)
            : null,
      );
    } catch (e) {
      print('Error parsing Filiere: $e');
      print('JSON data: $json');
      rethrow;
    }
  }
}

// lib/models/grade.dart
enum Grade {
  A,
  B,
  C,
}

extension GradeExtension on Grade {
  String get description {
    switch (this) {
      case Grade.A:
        return 'Excellent';
      case Grade.B:
        return 'Good';
      case Grade.C:
        return 'Average';
      default:
        return '';
    }
  }
}

class GradeModel {
  final Grade grade;
  final String description;

  GradeModel({
    required this.grade,
    required this.description,
  });

  factory GradeModel.fromJson(Map<String, dynamic> json) {
    return GradeModel(
      grade: Grade.values
          .firstWhere((e) => e.toString() == 'Grade.' + json['grade']),
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'grade': grade.toString().split('.').last, // Extraire la valeur de l'énum
      'description': description,
    };
  }
}

class AuthResponse {
  final String role;
  final String id;

  AuthResponse({
    required this.role,
    required this.id,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      role: json['role'] ?? '',
      id: json['id'] ?? '',
    );
  }
}
