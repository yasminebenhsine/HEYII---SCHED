import 'package:flutter/material.dart';
import 'package:heyiisched/models/Modeles.dart';


// Barre de recherche pour les salles
Widget buildSalleSearchBar() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextField(
      decoration: InputDecoration(
        hintText: 'Rechercher des salles...',
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );
}

// Une ligne pour chaque salle
DataRow buildSalleRow(Salle salle, Function onDelete, Function onEdit, Function onDetails) {
  return DataRow(
    cells: [
      DataCell(Text(salle.nom)),
      DataCell(Text(salle.type)),
      DataCell(Text(salle.capacite.toString())), // Capacite affichée
      DataCell(Text(salle.isDispo ? "Disponible" : "Occupée")), // Disponibilité
      DataCell(
        Row(
          children: [
            IconButton(icon: Icon(Icons.edit), onPressed: () => onEdit(salle)),
            IconButton(icon: Icon(Icons.delete), onPressed: () => onDelete(salle)),
            IconButton(icon: Icon(Icons.info), onPressed: () => onDetails(salle)),
          ],
        ),
      ),
    ],
  );
}

// Tableau pour afficher les salles
Widget buildSalleTable(List<Salle> salles, Function onDelete, Function onEdit, Function onDetails) {
  return DataTable(
    columns: [
      DataColumn(label: Text('Nom')),
      DataColumn(label: Text('Type')),
      DataColumn(label: Text('Capacité')),
      DataColumn(label: Text('Disponibilité')),
      DataColumn(label: Text('Actions')),
    ],
    rows: salles.map((salle) => buildSalleRow(salle, onDelete, onEdit, onDetails)).toList(),
  );
}

// Bouton pour ajouter une salle
Widget buildAddSalleButton(Function onAddSalle) {
  return ElevatedButton.icon(
    icon: Icon(Icons.add),
    label: Text('Ajouter une salle'),
    onPressed: () => onAddSalle(),
  );
}

// Exemple d'écran pour gérer les salles
class SalleManagementScreen extends StatelessWidget {
  final List<Salle> salles;
  final Function onAddSalle;
  final Function onDeleteSalle;
  final Function onEditSalle;
  final Function onDetailsSalle;

  SalleManagementScreen({
    required this.salles,
    required this.onAddSalle,
    required this.onDeleteSalle,
    required this.onEditSalle,
    required this.onDetailsSalle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion des Salles'),
      ),
      body: Column(
        children: [
          buildSalleSearchBar(),
          Expanded(
            child: SingleChildScrollView(
              child: buildSalleTable(salles, onDeleteSalle, onEditSalle, onDetailsSalle),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: buildAddSalleButton(onAddSalle),
          ),
        ],
      ),
    );
  }
}
