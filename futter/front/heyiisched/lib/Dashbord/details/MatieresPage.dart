import 'package:flutter/material.dart';
import 'package:heyiisched/models/Matiere_salle.dart';


import 'package:heyiisched/services/MatiereService.dart';


class MatieresPage extends StatelessWidget {
  final String specialiteId;

  MatieresPage({required this.specialiteId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Liste des matières')),
      body: FutureBuilder<List<Matiere>>(
        future: MatiereService.fetchMatieresBySpecialite(specialiteId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucune matière disponible.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final matiere = snapshot.data![index];
                return ListTile(
                  title: Text(matiere.nom),
                  
                );
              },
            );
          }
        },
      ),
    );
  }
}
