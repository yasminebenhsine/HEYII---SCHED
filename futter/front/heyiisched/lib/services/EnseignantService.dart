import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:heyiisched/models/Matiere_salle.dart';
import 'package:heyiisched/models/Modeles.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class EnseignantService {
  final String apiUrl = 'http://localhost:8084/enseignant';

// Remplacez par l'URL de votre backend

  Future<List<Enseignant>> fetchEnseignants() async {
    final response =
        await http.get(Uri.parse('$apiUrl/retrieve-all-enseignants'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);

      print(jsonResponse); // Pour voir le contenu réel de la réponse

      return jsonResponse.map((data) => Enseignant.fromJson(data)).toList();
    } else {
      throw Exception('Erreur lors du chargement des enseignants');
    }
  }

  Future<Enseignant> fetchEnseignantById(String id) async {
    final response = await http.get(
      Uri.parse('$apiUrl/retrieve/$id'), // Vérifiez l'URL ici
    );

    if (response.statusCode == 200) {
      print('dataaaa::::  $response.body');
      return Enseignant.fromJson(json.decode(response.body));
    } else {
      print(response.body);
      throw Exception(
          'Erreur lors de la récupération des détails de l\'enseignant');
    }
  }

  Future<List<Matiere>> getMatieresByEnseignantId(String enseignantId) async {
    final response =
        await http.get(Uri.parse('$apiUrl/retrieve-matieres/$enseignantId'));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((item) => Matiere.fromJson(item)).toList();
    } else if (response.statusCode == 204) {
      return []; // Aucun contenu
    } else {
      throw Exception("Erreur lors de la récupération des matières");
    }
  }

  Future<List<Cours>> fetchCours(String enseignantId) async {
    final response = await http.get(Uri.parse('$apiUrl/$enseignantId/cours'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Cours.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load cours');
    }
  }

  Future<void> addEnseignant(Enseignant enseignant) async {
    final response = await http.post(
      Uri.parse('$apiUrl/add'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(enseignant.toJson()),
    );

    if (response.statusCode == 201) {
      // Succès
      print('Message du serveur: ${response.body}');
      print("Enseignant ajouté avec succès");
    } else {
      // Échec
      print("Échec de l'ajout de l'enseignant");
    }
  }

  // Mettre à jour un enseignant
  Future<void> updateEnseignant(Enseignant enseignant) async {
    try {
      final response = await http.put(
        Uri.parse('$apiUrl/${enseignant.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(enseignant.toJson()),
      );

      if (response.statusCode == 200) {
        print('Enseignant mis à jour avec succès');
      } else {
        throw Exception('Échec de la mise à jour de l\'enseignant');
      }
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour de l\'enseignant: $e');
    }
  }

  // Supprimer un enseignant
  Future<void> deleteEnseignant(String id) async {
    try {
      final response = await http.delete(Uri.parse('$apiUrl/delete/$id'));

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('Enseignant supprimé avec succès');
      } else {
        throw Exception(
            'Échec de la suppression de l\'enseignant: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la suppression de l\'enseignant: $e');
    }
  }

  Future<void> getReclamationsByEnseignant(String enseignantId) async {
    final response = await http.get(Uri.parse(
        'http://localhost:8084/reclamations/enseignant/$enseignantId'));

    if (response.statusCode == 200) {
      // Traitez les réclamations et affichez-les
      print('Réclamations récupérées: ${response.body}');
    } else {
      print('Erreur lors de la récupération des réclamations');
    }
  }

  Future<void> saveEnseignantId(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('enseignantId', id);
  }

  /*Future<List<Matiere>> getMatieresByEnseignantId(String enseignantId) async {
  try {
    final response = await http.get(Uri.parse('$apiUrl/retrieve-matieres/$enseignantId'));

    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      if (jsonResponse.isEmpty) {
        print('Aucune matière trouvée pour cet enseignant');
        return []; // Retourner une liste vide si aucune matière n'est trouvée
      }
      return jsonResponse.map((matiere) => Matiere.fromJson(matiere)).toList();
    } else {
      print('Erreur lors de la récupération des matières: ${response.statusCode}');
      print('body: ${response.body}');
      throw Exception('Erreur lors de la récupération des matières: ${response.statusCode}');
    }
  } catch (e) {
    print('Exception: $e');
    throw Exception('Erreur réseau: $e');
  }
}
*/
/*Future<Enseignant> fetchEnseignantById(String enseignantId) async {
  try {
    // Assurez-vous que l'URL correspond à ce qui est attendu dans votre backend
    final response = await http.get(Uri.parse('$apiUrl/retrieve/$enseignantId'));

    if (response.statusCode == 200) {
      return Enseignant.fromJson(json.decode(response.body));
    } else {
      print('Réponse du serveur: ${response.statusCode}');
      print('Message du serveur: ${response.body}');
      throw Exception('Erreur lors de la récupération des détails de l\'enseignant');
    }
  } catch (e) {
    throw Exception('Erreur lors de la connexion au serveur: $e');
  }
}*/
// Ajouter un enseignant
/*Future<void> addEnseignant(Enseignant enseignant) async {
  try {
    // Générer un ID aléatoire basé sur le temps si l'ID est null ou vide
    if (enseignant.id.isEmpty) {
      enseignant.id = DateTime.now().millisecondsSinceEpoch.toString();
    }

    final response = await http.post(
      Uri.parse('$apiUrl/add'),
      headers: {
  'Content-Type': 'application/json', // Retirer charset=utf-8
},

      body: json.encode({
        'id': enseignant.id,
        'nom': enseignant.nom,
        'prenom': enseignant.prenom,
        'email': enseignant.email,
        'nbHeure': enseignant.nbHeure,
        'grade': enseignant.grade?.toString().split('.').last,
        'matieres':[],
        'cours':[],
        'filieres':[], 
        'specialites':[], 
        'reclamations':[], 
        'emploi':[], 
         'voeux':[], // Conversion de l'énum en chaîne
      }), // Convertir l'objet Enseignant en JSON
    );
    print('\n \n En-têtes de la requête: ${response.request?.headers}');


    print('Corps de la réponse: ${response.body}');

    if (response.statusCode == 201) {
      print('Enseignant ajouté avec succès');
    } else {
      print('Réponse de l\'API: ${response.body}'); // Afficher la réponse du serveur
      throw Exception('Échec de l\'ajout de l\'enseignant');
    }
  } catch (e) {
    print('Erreur lors de l\'ajout de l\'enseignant: $e');
    throw Exception('Erreur lors de l\'ajout de l\'enseignant: $e');
  }
}
*/

/*
Future<List<Matiere>> getMatieresByEnseignantId(String enseignantId) async {
    final response = await http.get(Uri.parse('$apiUrl/$enseignantId'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((matiere) => Matiere.fromJson(matiere)).toList();
    } else {
      throw Exception('Failed to load matieres');
    }
  }*/
}
