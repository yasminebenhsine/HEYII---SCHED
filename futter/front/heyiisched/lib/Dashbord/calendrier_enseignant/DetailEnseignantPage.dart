import 'package:flutter/material.dart';
import 'package:heyiisched/models/Modeles.dart';
import 'package:heyiisched/services/EnseignantService.dart';

class DetailEnseignantPage extends StatelessWidget {
  final String enseignantId;

  DetailEnseignantPage({required this.enseignantId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de l\'Enseignant'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(
                context, '/admin/dashboard'); // Retour à AdminDashboard
          },
        ),
        backgroundColor: Color.fromARGB(255, 129, 123, 194),
      ),
      body: FutureBuilder<Enseignant>(
        future: EnseignantService().fetchEnseignantById(enseignantId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Aucun détail disponible.'));
          } else {
            final enseignant = snapshot.data!;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nom: ${enseignant.nom ?? 'Nom inconnu'}',
                      style: TextStyle(fontSize: 20)),
                  Text('Prénom: ${enseignant.prenom}',
                      style: TextStyle(fontSize: 16)),
                  Text('Email: ${enseignant.email}',
                      style: TextStyle(fontSize: 16)),
                  Text('Nombre d\'heures: ${enseignant.nbHeure}',
                      style: TextStyle(fontSize: 16)),
                  Text(
                      'Grade: ${enseignant.grade?.toString().split('.').last ?? 'Grade inconnu'}',
                      style: TextStyle(fontSize: 16)),
                  Text(
                      'Matieres: ${enseignant.matieres.map((e) => e.nom).join(', ') ?? 'Aucune matière'}',
                      style: TextStyle(fontSize: 16)),
                  //Text('Filieres: ${enseignant.filieres.map((e) => e.nom).join(', ') ?? 'Aucune filière'}', style: TextStyle(fontSize: 16)),
                  //Text('Spécialités: ${enseignant.specialites.map((e) => e.nom).join(', ') ?? 'Aucune spécialité'}', style: TextStyle(fontSize: 16)),
                  //Text('Réclamations: ${enseignant.reclamations.length > 0 ? enseignant.reclamations.length : 'Aucune réclamation'}', style: TextStyle(fontSize: 16)),
                  //Text('Voeux: ${enseignant.voeux.length > 0 ? enseignant.voeux.length : 'Aucun vœu'}', style: TextStyle(fontSize: 16)),
                  // Ajoutez d'autres détails comme l'Emploi, Cours, etc.
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
