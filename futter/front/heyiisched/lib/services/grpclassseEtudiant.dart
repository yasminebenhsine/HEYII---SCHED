import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:heyiisched/models/Modeles.dart';
import 'package:http/http.dart' as http;

class EtudiantService {
  Future<List<Etudiant>> getEtudiantsByGroupe(String groupeId) async {
    final response = await http.get(
      Uri.parse("http://localhost:8084/etudiant/groupe/$groupeId/etudiants"),
    );

    if (response.statusCode == 200) {
      if (response.body.isEmpty) {
        return []; // Return empty list instead of throwing exception
      }

      final data = json.decode(response.body);

      if (data is Map<String, dynamic> && data.containsKey('message')) {
        return []; // Return empty list for "classe vide" message
      }

      if (data is List) {
        return data
            .where((item) => item != null) // Filter out null items
            .map((item) => Etudiant.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      
      return []; // Return empty list for unexpected format
    } else {
      print('Error: ${response.body}');
      throw Exception('Failed to fetch students');
    }
  }
  Future<GrpClass> getGroupeDetails(String groupeId) async {
    final response = await http.get(
      Uri.parse("http://localhost:8084/groupe/$groupeId"),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return GrpClass.fromJson(
          data); // Assurez-vous que votre `GrpClass` a une méthode `fromJson`
    } else {
      print('Erreur: ${response.body}');
      throw Exception('Erreur lors de la récupération des détails du groupe');
    }
  }
}
