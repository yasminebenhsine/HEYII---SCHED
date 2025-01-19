import 'dart:convert';
import 'package:heyiisched/services/AuthService_y.dart';
import 'package:http/http.dart' as http;
import 'package:heyiisched/models/emploi.dart';

class ProfTimetableService {
  final String baseUrl = 'http://localhost:8084/api/emplois';
  final AuthService authService;

  ProfTimetableService({required this.authService});

  Future<List<Emploi>> getEmploiByProfId() async {
    try {
      final prof = await authService.getCurrentProf();
      if (prof == null) throw Exception('User not found or not a professor');

      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to load emplois: ${response.statusCode}');
      }

      final List<dynamic> emploisJson =
          json.decode(utf8.decode(response.bodyBytes));
      final List<Emploi> allEmplois = emploisJson
          .where((json) => json != null)
          .map((json) => Emploi.fromJson(json))
          .toList();

      return allEmplois
          .where((emploi) =>
              emploi.enseignants
                  .any((enseignant) => enseignant.idUser == prof.idUser) ||
              emploi.cours
                  .any((cours) => cours.enseignant?.idUser == prof.idUser))
          .toList();
    } catch (e, stackTrace) {
      print('Error in getEmploiByProfId: $e\n$stackTrace');
      rethrow;
    }
  }

  Future<Emploi> getEmploiById(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load emploi: ${response.statusCode}');
    }

    return Emploi.fromJson(json.decode(utf8.decode(response.bodyBytes)));
  }
}
/*import 'dart:convert';
import 'package:heyiisched/models/Modeles.dart';
import 'package:http/http.dart' as http;
 // Assurez-vous que le modèle Emploi est correctement défini

class EmploiService {
  final String apiUrl = 'http://localhost:8084/api/emplois'; // URL de votre API Spring Boot

  // Méthode pour récupérer tous les emplois
  Future<List<Emploi>> fetchAllEmplois() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Emploi.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load emplois');
    }
  }

Future<List<Emploi>> fetchEmploiById(String id) async {
  final response = await http.get(Uri.parse('$apiUrl/$id'));

  if (response.statusCode == 200) {
    try {
      final data = json.decode(response.body);

      // Vérifiez si les données sont nulles ou mal formatées
      if (data == null) {
        return [];  // Retourner une liste vide si les données sont null
      }

      // Si l'API renvoie un objet au lieu d'une liste, on le met dans une liste
      if (data is Map<String, dynamic>) {
        return [Emploi.fromJson(data)];  // Convertir l'objet en liste d'emplois
      }

      // Si l'API renvoie une liste d'emplois
      return data.map<Emploi>((item) => Emploi.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Erreur lors de la décodification des données: $e');
    }
  } else {
    throw Exception('Failed to load emploi');
  }
}


  // Ajouter un nouvel emploi
  Future<void> addEmploi(Emploi emploi) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(emploi.toJson()),
    );

    if (response.statusCode == 201) {
      print('Emploi added successfully');
    } else {
      throw Exception('Failed to add emploi');
    }
  }

  // Mettre à jour un emploi existant
  Future<void> updateEmploi(String id, Emploi emploi) async {
    final response = await http.put(
      Uri.parse('$apiUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(emploi.toJson()),
    );

    if (response.statusCode == 200) {
      print('Emploi updated successfully');
    } else {
      throw Exception('Failed to update emploi');
    }
  }

  // Supprimer un emploi par ID
  Future<void> deleteEmploi(String id) async {
    final response = await http.delete(Uri.parse('$apiUrl/$id'));

    if (response.statusCode == 200) {
      print('Emploi deleted successfully');
    } else {
      throw Exception('Failed to delete emploi');
    }
  }
}*/
