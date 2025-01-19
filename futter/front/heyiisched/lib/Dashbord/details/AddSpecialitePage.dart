import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:heyiisched/Dashbord/details/AddMatierePage.dart';
import 'package:http/http.dart' as http;
import 'package:heyiisched/models/specialite.dart';

class AddSpecialitePage extends StatefulWidget {
  @override
  _AddSpecialitePageState createState() => _AddSpecialitePageState();
}

class _AddSpecialitePageState extends State<AddSpecialitePage> {
  final TextEditingController _nomController = TextEditingController();
  List<Matiere> matieres = [];
  List<String> _selectedMatieres = [];

  @override
  void initState() {
    super.initState();
    fetchMatieres().then((data) {
      setState(() {
        matieres = data;
      });
    }).catchError((error) {
      print('Erreur : $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter une Spécialité'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nomController,
              decoration: InputDecoration(labelText: 'Nom de la spécialité'),
            ),
            /*ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddMatierePage()),
                ).then((_) {
                  fetchMatieres().then((data) {
                    setState(() {
                      matieres = data;
                    });
                  });
                });
              },
              child: Text('Ajouter une nouvelle Matière'),
            ),*/
            Expanded(
              child: ListView(
                children: matieres.map((matiere) {
                  return CheckboxListTile(
                    title: Text(matiere.nom),
                    value: _selectedMatieres.contains(matiere.idMatiere),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          _selectedMatieres.add(matiere.idMatiere);
                        } else {
                          _selectedMatieres.remove(matiere.idMatiere);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final nom = _nomController.text;
                if (nom.isEmpty || _selectedMatieres.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text('Nom et matières doivent être sélectionnés.')),
                  );
                  return;
                }
                addSpecialite(nom, _selectedMatieres, context);
              },
              child: Text('Ajouter Spécialité'),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Matiere>> fetchMatieres() async {
    final response = await http.get(
        Uri.parse('http://192.168.56.1:8084/matiere/retrieve-all-matieres'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Matiere.fromJson(item)).toList();
    } else {
      throw Exception('Erreur lors du chargement des matières');
    }
  }

  Future<void> addSpecialite(
      String nom, List<String> matiereIds, BuildContext context) async {
    final url = 'http://192.168.56.1:8084/specialite/create';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json'
      }, // Assurez-vous que le Content-Type est seulement 'application/json'
      body: json.encode({
        'nom': nom,
        'matiereIds': matiereIds,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Spécialité ajoutée avec succès.')));
      Navigator.pop(context);
    } else {
      print('Erreur : ${response.body}');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erreur lors de l\'ajout.')));
    }
  }
}
