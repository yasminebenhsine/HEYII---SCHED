import 'package:flutter/material.dart';
import 'package:heyiisched/models/Modeles.dart';

import 'package:heyiisched/services/grpclassseEtudiant.dart';

class StudentsPage extends StatefulWidget {
  final String groupeId;

  StudentsPage({required this.groupeId});

  @override
  _StudentsPageState createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {
  late Future<List<Etudiant>> futureEtudiants;

  @override
  void initState() {
    super.initState();
    futureEtudiants = EtudiantService().getEtudiantsByGroupe(widget.groupeId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Étudiants du groupe ${widget.groupeId}'),
      ),
      body: FutureBuilder<List<Etudiant>>(
        future: futureEtudiants,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('Erreur: ${snapshot.error}');
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucun étudiant trouvé.'));
          } else {
            List<Etudiant> etudiants = snapshot.data!;

            return ListView.builder(
              itemCount: etudiants.length,
              itemBuilder: (context, index) {
                Etudiant etudiant = etudiants[index];
                return ListTile(
                  title: Text('${etudiant.nom} ${etudiant.prenom}'),
                  subtitle: Text('ID: ${etudiant.id}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
