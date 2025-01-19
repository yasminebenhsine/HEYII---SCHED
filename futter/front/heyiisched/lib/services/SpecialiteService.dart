import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:heyiisched/models/specialite.dart';
/*
Future<List<Specialite>> fetchSpecialites() async {
  final response = await http.get(Uri.parse('http://localhost:8084/specialite/retrieve-all-specialites'));

  if (response.statusCode == 200) {
    // Décoder la réponse en une liste dynamique
    List<dynamic> data = json.decode(response.body);
    print('Réponse brute: $data');  // Affiche les données retournées par l'API
   
    // Mapper chaque élément de la liste 'data' en un objet Specialite
    return data.map((item) {
      print('Item: $item');  // Affiche chaque élément de la réponse
      // Crée un objet Specialite avec un id vide et des matières vides
      return Specialite(
        idSpecialite: '',  // L'ID peut être vide ou généré autrement
        nom: item,  // Utilisez chaque élément de la liste comme nom de spécialité
        matieres: [],  // Ajoutez des matières si nécessaire
      );
    }).toList();  // Retourne la liste des spécialités
  } else {
    print('Erreur: ${response.statusCode}');
    print('Message du serveur: ${response.body}');
    throw Exception('Failed to load specialites');
  }
}
*/

// Fonction pour supprimer une spécialité
Future<void> deleteSpecialite(
  BuildContext context,
  String id,
  Future<List<Specialite>> Function() fetchSpecialitesCallback,
) async {
  if (id.isEmpty) {
    print('Erreur : ID est vide.');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('ID de la spécialité manquant.')),
    );
    return;
  }

  final url = 'http://localhost:8084/specialite/delete/$id';
  print('Suppression avec URL : $url'); // Debug pour vérifier l'URL

  final response = await http.delete(Uri.parse(url));

  if (response.statusCode == 204) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Spécialité supprimée avec succès!')),
    );
    fetchSpecialitesCallback();
  } else {
    print('Erreur de suppression : ${response.statusCode}');
    print('Réponse du serveur : ${response.body}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erreur lors de la suppression.')),
    );
  }
  // Fonction pour supprimer une spécialité par son nom
  Future<void> deleteSpecialiteByNom(
    BuildContext context,
    String nom,
    Future<List<Specialite>> Function() fetchSpecialitesCallback,
  ) async {
    if (nom.isEmpty) {
      print('Erreur : Le nom est vide.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nom de la spécialité manquant.')),
      );
      return;
    }

    final url =
        'http://localhost:8084/specialite/deleteByNom/$nom'; // URL de l'API
    print('Suppression par nom avec URL : $url'); // Debug pour vérifier l'URL

    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 204) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Spécialité supprimée avec succès!')),
      );
      fetchSpecialitesCallback();
    } else {
      print('Erreur de suppression : ${response.statusCode}');
      print('Réponse du serveur : ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la suppression.')),
      );
    }
  }
}
