import 'package:flutter/material.dart';
import 'package:heyiisched/models/Modeles.dart';
import 'package:heyiisched/services/salle_service.dart';
import 'package:flutter/material.dart';
import 'package:heyiisched/models/Modeles.dart';
import 'package:heyiisched/services/salle_service.dart';

class AddSallePage extends StatefulWidget {
  @override
  _AddSallePageState createState() => _AddSallePageState();
}

class _AddSallePageState extends State<AddSallePage> {
  final _formKey = GlobalKey<FormState>();
  final SalleService salleService = SalleService();

  String type = '';
  String nom = '';
  int capacite = 0;
  bool isDispo = true;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final newSalle = Salle(
        id: '', // Généré par le backend
        type: type,
        nom: nom,
        capacite: capacite,
        isDispo: isDispo,
        matieres: [],
        datees: [],
        admin: null,
        emploi: null,
        voeux: [],
        cours: [],
      );

      try {
        await salleService.addSalle(newSalle);
        if (!mounted) return;
        Navigator.pop(context, true); // Retourner à la page précédente avec succès
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur : ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ajouter une salle')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nom de la salle'),
                onChanged: (value) => nom = value,
                validator: (value) => value!.isEmpty ? 'Nom requis' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Type de salle'),
                onChanged: (value) => type = value,
                validator: (value) => value!.isEmpty ? 'Type requis' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Capacité'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  try {
                    capacite = int.parse(value);
                  } catch (_) {
                    capacite = 0;
                  }
                },
                validator: (value) =>
                    value!.isEmpty ? 'Capacité requise' : null,
              ),
              SwitchListTile(
                title: Text('Disponible'),
                value: isDispo,
                onChanged: (value) => setState(() {
                  isDispo = value;
                }),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Ajouter Salle'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*

class AddSallePage extends StatefulWidget {
  const AddSallePage({Key? key})
      : super(key: key); // Added a key parameter for widget constructors

  @override
  State<AddSallePage> createState() => _AddSallePageState();
}

class _AddSallePageState extends State<AddSallePage> {
  final _formKey = GlobalKey<FormState>();
  final SalleService salleService = SalleService();

  String type = '';
  String nom = '';
  int capacite = 0;
  bool isDispo = true;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final newSalle = Salle(
        id: '', // Backend-generated
        type: type,
        nom: nom,
        capacite: capacite,
        isDispo: isDispo,
        matieres: [],
        datees: [],
        admin: null, // Set admin to null
        emploi: null, // Set emploi to null
        voeux: [],
        cours: [],
      );

      try {
        await salleService.addSalle(newSalle);
        if (!mounted) return; // Check if the widget is still mounted
        Navigator.pop(context); // Navigate back to the previous screen
      } catch (error) {
        if (!mounted) return; // Check again for safety
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: ${error.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter une Salle'),
        backgroundColor: const Color(0xFF5C5792),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nom de la salle'),
                onChanged: (value) => nom = value,
                validator: (value) => value!.isEmpty ? 'Nom requis' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Type'),
                onChanged: (value) => type = value,
                validator: (value) => value!.isEmpty ? 'Type requis' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Capacité'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  try {
                    capacite = int.parse(value);
                  } catch (_) {
                    capacite = 0; // Handle invalid input
                  }
                },
                validator: (value) =>
                    value!.isEmpty ? 'Capacité requise' : null,
              ),
              SwitchListTile(
                title: const Text('Disponible'),
                value: isDispo,
                onChanged: (value) => setState(() {
                  isDispo = value;
                }),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5C5792),
                ), // Fixed the incorrect named parameter 'primary'
                onPressed: _submitForm,
                child: const Text('Ajouter Salle'), // Added const
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/