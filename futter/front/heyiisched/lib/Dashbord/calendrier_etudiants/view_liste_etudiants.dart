// lib/Dashbord/calendrier_etudiants/view_liste_etudiants.dart
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class Etudiant {
  final String idUser;
  final String nom;
  final String prenom;
  final String email;
  final String grpClass;

  Etudiant({
    required this.idUser,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.grpClass,
  });

  factory Etudiant.fromJson(Map<String, dynamic> json) {
    return Etudiant(
      idUser: json['idUser'],
      nom: json['nom'],
      prenom: json['prenom'],
      email: json['email'],
      grpClass: json['grpClass']['nom'] ?? '', // Accédez au nom du groupe de classe
    );
  }
}

class EtudiantPage extends StatefulWidget {
  @override
  _EtudiantPageState createState() =>  _EtudiantPageState();
}

class  _EtudiantPageState extends State<EtudiantPage> {
  late Future<List<Etudiant>> _etudiants;

  @override
  void initState() {
    super.initState();
    _etudiants = fetchEtudiants();
  }

  Future<List<Etudiant>> fetchEtudiants() async {
    final response = await http.get(Uri.parse('http://192.168.56.1:8084/etudiant/retrieve-all-etudiants-classe'));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      print("response.body  "+response.body);
      List<Etudiant> etudiants = jsonData.map((json) => Etudiant.fromJson(json)).toList();
      etudiants.sort((a, b) => a.grpClass.compareTo(b.grpClass)); // Trie par nom de groupe de classe
      return etudiants;
    } else {
       print("response.body  "+response.body );
      throw Exception('Failed to load students');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Etudiants'),   backgroundColor: Color.fromARGB(255, 129, 123, 194),
      ),
      body: FutureBuilder<List<Etudiant>>(
        future: _etudiants,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucun étudiant trouvé.'));
          } else {
            List<Etudiant> etudiants = snapshot.data!;
            return ListView.builder(
              itemCount: etudiants.length,
              itemBuilder: (context, index) {
                final etudiant = etudiants[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text('${etudiant.nom} ${etudiant.prenom}'),
                    subtitle: Text('Email: ${etudiant.email}'),
                    trailing: Text('Groupe: ${etudiant.grpClass}'),
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

