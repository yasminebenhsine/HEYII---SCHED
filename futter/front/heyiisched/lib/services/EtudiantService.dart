import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:heyiisched/models/Modeles.dart';
import 'package:http/http.dart' as http;

class EtudiantService {
  final String apiUrl =
      "http://localhost:8084/etudiant"; // L'URL de votre backend Spring Boot

  // Méthode pour récupérer les étudiants depuis l'API
  Future<List<Etudiant>> fetchEtudiants() async {
    try {
      final response =
          await http.get(Uri.parse('$apiUrl/retrieve-all-etudiants'));

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => Etudiant.fromJson(data)).toList();
      } else {
        throw Exception('Échec du chargement des étudiants');
      }
    } catch (e) {
      throw Exception('Erreur lors de la connexion à l\'API: $e');
    }
  }

  // Ajouter un étudiant
  Future<void> addEtudiant(Etudiant etudiant) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(etudiant.toJson()),
      );

      if (response.statusCode == 201) {
        print('Étudiant ajouté avec succès');
      } else {
        throw Exception('Échec de l\'ajout de l\'étudiant');
      }
    } catch (e) {
      throw Exception('Erreur lors de l\'ajout de l\'étudiant: $e');
    }
  }

  // Mettre à jour un étudiant
  Future<void> updateEtudiant(Etudiant etudiant) async {
    try {
      final response = await http.put(
        Uri.parse('$apiUrl/${etudiant.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(etudiant.toJson()),
      );

      if (response.statusCode == 200) {
        print('Étudiant mis à jour avec succès');
      } else {
        throw Exception('Échec de la mise à jour de l\'étudiant');
      }
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour de l\'étudiant: $e');
    }
  }

  // Supprimer un étudiant
  Future<void> deleteEtudiant(String id) async {
    try {
      final response = await http.delete(Uri.parse('$apiUrl/$id'));

      if (response.statusCode == 200) {
        print('Étudiant supprimé avec succès');
      } else {
        throw Exception('Échec de la suppression de l\'étudiant');
      }
    } catch (e) {
      throw Exception('Erreur lors de la suppression de l\'étudiant: $e');
    }
  }
}


/*import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:heyiisched/models/Modeles.dart';

class EtudiantService {
 //final String apiUrl = 'http://localhost:59058/etudiant';
//final String apiUrl  = 'http://127.0.0.1:59075/etudiant';
final String baseUrl = "http://localhost:8084/api/v1";
final String apiUrl = 'http://10.0.2.2:8084/etudiant';

  // Méthode pour récupérer les étudiants depuis l'API
  Future<List<Etudiant>> fetchEtudiants() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/retrieve-all-etudiants'));

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => Etudiant.fromJson(data)).toList();
      } else {
        throw Exception('Échec du chargement des étudiants');
      }
    } catch (e) {
      throw Exception('Erreur lors de la connexion à l\'API: $e');
    }
  }

  // Méthode pour ajouter un étudiant
  Future<void> addEtudiant(Etudiant etudiant) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(etudiant.toJson()),
      );

      if (response.statusCode != 201) {
        throw Exception('Échec de l\'ajout de l\'étudiant');
      }
    } catch (e) {
      throw Exception('Erreur lors de l\'ajout de l\'étudiant: $e');
    }
  }

  // Méthode pour supprimer un étudiant
  Future<void> deleteEtudiant(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$apiUrl/$id'),
      );

      if (response.statusCode != 200) {
        throw Exception('Échec de la suppression de l\'étudiant');
      }
    } catch (e) {
      throw Exception('Erreur lors de la suppression de l\'étudiant: $e');
    }
  }

  // Méthode pour modifier un étudiant
  Future<void> updateEtudiant(Etudiant etudiant) async {
    try {
      final response = await http.put(
        Uri.parse('$apiUrl/${etudiant.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(etudiant.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception('Échec de la modification de l\'étudiant');
      }
    } catch (e) {
      throw Exception('Erreur lors de la modification de l\'étudiant: $e');
    }
  }
}

*/