import 'dart:convert';
import 'package:heyiisched/models/Modeles.dart';
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

  Future<List<Cours>> getCoursByEnseignantId(String enseignantId) async {
    final response = await http.get(
      Uri.parse('http://localhost:8084/api/cours/enseignant/$enseignantId'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Cours.fromJson(item)).toList();
    } else {
      throw Exception('Erreur lors de la récupération des cours');
    }
  }

  // Filtrer les cours par Enseignant
  /* Future<List<Cours>> getCoursByEnseignant(String idEnseignant) async {
    final response = await http.get(Uri.parse('$baseUrl/enseignant/$idEnseignant'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Cours.fromJson(item)).toList();
    } else {
      throw Exception('Échec de récupération des cours par enseignant');
    }
  }*/
  Future<List<Cours>> getCoursByEnseignant(String idEnseignant) async {
    final response =
        await http.get(Uri.parse('$baseUrl/enseignant/$idEnseignant'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Cours.fromJson(json)).toList();
    } else {
      throw Exception("Erreur lors de la récupération des cours");
    }
  }
}
/*
  // Filtrer les cours par Groupe de Classe
  Future<List<Cours>> getCoursByGrpClass(String idGrpClass) async {
    final response = await http.get(Uri.parse('$baseUrl/groupeClasse/$idGrpClass'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Cours.fromJson(item)).toList();
    } else {
      throw Exception('Échec de récupération des cours par groupe');
    }
  }

  // Filtrer les cours par Salle
  Future<List<Cours>> getCoursBySalle(String idSalle) async {
    final response = await http.get(Uri.parse('$baseUrl/salle/$idSalle'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Cours.fromJson(item)).toList();
    } else {
      throw Exception('Échec de récupération des cours par salle');
    }
  }

  // Filtrer les cours par Emploi
  Future<List<Cours>> getCoursByEmploi(String idEmploi) async {
    final response = await http.get(Uri.parse('$baseUrl/emploi/$idEmploi'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Cours.fromJson(item)).toList();
    } else {
      throw Exception('Échec de récupération des cours par emploi');
    }
  }
}*/
