import 'package:flutter/material.dart';
import 'package:heyiisched/models/Modeles.dart';
import 'package:heyiisched/services/EmploiService.dart';

class EmploiListPage extends StatefulWidget {
  final Enseignant enseignant;  // Add Enseignant parameter

  EmploiListPage({required this.enseignant});  // Constructor

  @override
  _EmploiListPageState createState() => _EmploiListPageState();
}

class _EmploiListPageState extends State<EmploiListPage> {
 // final EmploiService emploiService = EmploiService();
  late Future<List<Emploi>> emplois;

  @override
  void initState() {
    super.initState();
    //emplois = emploiService.fetchEmploiById(widget.enseignant.id); // Fetch emplois for the specific teacher
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Emplois de ${widget.enseignant.nom}"),leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, '/admin/dashboard'); // Retour à AdminDashboard
          },
        ),backgroundColor: Color.fromARGB(255, 129, 123, 194),),
      body: FutureBuilder<List<Emploi>>(
        future: emplois,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucun emploi trouvé pour ${widget.enseignant.nom}'));
          } else {
            List<Emploi> emplois = snapshot.data!;

            return ListView.builder(
              itemCount: emplois.length,
              itemBuilder: (context, index) {
                final emploi = emplois[index];

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Table(
                      border: TableBorder.all(),
                      children: [
                        TableRow(
                          children: [
                            TableCell(child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Jour:', style: TextStyle(fontWeight: FontWeight.bold)),
                            )),
                            TableCell(child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(emploi.jour),
                            )),
                          ],
                        ),
                        TableRow(
                          children: [
                            TableCell(child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Type Emploi:', style: TextStyle(fontWeight: FontWeight.bold)),
                            )),
                            TableCell(child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(emploi.typeEmploi),
                            )),
                          ],
                        ),
                        TableRow(
                          children: [
                            TableCell(child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Heure Début:', style: TextStyle(fontWeight: FontWeight.bold)),
                            )),
                            TableCell(child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(emploi.heureDebut),
                            )),
                          ],
                        ),
                        TableRow(
                          children: [
                            TableCell(child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Heure Fin:', style: TextStyle(fontWeight: FontWeight.bold)),
                            )),
                            TableCell(child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(emploi.heureFin),
                            )),
                          ],
                        ),
                      ],
                    ),
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
