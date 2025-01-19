import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:heyiisched/models/Matiere_salle.dart';
//import 'package:heyiisched/models/Matiere_salle.dart';
import 'package:heyiisched/models/Modeles.dart';

import 'package:heyiisched/services/EnseignantService.dart';
import 'package:heyiisched/services/Matiere.dart';
import 'package:heyiisched/services/voeuxProf.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AddVoeuxPage extends StatefulWidget {
  @override
  _AddVoeuxPageState createState() => _AddVoeuxPageState();
}

class _AddVoeuxPageState extends State<AddVoeuxPage> {
  final _formKey = GlobalKey<FormState>();
  final MatiereService matiereService = MatiereService();

  String? typeVoeu;
  DateTime? datee;
  Matiere? selectedMatiere;
  String? salle;
  int? priorite;
  String? commentaire;
  bool _isLoading = false;

  final List<String> typeVoeuxOptions = [
    "Demande de cours",
    "Disponibilités",
    "Changement de salle",
    "Ajout de matière",
    "Changement d'horaire",
  ];

  List<Matiere> matieres = [];

  @override
  void initState() {
    super.initState();
    _fetchMatieres(); // Charger les matières depuis la base de données
  }

  void _fetchMatieres() async {
    try {
      List<Matiere> fetchedMatieres = await matiereService.fetchMatieres();
      setState(() {
        matieres = fetchedMatieres;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors du chargement des matières.")),
      );
    }
  }

  void _saveUserData(String id, String nom, String prenom, String email) async {
    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode({
      'id': id,
      
      
    });
    await prefs.setString('userData', userData);
  }
  void _submitForm() async {
  if (_formKey.currentState!.validate()) {
    setState(() => _isLoading = true);

    // Sauvegarder les données du formulaire
    _formKey.currentState!.save();

    try {
      // Récupérer les détails de l'utilisateur depuis SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString('userData') ?? '{}'; // Défaut : chaîne JSON vide
      final Map<String, dynamic> userData = json.decode(userDataString);

      // Vérifier et récupérer l'ID utilisateur
      final String userId = userData['id'] ?? '';
      print('userId récupéré : $userId'); // Débogage

      if (userId.isEmpty) {
        print('Erreur : userId est vide');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Les données utilisateur sont incomplètes. Veuillez vous reconnecter."),
          ),
        );
        setState(() => _isLoading = false);
        return; // Arrêter l'exécution si les données sont incomplètes
      }

      // Récupérer les détails de l'enseignant via son ID
      Enseignant enseignant = await EnseignantService().fetchEnseignantById(userId);
      print('Enseignant récupéré: ${enseignant.nom}, ${enseignant.prenom}'); // Débogage

      // Construire les données du vœu
      var voeuxData = {
        'typeVoeu': typeVoeu,
        'date': datee != null ? datee!.toIso8601String() : '2025-01-03T19:33:08.913', // Format ISO-8601
        'matiere': selectedMatiere?.nom, // Nom de la matière
        'salle': salle,
        'priorite': priorite,
        'commentaire': commentaire,
        'enseignant': {
          'id': enseignant.id,
          'nom': enseignant.nom,
          'prenom': enseignant.prenom,
          'email': enseignant.email,
          'nbHeure': enseignant.nbHeure,
           'grade': enseignant.grade?.toString().split('.').last, // Ajout important
          'matieres': enseignant.matieres.map((matiere) => matiere.nom).toList(),
        },
      };

      print('Données de voeux à envoyer : $voeuxData'); // Débogage

      // Appeler le service pour ajouter le vœu dans la base de données
      await Voeuxprof.addVoeuxForEnseignant(voeuxData, enseignant.id);

      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vœu ajouté avec succès !")),
      );

      Navigator.pop(context); // Fermer la page après soumission
    } catch (e) {
      setState(() => _isLoading = false);
      print('Erreur lors de la soumission du formulaire: $e'); // Débogage
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Erreur lors de l'ajout du vœu. Veuillez vérifier les données."),
        ),
      );
    }
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Créer un Vœu"),backgroundColor: Color(0XFFBE9CC7),),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: "Type de Vœu"),
                  items: typeVoeuxOptions
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          ))
                      .toList(),
                  validator: (value) =>
                      value == null ? "Veuillez choisir un type de vœu" : null,
                  onChanged: (value) => setState(() => typeVoeu = value),
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<Matiere>(
                  decoration: InputDecoration(labelText: "Matière"),
                  items: matieres.map((matiere) {
                    return DropdownMenuItem(
                      value: matiere,
                      child: Text(matiere.nom),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => selectedMatiere = value),
                  validator: (value) =>
                      value == null ? "Veuillez choisir une matière" : null,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Salle"),
                  onSaved: (value) => salle = value,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Priorité (1-5)"),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Veuillez saisir la priorité";
                    }
                    final number = int.tryParse(value);
                    if (number == null || number < 1 || number > 5) {
                      return "La priorité doit être entre 1 et 5";
                    }
                    return null;
                  },
                  onSaved: (value) => priorite = int.parse(value!),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Commentaire"),
                  onSaved: (value) => commentaire = value,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  child: _isLoading
                      ? CircularProgressIndicator()
                      : Text("Soumettre"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/*
 void _submitForm() async {
  if (_formKey.currentState!.validate()) {
    setState(() => _isLoading = true);

    // Save form data
    _formKey.currentState!.save();

    try {
      // Retrieve user details from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString('userData') ?? '{}'; // Default to empty string if null
      final Map<String, dynamic> userData = json.decode(userDataString);

      // Safely access user data (with null checks)
      final String userId = userData['id'] ?? '';
     

      // Check if any of the user data fields are empty
      if (userId.isEmpty ) {
  // Log detailed information for debugging
    print('Error during form submission: Missing user data:');
    print('userId: $userId');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Les données utilisateur sont incomplètes. Veuillez vous reconnecter.")),
        );
        setState(() => _isLoading = false);
        return; // Exit early if the user data is incomplete
      }

      // Create Enseignant object
      var enseignantData = {
        'id': userId,
        
        // Add any other necessary information for the teacher
      };

      // Construct the Voeu data to send
      var voeuxData = {
        'typeVoeu': typeVoeu,
        'date': datee?.toIso8601String() ?? '', // Convert the date to ISO-8601 format
        'matiere': selectedMatiere?.nom, // Subject name
        'salle': salle,
        'priorite': priorite,
        'commentaire': commentaire,
        'enseignant': enseignantData, // Add the full Enseignant object
      };
      print('Error during form submission: $voeuxData');
      // Call service to add the Voeu to the database
      await Voeuxprof.addVoeux(voeuxData);

      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Vœu ajouté avec succès !")),
      );

      Navigator.pop(context); // Close the page after submission
    } catch (e) {
      setState(() => _isLoading = false);
      print('Error during form submission: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de l'ajout du vœu. Veuillez vérifier les données.")),
      );
    }
  }
}
*/
