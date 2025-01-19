import 'package:flutter/material.dart';
import 'package:heyiisched/models/Modeles.dart';
import 'package:heyiisched/services/EnseignantService.dart';
import 'package:heyiisched/services/UserService.dart';
import 'package:uuid/uuid.dart';

class AddEnseignantPage extends StatefulWidget {
  final Function onAdd;

  AddEnseignantPage({required this.onAdd});

  @override
  _AddEnseignantPageState createState() => _AddEnseignantPageState();
}

class _AddEnseignantPageState extends State<AddEnseignantPage> {
  final _formKey = GlobalKey<FormState>();
  String nom = '';
  String prenom = '';
  String email = '';
  String motDePasse = '';
  String login = '';
  String telephone = '';
  int cin = 0;
  String dateNaissance = '';
  int nbHeure = 0;
  String grade = 'A'; // Valeur par défaut pour le grade
  List<String> filieres = [];
  List<String> reclamations = [];

  final EnseignantService enseignantService = EnseignantService();
  final UserService userService = UserService(); // Utilisation du service User

  late String id;
  var uuid = Uuid();

  @override
  void initState() {
    super.initState();
    id = uuid.v4(); // Génère un ID UUID version 4 (aléatoire)
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      // Générer un login et mot de passe aléatoires pour l'utilisateur
      String generatedLogin = "user_${uuid.v4()}";
      String generatedPassword = uuid.v4().substring(0, 8); // Utilisation d'un UUID pour un mot de passe aléatoire

      // Créer un objet User
      User user = User(
        idUser: id,
        nom: nom,
        prenom: prenom,
        email: email,
        motDePasse: generatedPassword,
        login: generatedLogin,
        telephone: telephone,
        cin: cin,
        dateNaissance: dateNaissance,
      );

      // Créer un objet Enseignant
      Enseignant enseignant = Enseignant(
        id: id,
        nom: nom,
        prenom: prenom,
        email: email,
        nbHeure: nbHeure,
        grade: Grade.values.firstWhere(
          (e) => e.toString().split('.').last == grade,
          orElse: () => Grade.A,
        ),
        matieres: [],
        cours: [],
        filieres: [],
        specialites: [],
        reclamations: [],
        emploi: null,
        voeux: [],
      );

      try {
        // Ajouter l'utilisateur
        await userService.addUser(user);

        // Ajouter l'enseignant
        await enseignantService.addEnseignant(enseignant);

        // Afficher la notification de succès
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Enseignant ajouté avec succès !'),
            backgroundColor: Colors.green,
          ),
        );

        // Appeler la fonction onAdd pour notifier l'ajout de l'enseignant
        widget.onAdd();

        // Navigation vers la page de récupération des enseignants
        Navigator.pushReplacementNamed(context, '/enseignants/retrieve-all-enseignants');
      } catch (e) {
        // Afficher la notification d'erreur
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de l\'ajout : $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajouter Enseignant"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Nom'),
                onSaved: (value) => nom = value ?? '',
                validator: (value) => value?.isEmpty ?? true ? 'Nom requis' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Prénom'),
                onSaved: (value) => prenom = value ?? '',
                validator: (value) => value?.isEmpty ?? true ? 'Prénom requis' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                onSaved: (value) => email = value ?? '',
                validator: (value) => value?.isEmpty ?? true ? 'Email requis' : null,
              ),
              // Ajoutez d'autres champs de formulaire ici pour mot de passe, login, téléphone, etc.

              ElevatedButton(
                onPressed: _submitForm,
                child: Text("Ajouter Enseignant"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


/*
class AddEnseignantPage extends StatefulWidget {
  final VoidCallback onAdd;

  AddEnseignantPage({required this.onAdd});

  @override
  _AddEnseignantPageState createState() => _AddEnseignantPageState();
}

class _AddEnseignantPageState extends State<AddEnseignantPage> {
  final _formKey = GlobalKey<FormState>();
  final EnseignantService _enseignantService = EnseignantService();

  String _nom = '';
  String _prenom = '';
  String _email = '';
  int _nbHeure = 0;
  Grade? _grade;
  List<Matiere> _selectedMatieres = [];
  List<Cours> _selectedCours = [];
  List<Filiere> _selectedFilieres = [];
  List<Specialite> _selectedSpecialites = [];
  List<Voeux> _selectedVoeux = [];

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Enseignant nouvelEnseignant = Enseignant(
        id: '',
        nom: _nom,
        prenom: _prenom,
        email: _email,
        nbHeure: _nbHeure,
        grade: _grade,
        matieres: _selectedMatieres,
        cours: _selectedCours,
        filieres: _selectedFilieres,
        specialites: _selectedSpecialites,
        voeux: _selectedVoeux,
        reclamations: [],
        emploi: null,
      );

      try {
        await _enseignantService.addEnseignant(nouvelEnseignant);
        widget.onAdd();
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'ajout de l\'enseignant: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ajouter un Enseignant')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Nom'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez saisir un nom';
                    }
                    return null;
                  },
                  onSaved: (value) => _nom = value!,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Prénom'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez saisir un prénom';
                    }
                    return null;
                  },
                  onSaved: (value) => _prenom = value!,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez saisir un email';
                    }
                    return null;
                  },
                  onSaved: (value) => _email = value!,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Nombre d\'heures'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty || int.tryParse(value) == null) {
                      return 'Veuillez saisir un nombre valide';
                    }
                    return null;
                  },
                  onSaved: (value) => _nbHeure = int.parse(value!),
                ),
                DropdownButtonFormField<Grade>(
                  decoration: InputDecoration(labelText: 'Grade'),
                  items: Grade.values.map((grade) {
                    return DropdownMenuItem(
                      value: grade,
                      child: Text(grade.toString().split('.').last),
                    );
                  }).toList(),
                  onChanged: (value) => _grade = value,
                ),
                // Ajoutez des champs pour les listes (matières, cours, etc.) selon vos besoins
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Ajouter'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
*/