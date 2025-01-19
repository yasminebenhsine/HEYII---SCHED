import 'package:heyiisched/models/Modeles.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/*
  class Voeuxprof {
  final String baseUrl = 'http://localhost:8084';
  Future<bool> addVoeux(Map<String, dynamic> voeuData) async {
    final url = Uri.parse('$baseUrl/voeux/add');

    try {
      final response = await http.post(
        url,
       headers: {
  'Content-Type': 'application/json',  // Retirer le charset
},

        body: json.encode(voeuData),  // Corps de la requête au format JSON
      );

      if (response.statusCode == 201) {
        print('Vœu ajouté avec succès : ${response.body}');
        return true;  // Succès de l'ajout
      } else {
        print('Erreur (${response.statusCode}): ${response.body}');
        return false;  // Erreur lors de l'ajout
      }
      
    } catch (e) {
      print('Erreur de connexion : $e');
      return false;  // Erreur de connexion
    }
  }*/
class Voeuxprof {
  static Future<void> addVoeuxx(Map<String, dynamic> voeuxData) async {
    final url = Uri.parse('http://localhost:8084/voeux/add');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(voeuxData),
      );

      if (response.statusCode != 200) {
        throw Exception('Erreur lors de l\'ajout du vœu');
      }
    } catch (e) {
      throw Exception('Erreur lors de la requête : $e');
    }
  }

  static Future<void> addVoeuxForEnseignant(
      Map<String, dynamic> voeuxData, String enseignantId) async {
    final url = Uri.parse('http://localhost:8084/voeux/add/$enseignantId');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(voeuxData),
      );

      if (response.statusCode != 200) {
        print('Erreur HTTP : ${response.statusCode}');
        print('Détails de l\'erreur : ${response.body}');
        throw Exception('Erreur lors de l\'ajout du vœu.');
      }

      print('Réponse : ${response.body}');
    } catch (e) {
      print('Erreur lors de la requête : $e');
      throw Exception('Erreur lors de la requête : $e');
    }
  }

  Future<List<Voeux>> fetchVoeux() async {
    final response = await http.get(Uri.parse('http://localhost:8084/voeux'));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      print('body voeux :   ${response.body}');
      return body.map((e) => Voeux.fromJson(e)).toList();
    } else {
      throw Exception('Erreur lors de la récupération des vœux');
    }
  }

  Future<void> updateEtat(String idVoeu, String etat) async {
    final response = await http.patch(
      Uri.parse('http://localhost:8084/voeux/$idVoeu/etat'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'etat': etat}),
    );

    if (response.statusCode != 200) {
      print('Réponse : ${response.body}');
      print('Réponse : ${response.statusCode}');
      throw Exception('Erreur lors de la mise à jour de l\'état');
    }
    print('Réponse : ${response.statusCode}');
    print('Réponse : ${response.body}');
  }
}
