import 'dart:convert';
import 'package:heyiisched/models/Modeles.dart';
import 'package:http/http.dart' as http;

class DateService {
  final String baseUrl =
      'http://localhost:8084/api/datee'; // Remplacez par l'URL de votre API

  // Récupérer toutes les dates
  Future<List<Datee>> getAllDates() async {
    final response = await http.get(Uri.parse('$baseUrl/retrieve-all'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Datee.fromJson(item)).toList();
    } else {
      throw Exception('Échec de chargement des dates');
    }
  }

  // Récupérer une date par ID
  Future<Datee> getDateeById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return Datee.fromJson(json.decode(response.body));
    } else {
      throw Exception('Date non trouvée');
    }
  }

  // Créer une nouvelle date
  Future<Datee> addDatee(Datee datee) async {
    final response = await http.post(
      Uri.parse('$baseUrl/create'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(datee.toJson()),
    );

    if (response.statusCode == 201) {
      return Datee.fromJson(json.decode(response.body));
    } else {
      throw Exception('Erreur lors de la création de la date');
    }
  }

  // Mettre à jour une date
  Future<Datee> updateDatee(String id, Datee updatedDatee) async {
    final response = await http.put(
      Uri.parse('$baseUrl/update/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(updatedDatee.toJson()),
    );

    if (response.statusCode == 200) {
      return Datee.fromJson(json.decode(response.body));
    } else {
      throw Exception('Erreur lors de la mise à jour de la date');
    }
  }

  // Supprimer une date
  Future<void> deleteDatee(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/delete/$id'));

    if (response.statusCode != 200) {
      throw Exception('Erreur lors de la suppression de la date');
    }
  }
}
