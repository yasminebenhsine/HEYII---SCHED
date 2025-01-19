// widget_calendrier_enseignant.dart
import 'package:flutter/material.dart';
import 'package:heyiisched/models/Modeles.dart';
import 'package:heyiisched/models/classe_models.dart';


Widget buildSearchBar() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextField(
      decoration: InputDecoration(
        hintText: 'Search for teachers...',
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );
}

// Change the return type of buildTeacherRow to DataRow
DataRow buildTeacherRow(Enseignant enseignant, Function onDelete, Function onEdit, Function onEmploi) {
  print('Nom: ${enseignant.nom}, Prénom: ${enseignant.prenom}, Email: ${enseignant.email}, Grade: ${enseignant.grade}');

  return DataRow(
    cells: [
      DataCell(Text(enseignant.nom ?? 'No name')),  // Provide default value if null
      DataCell(Text(enseignant.prenom ?? 'No surname')),  // Provide default value if null
      DataCell(Text(enseignant.email ?? 'No email')),  // Provide default value if null
      //DataCell(Text(enseignant.grade.toString().split('.').last ?? 'No grade')),  // Default value for grade
      DataCell(
        Row(
          children: [
           // IconButton(icon: Icon(Icons.edit), onPressed: () => onEdit(enseignant)),
            IconButton(icon: Icon(Icons.delete), onPressed: () => onDelete(enseignant)),
            IconButton(icon: Icon(Icons.calendar_today), onPressed: () => onEmploi(enseignant)),
          ],
        ),
      ),
    ],
  );
}


Widget buildTeacherTable(List<Enseignant> enseignants, Function onDelete, Function onEdit, Function onEmploi) {
  return DataTable(
    columns: [
      DataColumn(label: Text('Nom')),
      DataColumn(label: Text('Prénom')),
      DataColumn(label: Text('Email')),
      //DataColumn(label: Text('Grade')),
      DataColumn(label: Text('Actions')),
    ],
    rows: enseignants.map((enseignant) => buildTeacherRow(enseignant, onDelete, onEdit, onEmploi)).toList(),
  );
}
/*
Widget buildAddTeacherButton(Function onAddTeacher) {
  return ElevatedButton.icon(
    icon: Icon(Icons.add),
    label: Text('Add Teacher'),
    onPressed: () => onAddTeacher(),
  );
}*/
