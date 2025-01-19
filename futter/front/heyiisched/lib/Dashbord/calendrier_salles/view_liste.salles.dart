// lib/pages/salle_page.dart
import 'package:flutter/material.dart';
import 'package:heyiisched/Dashbord/calendrier_salles/salle_table.dart';
import 'package:heyiisched/models/Modeles.dart';
import 'package:heyiisched/services/salle_service.dart';
// Créez ce widget pour afficher la table des salles

class SallePage extends StatefulWidget {
  @override
  _SallePageState createState() => _SallePageState();
}

class _SallePageState extends State<SallePage> {
  List<Salle> salles = [];
  final SalleService apiService = SalleService();

  @override
  void initState() {
    super.initState();
    fetchSalles();
  }

  // Charger les salles depuis l'API
  Future<void> fetchSalles() async {
    try {
      final fetchedSalles = await apiService.fetchSalles();
      setState(() {
        salles = fetchedSalles;
      });
    } catch (e) {
      print('Erreur de chargement des salles: $e');
    }
  }

  // Ajouter une salle
  void onAddSalle() {
    // Code pour ajouter une salle
    print('Ajouter une salle');
  }

  // Supprimer une salle
  void onDeleteSalle(Salle salle) async {
    try {
      await apiService.deleteSalle(salle.id);
      setState(() {
        salles.remove(salle);
      });
    } catch (e) {
      print('Erreur lors de la suppression de la salle: $e');
    }
  }

  // Modifier une salle
  void onEditSalle(Salle salle) {
    print('Modifier ${salle.nom}');
    // Ajouter la logique pour modifier la salle
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Liste des salles'), 
      backgroundColor: Color.fromARGB(255, 129, 123, 194),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Ajoutez une barre de recherche ou d'autres widgets ici si nécessaire
            Expanded(
              child: SalleTable(
                salles: salles,
                onDeleteSalle: onDeleteSalle,
                onEditSalle: onEditSalle,
              ),
            ),
            ElevatedButton.icon(
              icon: Icon(Icons.add),
              label: Text('Ajouter une salle'),
              onPressed: onAddSalle,
            ),
          ],
        ),
      ),
    );
  }
}
