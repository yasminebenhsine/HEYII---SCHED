import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:heyiisched/Dashbord/details/AddSpecialitePage.dart';
import 'package:http/http.dart' as http;
import 'package:heyiisched/models/specialite.dart';

class SpecialiteListPage extends StatefulWidget {
  @override
  _SpecialiteListPageState createState() => _SpecialiteListPageState();
}

class _SpecialiteListPageState extends State<SpecialiteListPage> {
  late Future<List<Specialite>> specialites;

  @override
  void initState() {
    super.initState();
    specialites = fetchSpecialites();
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des spécialités'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(
                context, '/admin/dashboard'); // Retour à AdminDashboard
          },
        ),
        backgroundColor: Color.fromARGB(255, 129, 123, 194),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddSpecialitePage()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Specialite>>(
        future: specialites,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreurrr: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucune spécialité disponible.'));
          } else {
            List<Specialite> specialitesData = snapshot.data!;
            return ListView.builder(
              itemCount: specialitesData.length,
              itemBuilder: (context, index) {
                final specialite = specialitesData[index];
                return ListTile(
                  title: Text(specialite.nom),
                  subtitle: Text('nom: ${specialite.nom}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      // Appel de la fonction deleteSpecialiteByNom avec le nom de la spécialité
                      await deleteSpecialiteByNom(
                        context,
                        specialite
                            .nom, // Utilisez le nom de la spécialité pour la suppression
                        fetchSpecialites, // Rafraîchit la liste des spécialités
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

Future<List<Specialite>> fetchSpecialites() async {
  final response = await http.get(
      Uri.parse('http://localhost:8084/specialite/retrieve-all-specialites'));

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    print('Réponse brute : $data');

    return data.map((item) => Specialite.fromJson(item)).toList();
  } else {
    print('Erreur: ${response.statusCode}');
    print('Message du serveur: ${response.body}');
    throw Exception('Échec de chargement des spécialités');
  }
}


/*Future<List<Specialite>> fetchSpecialites() async {
  final response = await http.get(Uri.parse('http://192.168.56.1:8084/specialite/retrieve-all-specialites'));

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    print('Réponse bruteeee: $data');  // Affiche les données retournées par l'API

    return data.map((item) {
      return Specialite(
        idSpecialite: '',  // L'ID peut être vide ou généré autrement
        nom: item,  // Utilisez chaque élément de la liste comme nom de spécialité
        matieres: [],  // Ajoutez des matières si nécessaire
      );
    }).toList();
  } else {
    print('Erreur: ${response.statusCode}');
    print('Message du serveur: ${response.body}');
    throw Exception('Failed to load specialites');
  }}*/