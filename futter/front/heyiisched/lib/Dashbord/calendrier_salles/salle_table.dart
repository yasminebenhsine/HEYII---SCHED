// lib/widgets/salle_table.dart
import 'package:flutter/material.dart';
import 'package:heyiisched/models/Modeles.dart';


class SalleTable extends StatelessWidget {
  final List<Salle> salles;
  final Function(Salle) onDeleteSalle;
  final Function(Salle) onEditSalle;

  SalleTable({
    required this.salles,
    required this.onDeleteSalle,
    required this.onEditSalle,
  });

  DataRow buildSalleRow(Salle salle) {
    return DataRow(
      cells: [
        DataCell(Text(salle.nom)),
        DataCell(Text(salle.type)),
        DataCell(Text(salle.capacite.toString())),
        DataCell(Text(salle.isDispo ? "Disponible" : "Occupée")),
        DataCell(
          Row(
            children: [
              IconButton(icon: Icon(Icons.edit), onPressed: () => onEditSalle(salle)),
              IconButton(icon: Icon(Icons.delete), onPressed: () => onDeleteSalle(salle)),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: [
        DataColumn(label: Text('Nom')),
        DataColumn(label: Text('Type')),
        DataColumn(label: Text('Capacité')),
        DataColumn(label: Text('Disponibilité')),
        DataColumn(label: Text('Actions')),
      ],
      rows: salles.map((salle) => buildSalleRow(salle)).toList(),
    );
  }
}
