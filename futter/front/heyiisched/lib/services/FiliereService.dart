import 'dart:convert';
import 'package:heyiisched/models/Modeles.dart';
import 'package:http/http.dart' as http;


class FiliereService {
  final String baseUrl = 'http://localhost:8080/filieres'; // Remplacez par l'URL de votre API

  // Récupérer toutes les filières
  Future<List<Filiere>> getAllFilieres() async {
    final response = await http.get(Uri.parse('$baseUrl/retrieve-all-filieres'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Filiere.fromJson(item)).toList();
    } else {
      throw Exception('Échec de chargement des filières');
    }
  }

  // Récupérer une filière par ID
  Future<Filiere> getFiliereById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return Filiere.fromJson(json.decode(response.body));
    } else {
      throw Exception('Filière non trouvée');
    }
  }

  // Créer une nouvelle filière
  Future<Filiere> createFiliere(Filiere filiere) async {
    final response = await http.post(
      Uri.parse('$baseUrl/create'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(filiere.toJson()),
    );

    if (response.statusCode == 201) {
      return Filiere.fromJson(json.decode(response.body));
    } else {
      throw Exception('Erreur lors de la création de la filière');
    }
  }

  // Mettre à jour une filière
  Future<Filiere> updateFiliere(String id, Filiere updatedFiliere) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id/edit'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(updatedFiliere.toJson()),
    );

    if (response.statusCode == 200) {
      return Filiere.fromJson(json.decode(response.body));
    } else {
      throw Exception('Erreur lors de la mise à jour de la filière');
    }
  }

  // Supprimer une filière
  Future<void> deleteFiliere(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/delete/$id'));

    if (response.statusCode != 204) {
      throw Exception('Erreur lors de la suppression de la filière');
    }
  }

  // Rechercher une filière par nom
  Future<Filiere> getFiliereByNom(String nom) async {
    final response = await http.get(Uri.parse('$baseUrl/nom/$nom'));

    if (response.statusCode == 200) {
      return Filiere.fromJson(json.decode(response.body));
    } else {
      throw Exception('Filière non trouvée');
    }
  }
}
