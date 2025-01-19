import 'dart:convert';
import 'package:heyiisched/Prof/model/profEmploi.dart';
import 'package:http/http.dart' as http;

class EmploiService {
  final String apiUrl = 'http://localhost:8084/api/emplois';

  // Créer un emploi
  Future<Emploi> createEmploi(Emploi emploi) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(emploi.toJson()),
    );

    if (response.statusCode == 200) {
      return Emploi.fromJson(json.decode(response.body));
    } else {
      throw Exception('Échec de la création de l\'emploi');
    }
  }

  // Récupérer tous les cours
  Future<List<Cours>> getAllCours() async {
    final response = await http.get(Uri.parse('$apiUrl/cours'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Cours.fromJson(item)).toList();
    } else {
      throw Exception('Échec de la récupération des cours');
    }
  }

  // Récupérer toutes les salles
  Future<List<Salle>> getAllSalles() async {
    final response = await http.get(Uri.parse('$apiUrl/salles'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Salle.fromJson(item)).toList();
    } else {
      throw Exception('Échec de la récupération des salles');
    }
  }

  // Mettre à jour un emploi
  Future<Emploi> updateEmploi(String id, Emploi emploi) async {
    final response = await http.put(
      Uri.parse('$apiUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(emploi.toJson()),
    );

    if (response.statusCode == 200) {
      return Emploi.fromJson(json.decode(response.body));
    } else {
      throw Exception('Échec de la mise à jour de l\'emploi');
    }
  }

  // Supprimer un emploi
  Future<void> deleteEmploi(String id) async {
    final response = await http.delete(Uri.parse('$apiUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Échec de la suppression de l\'emploi');
    }
  }

  // Récupérer tous les emplois
/*Future<List<Emploi>> getAllEmplois() async {
  final response = await http.get(Uri.parse(apiUrl));

  if (response.statusCode == 200) {
    // Décoder la réponse JSON
    dynamic data = json.decode(response.body);

    // Vérifiez si les données sont bien une liste
    if (data is List) {
      // Traitez chaque élément de la liste
      return data.map((item) {
        if (item is Map<String, dynamic>) {
          // Chaque item est un Map, on peut maintenant le convertir en Emploi
          return Emploi.fromJson(item);
        } else {
          throw Exception('Données incorrectes dans la liste : $item');
        }
      }).toList();
    } else {
      throw Exception('Les données reçues ne sont pas une liste');
    }
  } else {
    print('Erreur de réponse: ${response.body}');
    throw Exception('Échec de la récupération des emplois');
  }
}*/
  Future<List<Emploi>> getAllEmplois() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // Decode the JSON response
        List<dynamic> jsonList = json.decode(response.body);

        // Convert each item in the list to an Emploi object
        return jsonList.map((json) => Emploi.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load emplois: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('Error in getAllEmplois: $e');
      print('Stack trace: $stackTrace');
      throw Exception('Failed to load emplois: $e');
    }
  }

  // Récupérer un emploi par ID
  Future<Emploi> getEmploiById(String id) async {
    final response = await http.get(Uri.parse('$apiUrl/$id'));

    if (response.statusCode == 200) {
      return Emploi.fromJson(json.decode(response.body));
    } else {
      throw Exception('Échec de la récupération de l\'emploi');
    }
  }
}
