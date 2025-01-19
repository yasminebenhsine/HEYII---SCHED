import 'package:flutter/material.dart';
import 'package:heyiisched/models/Matiere_salle.dart';
import 'package:heyiisched/services/Matiere.dart';

import 'package:http/http.dart' as http;

class MatiereListPage extends StatefulWidget {
  const MatiereListPage({Key? key}) : super(key: key);

  @override
  _MatiereListPageState createState() => _MatiereListPageState();
}

class _MatiereListPageState extends State<MatiereListPage> {
  final MatiereService _matiereService = MatiereService();
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _typeController = TextEditingController();
  final _semestreController = TextEditingController();
  final _niveauController = TextEditingController();

  List<Matiere> _matieres = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadMatieres();
  }

  @override
  void dispose() {
    _nomController.dispose();
    _typeController.dispose();
    _semestreController.dispose();
    _niveauController.dispose();
    super.dispose();
  }

  Future<void> _loadMatieres() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final matieres = await _matiereService.getAllMatieres();
      setState(() {
        _matieres = matieres;
        _isLoading = false;
      });
      print('Matières chargées avec succès: ${matieres.length} matières');
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
      print('Erreur lors du chargement des matières: $e');
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _showAddEditDialog([Matiere? matiere]) async {
    final isEditing = matiere != null;
    if (isEditing) {
      _nomController.text = matiere.nom;
      _typeController.text = matiere.type;
      _semestreController.text = matiere.semestre.toString();
      _niveauController.text = matiere.niveau.toString();
    } else {
      _nomController.clear();
      _typeController.clear();
      _semestreController.clear();
      _niveauController.clear();
    }

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? 'Modifier Matière' : 'Ajouter Matière'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nomController,
                  decoration: const InputDecoration(labelText: 'Nom'),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Ce champ est requis' : null,
                ),
                TextFormField(
                  controller: _typeController,
                  decoration: const InputDecoration(labelText: 'Type'),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Ce champ est requis' : null,
                ),
                TextFormField(
                  controller: _semestreController,
                  decoration: const InputDecoration(labelText: 'Semestre'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Ce champ est requis';
                    if (int.tryParse(value!) == null)
                      return 'Entrez un nombre valide';
                    return null;
                  },
                ),
                TextFormField(
                  controller: _niveauController,
                  decoration: const InputDecoration(labelText: 'Niveau'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Ce champ est requis';
                    if (int.tryParse(value!) == null)
                      return 'Entrez un nombre valide';
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState?.validate() ?? false) {
                try {
                 final newMatiere = Matiere(
                    id: isEditing ? matiere.id : DateTime.now().toString(),
                    nom: _nomController.text,
                    type: _typeController.text,
                    semestre: int.parse(_semestreController.text),
                    niveau: int.parse(_niveauController.text),
                    salles: [],
                    specialites: [],
                    cours: [],
                    enseignants: [],
                    voeux: [],
                    admin: null, // Handle this appropriately
                  );



                  if (isEditing) {
                    await _matiereService.updateMatiere(matiere.id, newMatiere);
                    print('Matière mise à jour avec succès: ${newMatiere.nom}');
                    _showSnackBar('Matière mise à jour avec succès');
                  } else {
                    await _matiereService.addMatiere(newMatiere);
                    print('Nouvelle matière ajoutée: ${newMatiere.nom}');
                    _showSnackBar('Matière ajoutée avec succès');
                  }
                  Navigator.of(context).pop();
                  _loadMatieres(); // Reload the list
                } catch (e) {
                  print('Erreur lors de l\'opération: $e');
                  _showSnackBar('Erreur: $e', isError: true);
                }
              }
            },
            child: Text(isEditing ? 'Modifier' : 'Ajouter'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(Matiere matiere) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text('Voulez-vous vraiment supprimer ${matiere.nom} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await _matiereService.deleteMatiere(matiere.id);
                print('Matière supprimée avec succès: ${matiere.nom}');
                _showSnackBar('Matière supprimée avec succès');
                Navigator.of(context).pop();
                _loadMatieres(); // Reload the list
              } catch (e) {
                print('Erreur lors de la suppression: $e');
                _showSnackBar('Erreur lors de la suppression: $e',
                    isError: true);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Matières'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, '/admin/dashboard'); // Retour à AdminDashboard
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadMatieres,
          ),
        ],
         backgroundColor: Color.fromARGB(255, 129, 123, 194),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Erreur: $_error'),
                      ElevatedButton(
                        onPressed: _loadMatieres,
                        child: const Text('Réessayer'),
                      ),
                    ],
                  ),
                )
              : _matieres.isEmpty
                  ? const Center(child: Text('Aucune matière trouvée'))
                  : ListView.builder(
                      itemCount: _matieres.length,
                      itemBuilder: (context, index) {
                        final matiere = _matieres[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          child: ListTile(
                            title: Text(matiere.nom),
                            subtitle: Text(
                                'Type: ${matiere.type} | Semestre: ${matiere.semestre} | Niveau: ${matiere.niveau}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => _showAddEditDialog(matiere),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Color.fromARGB(255, 129, 123, 194)),
                                  onPressed: () => _confirmDelete(matiere),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
// matiere_service.dart
