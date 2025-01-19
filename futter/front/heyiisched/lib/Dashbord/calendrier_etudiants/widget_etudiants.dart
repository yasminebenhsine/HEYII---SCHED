import 'package:flutter/material.dart';
import 'package:heyiisched/models/Modeles.dart';


// Barre de recherche pour les étudiants
Widget buildStudentSearchBar() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextField(
      decoration: InputDecoration(
        hintText: 'Rechercher des étudiants...',
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );
}

// Une ligne pour chaque étudiant
DataRow buildStudentRow(Etudiant etudiant, Function onDelete, Function onEdit, Function onDetails) {
  return DataRow(
    cells: [
      DataCell(Text(etudiant.nom)),
      DataCell(Text(etudiant.prenom)),
      DataCell(Text(etudiant.email)),
      DataCell(Text(etudiant.grpClass.nom)), // Groupe associé
      DataCell(
        Row(
          children: [
            IconButton(icon: Icon(Icons.edit), onPressed: () => onEdit(etudiant)),
            IconButton(icon: Icon(Icons.delete), onPressed: () => onDelete(etudiant)),
            IconButton(icon: Icon(Icons.info), onPressed: () => onDetails(etudiant)),
          ],
        ),
      ),
    ],
  );
}

// Tableau pour afficher les étudiants
Widget buildStudentTable(List<Etudiant> etudiants, Function onDelete, Function onEdit, Function onDetails) {
  return DataTable(
    columns: [
      DataColumn(label: Text('Nom')),
      DataColumn(label: Text('Prénom')),
      DataColumn(label: Text('Email')),
      DataColumn(label: Text('Groupe')),
      DataColumn(label: Text('Actions')),
    ],
    rows: etudiants.map((etudiant) => buildStudentRow(etudiant, onDelete, onEdit, onDetails)).toList(),
  );
}

// Bouton pour ajouter un étudiant
Widget buildAddStudentButton(Function onAddStudent) {
  return ElevatedButton.icon(
    icon: Icon(Icons.add),
    label: Text('Ajouter un étudiant'),
    onPressed: () => onAddStudent(),
  );
}
