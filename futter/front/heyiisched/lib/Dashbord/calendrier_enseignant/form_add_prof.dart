import 'package:flutter/material.dart';
import 'package:heyiisched/models/Matiere_salle.dart';
import 'package:heyiisched/models/Modeles.dart';
// Assurez-vous que l'importation du modèle Enseignant est correcte.
import 'package:heyiisched/services/EnseignantService.dart';  // Import du service

class AddTeacherForm extends StatefulWidget {
  final Function(Enseignant) onAddTeacher;

  AddTeacherForm({required this.onAddTeacher});

  @override
  _AddTeacherFormState createState() => _AddTeacherFormState();
}

class _AddTeacherFormState extends State<AddTeacherForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nomController = TextEditingController();
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController motDePasseController = TextEditingController();
  final TextEditingController loginController = TextEditingController();
  final TextEditingController telephoneController = TextEditingController();
  final TextEditingController cinController = TextEditingController();
  final TextEditingController dateNaissanceController = TextEditingController();
  final TextEditingController nbHeureController = TextEditingController();

  Grade? selectedGrade = Grade.A;

  final EnseignantService enseignantService = EnseignantService();  // Instance du service

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add New Teacher"),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Champs de formulaire pour les données de l'enseignant
              TextFormField(
                controller: nomController,
                decoration: InputDecoration(labelText: 'Nom'),
                validator: (value) => value!.isEmpty ? 'Please enter name' : null,
              ),
              TextFormField(
                controller: prenomController,
                decoration: InputDecoration(labelText: 'Prénom'),
                validator: (value) => value!.isEmpty ? 'Please enter first name' : null,
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) => value!.isEmpty ? 'Please enter email' : null,
              ),
              TextFormField(
                controller: motDePasseController,
                decoration: InputDecoration(labelText: 'Mot de Passe'),
                validator: (value) => value!.isEmpty ? 'Please enter password' : null,
              ),
              TextFormField(
                controller: loginController,
                decoration: InputDecoration(labelText: 'Login'),
                validator: (value) => value!.isEmpty ? 'Please enter login' : null,
              ),
              TextFormField(
                controller: telephoneController,
                decoration: InputDecoration(labelText: 'Téléphone'),
                validator: (value) => value!.isEmpty ? 'Please enter phone number' : null,
              ),
              TextFormField(
                controller: cinController,
                decoration: InputDecoration(labelText: 'CIN'),
                validator: (value) => value!.isEmpty ? 'Please enter CIN' : null,
              ),
              TextFormField(
                controller: dateNaissanceController,
                decoration: InputDecoration(labelText: 'Date de Naissance'),
                validator: (value) => value!.isEmpty ? 'Please enter birth date' : null,
              ),
              TextFormField(
                controller: nbHeureController,
                decoration: InputDecoration(labelText: 'Nombre d\'heures'),
                validator: (value) => value!.isEmpty ? 'Please enter hours' : null,
              ),
              DropdownButtonFormField<Grade>(
                value: selectedGrade,
                decoration: InputDecoration(labelText: 'Grade'),
                onChanged: (Grade? newValue) {
                  setState(() {
                    selectedGrade = newValue;
                  });
                },
                items: Grade.values.map<DropdownMenuItem<Grade>>((Grade value) {
                  return DropdownMenuItem<Grade>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Fermer le formulaire
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              // Vérification du nombre d'heures
              if (int.tryParse(nbHeureController.text) == null) {
                print('Le nombre d\'heures est invalide');
                return;
              }
              final newTeacher = Enseignant(
                id: '', // Laissez vide ou ajoutez un ID si nécessaire
                nom: nomController.text,
                prenom: prenomController.text,
                email: emailController.text,
                nbHeure: int.parse(nbHeureController.text),
                grade: selectedGrade!,
                matieres: [],  // Ajouter les matières si nécessaire
                cours: [],  // Ajouter les cours si disponible
                filieres: [],  // Ajouter les filières si disponible
                specialites: [],  // Ajouter les spécialités si disponible
                reclamations: [],  // Ajouter les réclamations si nécessaire
                emploi: Emploi(
                  typeEmploi: "Cours",
                  jour: "Lundi",
                  heureDebut: "08:00",
                  heureFin: "10:00",
                  enseignant: [],  // Assignation de l'enseignant au emploi
                  groupeClasse: [],
                  salles: [],
                  matiere: Matiere(nom: "Mathematics", enseignants: [], type: '', semestre: 1, specialites: [], salles: [], niveau: 1, voeux: [], id: '', cours: []),
                ),
                voeux: [],  // Ajouter les voeux si nécessaire
              );

              try {
                // Ajouter l'enseignant via le service
                await enseignantService.addEnseignant(newTeacher);  
                widget.onAddTeacher(newTeacher);  // Ajouter l'enseignant à la liste dans la page d'accueil
                Navigator.pop(context);  // Fermer le formulaire après l'ajout
              } catch (e) {
                print('Erreur lors de l\'ajout de l\'enseignant: $e');
                // Vous pouvez afficher un message d'erreur à l'utilisateur ici
              }
            }
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
