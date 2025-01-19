import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:heyiisched/Dashbord/details/StudentsPage.dart';
import 'package:heyiisched/models/Matiere_salle.dart';
import 'package:heyiisched/models/Modeles.dart';
import 'package:heyiisched/services/GrpClassService.dart';
import 'package:http/http.dart' as http;

class GrpClassService {
  Future<List<GrpClass>> fetchGrpClasses() async {
    final response = await http.get(Uri.parse(
        'http://192.168.56.1:8084/Grpclasses/retrieve-all-GrpClasses'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      print('Message du serveur: ${response.body}');

      return data.map((item) => GrpClass.fromJson(item)).toList();
    } else {
      print('Message du serveur: ${response.body}');
      print("errr");
      throw Exception('Échec de chargement des GrpClasses');
    }
  }

  Future<List<GrpClass>> getGrpClassesByEnseignant(String idEnseignant) async {
    final response = await http.get(Uri.parse(
        'http://192.168.56.1:8084/Grpclasses/enseignant/$idEnseignant'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => GrpClass.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load GrpClasses');
    }
  }

  Future<GrpClass> addGrpClass(GrpClass grpClass) async {
    final response = await http.post(
      Uri.parse('http://192.168.56.1:8084/Grpclasses/add'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(grpClass.toJson()),
    );

    if (response.statusCode == 201) {
      print('update ${response.body}');
      return GrpClass.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add GrpClass. Error: ${response.body}');
    }
  }

  Future<GrpClass> updateGrpClass(String id, GrpClass grpClass) async {
    if (id.isEmpty) {
      throw Exception('ID is empty');
    }

    final response = await http.put(
      Uri.parse('http://192.168.56.1:8084/Grpclasses/update/$id'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(grpClass.toJson()),
    );

    if (response.statusCode == 200) {
      return GrpClass.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      print('\n GrpClass not found. ID: $id');
      print(' Error: ${response.body}');
      throw Exception('GrpClass not found. ID: $id');
    } else {
      throw Exception('Failed to update GrpClass. Error: ${response.body}');
    }
  }

  Future<void> deleteGrpClass(String id) async {
    final url = 'http://192.168.56.1:8084/Grpclasses/delete/$id';
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete GrpClass. Error: ${response.body}');
    }
  }

  Future<List<Etudiant>> fetchStudentsByGrpClass(String idGrp) async {
    final response = await http.get(Uri.parse(
        'http://192.168.56.1:8084/Grpclasses/grpClass/$idGrp/etudiants'));

    if (response.statusCode == 200) {
      // Si la réponse est OK, parsez le JSON
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Etudiant.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load students');
    }
  }
}

class GroupClassesView extends StatefulWidget {
  @override
  _GroupClassesViewState createState() => _GroupClassesViewState();
}

class _GroupClassesViewState extends State<GroupClassesView> {
  final GrpClassService _apiService = GrpClassService();
  List<GrpClass> _grpClasses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() => _isLoading = true);
    _grpClasses = await _apiService.fetchGrpClasses();
    setState(() => _isLoading = false);
  }

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  void _showForm({GrpClass? grpClass}) {
    final TextEditingController nameController =
        TextEditingController(text: grpClass?.nom ?? "");
    final TextEditingController specialiteController =
        TextEditingController(text: grpClass?.specialite?.nom ?? "");
    final TextEditingController filiereController =
        TextEditingController(text: grpClass?.filiere.nom ?? "");

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(grpClass == null ? 'Ajouter Groupe' : 'Modifier Groupe'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Nom')),
              TextField(
                  controller: specialiteController,
                  decoration: InputDecoration(labelText: 'Spécialité')),
              TextField(
                  controller: filiereController,
                  decoration: InputDecoration(labelText: 'Filière')),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isEmpty ||
                    specialiteController.text.isEmpty ||
                    filiereController.text.isEmpty) {
                  Navigator.pop(context); // Close the dialog first
                  scaffoldMessengerKey.currentState?.showSnackBar(
                    SnackBar(
                        content: Text('Tous les champs doivent être remplis')),
                  );
                  return;
                }

                // Vérifier si idGrp est vide
                if (grpClass?.idGrp == null || grpClass!.idGrp.isEmpty) {
                  Navigator.pop(context); // Close the dialog if ID is empty
                  scaffoldMessengerKey.currentState?.showSnackBar(
                    SnackBar(content: Text('L\'ID du groupe est vide')),
                  );
                  return;
                }

                final newGrpClass = GrpClass(
                  idGrp: grpClass?.idGrp ?? '',
                  nom: nameController.text,
                  specialite: Specialite(
                    nom: specialiteController.text,
                    description: grpClass?.specialite?.description ?? '',
                  ),
                  filiere: Filiere(
                    nom: filiereController.text,
                    idFiliere: grpClass?.filiere.idFiliere ?? '',
                    enseignants: grpClass?.filiere.enseignants ?? [],
                  ),
                  etudiants: grpClass?.etudiants ?? [],
                  emploi: grpClass?.emploi ??
                      Emploi(
                        typeEmploi: grpClass?.emploi?.typeEmploi ?? '',
                        heureDebut: grpClass?.emploi?.heureDebut ?? '',
                        heureFin: grpClass?.emploi?.heureFin ?? '',
                        jour: grpClass?.emploi?.jour ?? '',
                        enseignant: grpClass?.emploi?.enseignant ?? [],
                        salles: grpClass?.emploi?.salles ?? [],
                        groupeClasse: grpClass?.emploi?.groupeClasse ?? [],
                        matiere: Matiere(
                          nom: grpClass?.emploi?.matiere.nom ?? '',
                          enseignants:
                              grpClass?.emploi?.matiere.enseignants ?? [],
                          voeux: grpClass?.emploi?.matiere.voeux ?? [],
                          id: grpClass?.emploi?.matiere.id ?? '',
                          type: grpClass?.emploi?.matiere.type ?? '',
                          salles: grpClass?.emploi?.matiere.salles ?? [],
                          specialites:
                              grpClass?.emploi?.matiere.specialites ?? [],
                          niveau: grpClass?.emploi?.matiere.niveau ?? 1,
                          cours: grpClass?.emploi?.matiere.cours ?? [],
                        ),
                      ),
                  admin: grpClass?.admin ??
                      Admin(
                        prenom: '',
                        nom: '',
                        login: '',
                        email: '',
                        motDePasse: '',
                        telephone: '',
                        cin: '',
                        dateNaissance: '',
                        role: '',
                      ),
                  cours: grpClass?.cours ?? [],
                );

                try {
                  if (grpClass == null) {
                    await _apiService.addGrpClass(newGrpClass);
                  } else {
                    await _apiService.updateGrpClass(
                        grpClass.idGrp, newGrpClass);
                  }
                  await _fetchData();
                  Navigator.pop(context); // Close the dialog after success
                  scaffoldMessengerKey.currentState?.showSnackBar(
                    SnackBar(
                        content: Text(grpClass == null
                            ? 'Groupe ajouté avec succès'
                            : 'Groupe mis à jour avec succès')),
                  );
                } catch (e) {
                  Navigator.pop(
                      context); // Close the dialog if there's an error
                  scaffoldMessengerKey.currentState?.showSnackBar(
                    SnackBar(content: Text('Erreur: ${e.toString()}')),
                  );
                }
              },
              child: Text(grpClass == null ? 'Ajouter' : 'Modifier'),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldMessengerKey, // Ajoutez cette ligne
      // AppBar(title: Text('Groupes de Classes')),
      appBar: AppBar(
        title: const Text('Groupes de Classes'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(
                context, '/admin/dashboard'); // Retour à AdminDashboard
          },
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _grpClasses.length,
              itemBuilder: (context, index) {
                final grpClass = _grpClasses[index];
                return ListTile(
                  title: Text(grpClass.nom),
                  subtitle: Text(
                      '${grpClass.filiere.nom} - ${grpClass.specialite?.nom}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
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
                      ),
                      IconButton(
                        icon: Icon(Icons.info),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  StudentsPage(groupeId: '${grpClass.idGrp}'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
