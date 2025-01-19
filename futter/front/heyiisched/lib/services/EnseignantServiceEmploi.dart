import 'dart:convert';
import 'package:heyiisched/Prof/model/profEmploi.dart';
import 'package:http/http.dart' as http;

class EnseignantService {
  final String apiUrl =
      'http://localhost:8084/enseignant'; // L'URL de votre backend

  // Récupérer tous les enseignants
  Future<List<Enseignant>> getAllEnseignants() async {
    final response =
        await http.get(Uri.parse('$apiUrl/retrieve-all-enseignants'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Enseignant.fromJson(item)).toList();
    } else {
      print('Ense response.body  ; ${response.body}');
      throw Exception('Échec de la récupération des enseignants');
    }
  }

  // Récupérer un enseignant par ID
  Future<Enseignant> getEnseignantById(String id) async {
    final response = await http.get(Uri.parse('$apiUrl/retrieve/$id'));

    if (response.statusCode == 200) {
      return Enseignant.fromJson(json.decode(response.body));
    } else {
      print('Ense response.body  ; ${response.body}');
      throw Exception('Échec de la récupération de l\'enseignant');
    }
  }

  // Ajouter un nouvel enseignant
  Future<Enseignant> addEnseignant(Enseignant enseignant) async {
    final response = await http.post(
      Uri.parse('$apiUrl/add'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(enseignant.toJson()),
    );

    if (response.statusCode == 200) {
      return Enseignant.fromJson(json.decode(response.body));
    } else {
      throw Exception('Échec de l\'ajout de l\'enseignant');
    }
  }

  // Mettre à jour un enseignant
  Future<Enseignant> updateEnseignant(String id, Enseignant enseignant) async {
    final response = await http.put(
      Uri.parse('$apiUrl/update/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(enseignant.toJson()),
    );

    if (response.statusCode == 200) {
      return Enseignant.fromJson(json.decode(response.body));
    } else {
      throw Exception('Échec de la mise à jour de l\'enseignant');
    }
  }

  // Supprimer un enseignant
  Future<void> deleteEnseignant(String id) async {
    final response = await http.delete(Uri.parse('$apiUrl/delete/$id'));

    if (response.statusCode != 200) {
      throw Exception('Échec de la suppression de l\'enseignant');
    }
  }

  // Récupérer les matières associées à un enseignant
  Future<List<Matiere>> getMatieresByEnseignantId(String enseignantId) async {
    final response =
        await http.get(Uri.parse('$apiUrl/matieres/$enseignantId'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Matiere.fromJson(item)).toList();
    } else {
      throw Exception('Échec de la récupération des matières');
    }
  }
}
