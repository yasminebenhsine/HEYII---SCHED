import 'dart:convert';
import 'package:heyiisched/models/Matiere_salle.dart';
import 'package:http/http.dart' as http;

class MatiereService {
  static Future<List<Matiere>> fetchMatieresBySpecialite(
      String specialiteId) async {
    final url =
        Uri.parse('http://localhost:8084/specialite/$specialiteId/matieres');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List jsonData = json.decode(response.body);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      return jsonData.map((matiere) => Matiere.fromJson(matiere)).toList();
    } else {
      throw Exception('Erreur lors du chargement des matières');
    }
  }

  // Update this with your actual base URL
  final String baseUrl = "http://localhost:8084";
  // Use 'http://localhost:8080' for iOS simulator
  // Use your actual IP address for physical devices

  // Get all matieres
  Future<List<Matiere>> getAllMatieres() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/matiere/retrieve-all-matieres'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          return []; // Return empty list if no data
        }

        // Parse the JSON response
        try {
          final List<dynamic> jsonData = json.decode(response.body);
          return jsonData.map((json) => Matiere.fromJson(json)).toList();
        } catch (e) {
          print('JSON parsing error: $e');
          throw Exception('Failed to parse matiere data: $e');
        }
      } else if (response.statusCode == 404) {
        return []; // Return empty list if no data found
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      print('Network error: $e');
      throw Exception(
          'Connection error: Please check your internet connection');
    } catch (e) {
      print('Unexpected error: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<List<Matiere>> fetchMatieres() async {
    final url = Uri.parse('$baseUrl/matiere/retrieve-all-matieres');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      final List jsonData = json.decode(response.body);
      return jsonData.map((matiere) => Matiere.fromJson(matiere)).toList();
    } else {
      throw Exception("Erreur lors de la récupération des matières.");
    }
  }

  // Add new matiere
  Future<Matiere> addMatiere(Matiere matiere) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/matiere/addMatiere'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(matiere.toJson()),
      );

      print('Add matiere response: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        return Matiere.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to add matiere: ${response.statusCode}');
      }
    } catch (e) {
      print('Error adding matiere: $e');
      throw Exception('Failed to add matiere: $e');
    }
  }

  // Update matiere
  Future<Matiere> updateMatiere(String id, Matiere matiere) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/matiere/update/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'nom': matiere.nom,
          'type': matiere.type,
          'semestre': matiere.semestre,
          'niveau': matiere.niveau,
          // Ajoutez d'autres champs nécessaires ici
        }),
      );

      print('Update matiere response: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return Matiere.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Matiere not found');
      } else {
        throw Exception('Failed to update matiere: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating matiere: $e');
      throw Exception('Failed to update matiere: $e');
    }
  }

  // Delete matiere
  Future<void> deleteMatiere(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/matiere/delete/$id'),
        headers: {
          'Accept': 'application/json',
        },
      );

      print('Delete matiere response: ${response.statusCode}');

      if (response.statusCode != 200) {
        throw Exception('Failed to delete matiere: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting matiere: $e');
      throw Exception('Failed to delete matiere: $e');
    }
  }
}
