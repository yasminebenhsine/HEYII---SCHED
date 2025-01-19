import 'package:flutter/material.dart';
import 'package:heyiisched/Dashbord/calendrier_enseignant/AddEnseignantPage.dart';
import 'package:heyiisched/Dashbord/calendrier_enseignant/DetailEnseignantPage.dart';
import 'package:heyiisched/models/Modeles.dart';
import 'package:heyiisched/services/EnseignantService.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:heyiisched/Dashbord/details/VoeuxListPage.dart';

import 'package:shared_preferences/shared_preferences.dart';

class EnseignantListPage extends StatefulWidget {
  @override
  _EnseignantListPageState createState() => _EnseignantListPageState();
}

class _EnseignantListPageState extends State<EnseignantListPage> {
  late Future<List<Enseignant>> _enseignants;
  final EnseignantService _enseignantService = EnseignantService();
  final reclamationService _reclamationService = reclamationService();

  @override
  void initState() {
    super.initState();
    _enseignants = _enseignantService.fetchEnseignants();
  }

  void _viewReclamations(Enseignant enseignant) async {
    try {
      final reclamations = await _reclamationService
          .fetchReclamationsForEnseignant(enseignant.id);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title:
                Text('Réclamations de ${enseignant.nom} ${enseignant.prenom}'),
            content: Container(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: reclamations.length,
                itemBuilder: (context, index) {
                  final reclamation = reclamations[index];
                  return Card(
                    child: ListTile(
                      title: Text('Sujet: ${reclamation.sujet}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Description: ${reclamation.text}'),
                          Text(
                              'Date: ${reclamation.formattedDate}'), // Using the safe getter
                          Text('Statut: ${reclamation.statut}'),
                          Text('Lu: ${reclamation.lu ? 'Oui' : 'Non'}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                child: Text('Fermer'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors du chargement des réclamations: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Méthode pour supprimer un enseignant
  void _deleteEnseignant(String id) async {
    await _enseignantService.deleteEnseignant(id);
    setState(() {
      _enseignants =
          _enseignantService.fetchEnseignants(); // Rafraîchir la liste
    });
  }

  Future<void> _viewVoeux(Enseignant enseignant) async {
    try {
      // Save the enseignant ID
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('selectedEnseignantId', enseignant.id);

      // Navigate to VoeuxListPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => VoeuxListPage(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving selected enseignant: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Enseignant'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, '/admin/dashboard');
          },
        ),
        backgroundColor: Color.fromARGB(255, 129, 123, 194),
      ),
      body: FutureBuilder<List<Enseignant>>(
        future: _enseignants,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucun enseignant trouvé.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Enseignant enseignant = snapshot.data![index];
                return ListTile(
                  title: Text('${enseignant.nom} ${enseignant.prenom}'),
                  subtitle: Text(enseignant.email),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Add button to view reclamations
                      IconButton(
                        icon: Icon(
                          Icons.message,
                          color: Color.fromARGB(255, 129, 123, 194),
                        ),
                        onPressed: () => _viewReclamations(enseignant),
                      ),
                      /* IconButton(
                        icon: Icon(Icons.list_alt,
                            color: Color.fromARGB(255, 129, 123, 194)),
                        onPressed: () => _viewVoeux(enseignant),
                      ),*/
                      IconButton(
                        icon: Icon(Icons.info,
                            color: Color.fromARGB(255, 129, 123, 194)),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailEnseignantPage(
                                  enseignantId: enseignant.id),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete,
                            color: Color.fromARGB(255, 129, 123, 194)),
                        onPressed: () {
                          _deleteEnseignant(enseignant.id);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    AddEnseignantPage(onAdd: _onEnseignantAdded)),
          );
        },
      ),
    );
  }

  void _onEnseignantAdded() {
    setState(() {
      _enseignants = _enseignantService.fetchEnseignants();
    });
  }
}

class reclamationService {
  final String baseUrl = 'http://192.168.56.1:8084/api/reclamations';

  Future<List<Reclamation>> fetchReclamations() async {
    final response = await http.get(Uri.parse('$baseUrl/all'));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Reclamation.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch reclamations');
    }
  }

  Future<List<Reclamation>> fetchReclamationsForEnseignant(
      String enseignantId) async {
    final allReclamations = await fetchReclamations();
    return allReclamations
        .where((reclamation) => reclamation.enseignant?.id == enseignantId)
        .toList();
  }

  Future<Reclamation> createReclamation(Reclamation reclamation) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(reclamation.toJson()),
    );

    if (response.statusCode == 201) {
      return Reclamation.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create reclamation');
    }
  }
}

class Reclamation {
  final String idReclamation;
  final String text;
  final DateTime? date; // Made nullable
  final String sujet;
  final String statut;
  final Enseignant? enseignant;
  final Admin? admin;
  final bool lu;

  Reclamation({
    required this.idReclamation,
    required this.text,
    this.date, // Made optional
    required this.sujet,
    required this.statut,
    this.enseignant,
    this.admin,
    required this.lu,
  });

  factory Reclamation.fromJson(Map<String, dynamic> json) {
    DateTime? parsedDate;
    if (json['date'] != null) {
      try {
        // Try parsing the date string
        parsedDate = DateTime.parse(json['date'].toString());
      } catch (e) {
        // If parsing fails, try alternative format or leave as null
        try {
          // Try parsing with a different format if needed
          // For example, if date comes in a different format, you could handle it here
          parsedDate = null;
        } catch (e) {
          parsedDate = null;
        }
      }
    }

    return Reclamation(
      idReclamation: json['idReclamation'] ?? '',
      text: json['text'] ?? '',
      date: parsedDate, // Use the safely parsed date
      sujet: json['sujet'] ?? '',
      statut: json['statut'] ?? 'EN_ATTENTE',
      enseignant: json['enseignant'] != null
          ? Enseignant.fromJson(json['enseignant'])
          : null,
      admin: json['admin'] != null ? Admin.fromJson(json['admin']) : null,
      lu: json['lu'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idReclamation': idReclamation,
      'text': text,
      'date': date?.toIso8601String(), // Only convert if date exists
      'sujet': sujet,
      'statut': statut,
      'enseignant': enseignant?.toJson(),
      'admin': admin?.toJson(),
      'lu': lu,
    };
  }

  // Formatted date string getter
  String get formattedDate {
    if (date == null) return 'Date non disponible';
    try {
      return '${date?.day}/${date?.month}/${date?.year}';
    } catch (e) {
      return 'Date non disponible';
    }
  }
}
/*
class EnseignantListPage extends StatefulWidget {
  @override
  _EnseignantListPageState createState() => _EnseignantListPageState();
}

class _EnseignantListPageState extends State<EnseignantListPage> {
  late Future<List<Enseignant>> _enseignants;
  final EnseignantService _enseignantService = EnseignantService();

  @override
  void initState() {
    super.initState();
    _enseignants = _enseignantService.fetchEnseignants();
  }

  // Méthode pour supprimer un enseignant
  void _deleteEnseignant(String id) async {
    await _enseignantService.deleteEnseignant(id);
    setState(() {
      _enseignants = _enseignantService.fetchEnseignants();  // Rafraîchir la liste
    });
  }
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Liste des Enseignants'),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pushNamed(context, '/admin/dashboard'); 
        },
      ),
    ),
    body: FutureBuilder<List<Enseignant>>(
      future: _enseignants,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erreurrr: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Aucun enseignant trouvé.'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Enseignant enseignant = snapshot.data![index];
              return ListTile(
                title: Text('${enseignant.nom} ${enseignant.prenom}'),
                subtitle: Text(enseignant.email),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.info),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailEnseignantPage(enseignantId: enseignant.id),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deleteEnseignant(enseignant.id);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        }
      },
    ),
    floatingActionButton: FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddEnseignantPage(onAdd: _onEnseignantAdded)),
        );
      },
    ),
  );
}

// Méthode appelée après l'ajout d'un enseignant
void _onEnseignantAdded() {
  setState(() {
    _enseignants = _enseignantService.fetchEnseignants();
  });
}

}
*/