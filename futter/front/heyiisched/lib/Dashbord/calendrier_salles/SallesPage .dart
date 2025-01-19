import 'package:flutter/material.dart';
import 'package:heyiisched/Dashbord/calendrier_salles/AddSallePage%20.dart';
import 'package:heyiisched/models/Modeles.dart';
import 'package:heyiisched/services/salle_service.dart';
 // Assurez-vous que cette page existe.
 // lib/pages/salle_page.dart
import 'package:flutter/material.dart';
import 'package:heyiisched/Dashbord/calendrier_salles/salle_table.dart';
import 'package:heyiisched/models/Modeles.dart';
import 'package:heyiisched/services/salle_service.dart';
/*
class SallesPage extends StatefulWidget {
  @override
  _SallesPageState createState() => _SallesPageState();
}

class _SallesPageState extends State<SallesPage> {
  List<Salle> salles = [];
  List<Salle> filteredSalles = [];
  final SalleService apiService = SalleService();
  bool? filterByDispo;

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
        _applyFilter();
      });
    } catch (e) {
      print('Erreur de chargement des salles: $e');
    }
  }

  // Appliquer le filtre
  void _applyFilter() {
    setState(() {
      if (filterByDispo == null) {
        filteredSalles = List.from(salles);
      } else {
        filteredSalles =
            salles.where((salle) => salle.isDispo == filterByDispo).toList();
      }
    });
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
        _applyFilter();
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
      appBar: AppBar(
        title: Text('Liste des salles'),
        actions: [
          PopupMenuButton<bool?>(
            icon: Icon(Icons.filter_list),
            tooltip: 'Filtrer par disponibilité',
            onSelected: (bool? value) {
              setState(() {
                filterByDispo = value;
                _applyFilter();
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<bool?>>[
              PopupMenuItem<bool?>(
                value: null,
                child: Text('Toutes les salles'),
              ),
              PopupMenuItem<bool?>(
                value: true,
                child: Text('Salles disponibles'),
              ),
              PopupMenuItem<bool?>(
                value: false,
                child: Text('Salles non disponibles'),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            if (filterByDispo != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Chip(
                  label: Text(
                    filterByDispo == true
                        ? 'Filtre: Disponibles'
                        : 'Filtre: Non disponibles',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                  deleteIcon: Icon(Icons.close, color: Colors.white),
                  onDeleted: () {
                    setState(() {
                      filterByDispo = null;
                      _applyFilter();
                    });
                  },
                ),
              ),
            Expanded(
              child: filteredSalles.isEmpty
                  ? Center(
                      child: Text(
                        salles.isEmpty
                            ? 'Aucune salle disponible'
                            : 'Aucune salle ne correspond aux critères',
                      ),
                    )
                  : SalleTable(
                      salles: filteredSalles,
                      onDeleteSalle: onDeleteSalle,
                      onEditSalle: onEditSalle,
                    ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: ElevatedButton.icon(
                icon: Icon(Icons.add),
                label: Text('Ajouter une salle'),
                onPressed: onAddSalle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/

class SallesPage extends StatefulWidget {
  @override
  _SallesPageState createState() => _SallesPageState();
}

class _SallesPageState extends State<SallesPage> {
  late Future<List<Salle>> sallesFuture;

  @override
  void initState() {
    super.initState();
    sallesFuture = _loadSalles();
  }

  Future<List<Salle>> _loadSalles() async {
    try {
      List<Salle> salles = await SalleService().fetchSalles();
      return salles;
    } catch (e) {
      throw Exception('Error loading salles: $e');
    }
  }

  Future<void> _updateSalle(Salle salle) async {
    final TextEditingController nameController =
        TextEditingController(text: salle.nom);
    final TextEditingController typeController =
        TextEditingController(text: salle.type);
    final TextEditingController capacityController =
        TextEditingController(text: salle.capacite.toString());

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Modifier la salle'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Nom de la salle'),
              ),
              TextField(
                controller: typeController,
                decoration: InputDecoration(labelText: 'Type de salle'),
              ),
              TextField(
                controller: capacityController,
                decoration: InputDecoration(labelText: 'Capacité'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              final updatedSalle = Salle(
                id: salle.id, // Use existing ID
                nom: nameController.text,
                type: typeController.text,
                capacite:
                    int.tryParse(capacityController.text) ?? salle.capacite,
                isDispo: salle.isDispo,
                matieres: salle.matieres,
                datees: salle.datees,
                admin: salle.admin,
                emploi: salle.emploi,
                voeux: salle.voeux,
                cours: salle.cours,
              );

              try {
                await SalleService().updateSalle(updatedSalle.id, updatedSalle);
                Navigator.pop(context);
                setState(() {
                  sallesFuture = _loadSalles();
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Salle modifiée avec succès')),
                );
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erreur lors de la modification: $e')),
                );
              }
            },
            child: Text('Modifier'),
          ),
        ],
      ),
    );
  }

Future<void> _deleteSalle(String salleId) async {
  print("Attempting to delete salle with ID: $salleId"); // Ajout pour débogage
  try {
    await SalleService().deleteSalle(salleId);
    setState(() {
      sallesFuture = _loadSalles();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Salle supprimée avec succès')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erreur lors de la suppression: $e')),
    );
  }
}


  void _addSalle() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddSallePage()),
    ).then((value) {
      if (value == true) {
        setState(() {
          sallesFuture = _loadSalles();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Salles'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, '/admin/dashboard'); // Retour à AdminDashboard
          },
        ),
        backgroundColor: Color.fromARGB(255, 129, 123, 194),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Salle>>(
              future: sallesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Aucune salle trouvée.'));
                } else {
                  final salles = snapshot.data!;
                  return ListView.builder(
                    itemCount: salles.length,
                    itemBuilder: (context, index) {
                      final salle = salles[index];
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: ListTile(
                          title: Text(salle.nom),
                          subtitle:
                              Text('${salle.type} - Capacité: ${salle.capacite}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                           /* children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () => _updateSalle(salle),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => _deleteSalle(salle.id),
                              ),
                            ],*/
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              icon: Icon(Icons.add),
              label: Text('Ajouter une salle'),
              onPressed: _addSalle,
            ),
          ),
        ],
      ),
    );
  }
}
