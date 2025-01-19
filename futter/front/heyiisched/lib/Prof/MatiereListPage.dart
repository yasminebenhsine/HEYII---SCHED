import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:heyiisched/models/Matiere_salle.dart';
import 'package:heyiisched/services/EnseignantService.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Fonction pour sauvegarder l'ID de l'enseignant
Future<void> saveEnseignantId(String enseignantId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  
  // Créer un objet utilisateur avec un ID
  final userData = json.encode({
    'id': enseignantId,
  });

  await prefs.setString('userData', userData);  // Sauvegarder l'objet utilisateur en JSON
  print('ID enseignant sauvegardé: $enseignantId');
}

// Fonction pour récupérer l'ID de l'enseignant
Future<String> getEnseignantId() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('userData') ?? '{}';  // Récupérer l'objet utilisateur, ou une chaîne vide par défaut
    final Map<String, dynamic> userData = json.decode(userDataString);

    // Vérifier et récupérer l'ID utilisateur
    final String enseignantId = userData['id'] ?? '';  // Récupérer l'ID, ou chaîne vide par défaut
    print("Fetched enseignantId: $enseignantId");

    if (enseignantId.isEmpty) {
      print("L'ID de l'enseignant n'a pas été trouvé ou est vide.");
    }

    return enseignantId;
  } catch (e) {
    print("Erreur lors de la récupération de l'ID enseignant: $e");
    return '';  // Si erreur, retourne une chaîne vide
  }
}

// Route pour afficher la liste des matières
class MatiereListPageRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getEnseignantId(), // Utilisation de la fonction pour récupérer l'ID
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator()); // Affichage de l'indicateur de chargement
        } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Erreur lors de la récupération de l\'ID enseignant.'));
        } else {
          // Si l'ID est récupéré avec succès, afficher la liste des matières
          return MatiereListPage(enseignantId: snapshot.data!);
        }
      },
    );
  }
}


class MatiereListPage extends StatefulWidget {
  final String enseignantId;

  const MatiereListPage({Key? key, required this.enseignantId}) : super(key: key);

  @override
  _MatiereListPageState createState() => _MatiereListPageState();
}

class _MatiereListPageState extends State<MatiereListPage> {
  late Future<List<Matiere>> matieres;

  @override
  void initState() {
    super.initState();
    matieres = EnseignantService().getMatieresByEnseignantId(widget.enseignantId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Matières de l\'enseignant'),
        backgroundColor: Color(0XFFBE9CC7),
      ),
      body: FutureBuilder<List<Matiere>>(
        future: matieres,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucune matière trouvée.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final matiere = snapshot.data![index];
                return ListTile(
                title: Text(
                  matiere.nom,
                  style: const TextStyle(
                    color: Color(0XFF5C5792), // Couleur pour le titre
                    fontWeight: FontWeight.bold, // Texte en gras pour mettre en valeur
                  ),
                ),
                subtitle: Text(
                  'Type : ${matiere.type}, Semestre : ${matiere.semestre}, Niveau : ${matiere.niveau}',
                  style: const TextStyle(
                    color: Color(0XFF5C5792), // Couleur pour le sous-titre
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

/*

class MatiereListPage extends StatelessWidget {
  final String enseignantId;

  MatiereListPage({required this.enseignantId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des matières'),
      ),
      body: FutureBuilder<List<Matiere>>(
        future: EnseignantService().getMatieresByEnseignantId(enseignantId),
        builder: (context, snapshot) {
  if (snapshot.connectionState == ConnectionState.waiting) {
    return Center(child: CircularProgressIndicator());
  } else if (snapshot.hasError) {
    // Affichage d'une erreur détaillée
    return Center(
      child: Text('Erreur: ${snapshot.error.toString()}'),
    );
  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
    return Center(child: Text('Aucune matière disponible pour cet enseignant'));
  } else {
    List<Matiere> matieres = snapshot.data!;
    return ListView.builder(
      itemCount: matieres.length,
      itemBuilder: (context, index) {
        Matiere matiere = matieres[index];
        return ListTile(
          title: Text(matiere.nom),
          subtitle: Text('Type: ${matiere.type}'),
        );
      },
    );
  }
}

      ),
    );
  }
}
*/