import 'dart:convert';

//import 'package:heyiisched/Prof/model/model_emploi.dart';
import 'package:heyiisched/Prof/model/profEmploi.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'cours.dart'; // Assurez-vous d'importer votre modèle Cours

class CoursService {
  final String baseUrl =
      'http://localhost:8080/api/cours'; // Remplacez par l'URL de votre API

  // Obtenir tous les cours
  Future<List<Cours>> getAllCours() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Cours.fromJson(item)).toList();
    } else {
      throw Exception('Échec de chargement des cours');
    }
  }

  Future<Map<String, List<Cours>>> fetchScheduleByEnseignantt(
      String idEnseignant) async {
    final response = await http.get(Uri.parse(
        'http://localhost:8080/api/cours/enseignant/schedule/$idEnseignant'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return data.map((key, value) {
        return MapEntry(
          key,
          List<Cours>.from(value.map((item) => Cours.fromJson(item))),
        );
      });
    } else {
      throw Exception('Erreur lors du chargement de l\'emploi du temps');
    }
  }

  // Obtenir un cours par son ID
  Future<Cours> getCoursById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return Cours.fromJson(json.decode(response.body));
    } else {
      throw Exception('Cours non trouvé');
    }
  }

  // Ajouter un nouveau cours
  Future<Cours> addCours(Cours cours) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(cours.toJson()),
    );

    if (response.statusCode == 201) {
      return Cours.fromJson(json.decode(response.body));
    } else {
      throw Exception('Erreur lors de l\'ajout du cours');
    }
  }

  // Mettre à jour un cours existant
  Future<Cours> updateCours(String id, Cours updatedCours) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(updatedCours.toJson()),
    );

    if (response.statusCode == 200) {
      return Cours.fromJson(json.decode(response.body));
    } else {
      throw Exception('Erreur lors de la mise à jour du cours');
    }
  }

  // Supprimer un cours
  Future<void> deleteCours(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 204) {
      throw Exception('Erreur lors de la suppression du cours');
    }
  }

  // Filtrer les cours par Matière
  Future<List<Cours>> getCoursByMatiere(String idMatiere) async {
    final response = await http.get(Uri.parse('$baseUrl/matiere/$idMatiere'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Cours.fromJson(item)).toList();
    } else {
      throw Exception('Échec de récupération des cours par matière');
    }
  }

  Future<List<Cours>> getCoursByEnseignant(String idEnseignant) async {
    final response = await http.get(
        Uri.parse('http://localhost:8084/api/cours/enseignant/$idEnseignant'));

    if (response.statusCode == 200) {
      if (response.body.isEmpty || response.body == 'null') {
        throw Exception('Aucune donnée disponible.');
      }

      print('Raw JSON Response: ${response.body}');

      try {
        List<dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse.isEmpty) {
          print('Aucun cours trouvé pour cet enseignant.');
          return [];
        }

        print('Décodage réussi : $jsonResponse');
        return jsonResponse
            .where((element) => element != null)
            .map((element) {
              try {
                return Cours.fromJson(element as Map<String, dynamic>);
              } catch (e) {
                print('Erreur lors de la conversion d\'un cours : $e');
                return null;
              }
            })
            .where((cours) => cours != null)
            .cast<Cours>()
            .toList();
      } catch (e) {
        print('Erreur lors du décodage : $e');
        throw Exception('Erreur lors du décodage des données : $e');
      }
    } else {
      throw Exception('Failed to load courses, status: ${response.statusCode}');
    }
  }

  Future<http.Response> _fetchEmplois() async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to load emplois: ${response.statusCode}');
      }

      return response;
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  Future<List<Cours>> getCoursByEnseignantId(String idEnseignant) async {
    final response =
        await http.get(Uri.parse('$baseUrl/enseignant/$idEnseignant'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Cours.fromJson(json)).toList();
    } else {
      throw Exception("Erreur lors de la récupération des cours");
    }
  }

  Future<Map<String, List<Cours>>> fetchScheduleByEnseignant(
      String enseignantId) async {
    final response = await http.get(
        Uri.parse('http://localhost:8084/api/cours/schedule/$enseignantId'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      return data.map((key, value) {
        return MapEntry(
          key,
          (value as List).map((item) => Cours.fromJson(item)).toList(),
        );
      });
    } else {
      throw Exception('Erreur lors de la récupération de l\'emploi du temps.');
    }
  }
}
