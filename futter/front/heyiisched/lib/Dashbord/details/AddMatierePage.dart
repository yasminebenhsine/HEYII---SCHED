import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:heyiisched/models/specialite.dart';
import 'package:uuid/uuid.dart';
// Import du modèle Matiere

class AddMatierePage extends StatefulWidget {
  @override
  _AddMatierePageState createState() => _AddMatierePageState();
}

class _AddMatierePageState extends State<AddMatierePage> {
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _semestreController = TextEditingController();
  final TextEditingController _niveauController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter une Matière'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nomController,
              decoration: InputDecoration(labelText: 'Nom de la matière'),
            ),
            TextField(
              controller: _typeController,
              decoration: InputDecoration(labelText: 'Type'),
            ),
            TextField(
              controller: _semestreController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Semestre'),
            ),
            TextField(
              controller: _niveauController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Niveau'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Validation des champs
                if (_nomController.text.isEmpty ||
                    _typeController.text.isEmpty ||
                    _semestreController.text.isEmpty ||
                    _niveauController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Tous les champs doivent être remplis.'),
                    backgroundColor: Colors.red,
                  ));
                } else {
                  final matiere = Matiere(
                    idMatiere: '',
                    nom: _nomController.text,
                    type: _typeController.text,
                    semestre: int.tryParse(_semestreController.text) ?? 0,
                    niveau: int.tryParse(_niveauController.text) ?? 0,
                  );
                  addMatiere(matiere, context);
                }
              },
              child: Text('Ajouter Matière'),
            ),
          ],
        ),
      ),
    );
  }

  // Fonction pour ajouter la matière via HTTP


Future<void> addMatiere(Matiere matiere, BuildContext context) async {
  final url = 'http://192.168.56.1:8084/matiere/addMatiere';

  // Si idMatiere est vide, générer un ID unique
  String idMatiere = matiere.idMatiere.isEmpty ? Uuid().v4() : matiere.idMatiere;

  // Créer un objet JSON à envoyer
  final body = json.encode({
    'idMatiere': idMatiere,
    'nom': matiere.nom,
    'type': matiere.type,
    'semestre': matiere.semestre,
    'niveau': matiere.niveau,
  });

  // Afficher le body dans la console
  print('Body de la requête : $body');

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    // Vérification de la réponse du serveur
    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Matière ajoutée avec succès.')));
      Navigator.pop(context);  // Fermer la page courante après l'ajout
    } else {
      
      // Gestion des erreurs détaillées
      String errorMessage = 'Erreur lors de l\'ajout de la matière.';
      if (response.body.isNotEmpty) {
        errorMessage = json.decode(response.body)['message'] ?? errorMessage;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  } catch (error) {
    // Gestion des erreurs réseau
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur de connexion au serveur.')));
  }
}


}