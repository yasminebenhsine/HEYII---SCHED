import 'package:flutter/material.dart';
import 'package:heyiisched/services/EmploiProfService.dart';
import 'package:heyiisched/services/EnseignantServiceEmploi.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:heyiisched/Prof/model/profEmploi.dart';

import 'package:http/http.dart' as http;

class MomEmploiPage extends StatefulWidget {
  @override
  _MomEmploiPageState createState() => _MomEmploiPageState();
}

class _MomEmploiPageState extends State<MomEmploiPage> {
  Enseignant user = Enseignant(
      idUser: '',
      nom: '',
      prenom: '',
      email: '',
      telephone: '',
      dateNaissance: '',
      motDePasse: '',
      login: '',
      cin: 0,
      nbHeure: 0);

  List<Cours> coursList = [];
  List<Salle> sallesList = [];
  List<Emploi> emploisData = [];
  Map<String, Map<String, List<Emploi>>> emploisByEnseignantAndDay = {};

  List<String> joursDeSemaine = [
    'Lundi',
    'Mardi',
    'Mercredi',
    'Jeudi',
    'Vendredi',
    'Samedi'
  ];
  String? errorMessage;

  List<String> horaires = [
    '',
    '',
    '08:30 - 10:00',
    '',
    '10:00 - 11:30',
    '',
    '11:30 - 13:00',
    '',
    '13:00 - 14:30',
    '',
    '14:30 - 16:00',
    '',
    '16:00 - 17:30'
  ];

  String? userId;

  @override
  void initState() {
    super.initState();
    _getUserId(); // Retrieve the user ID from SharedPreferences
  }

  // Method to retrieve user ID from SharedPreferences
  void _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString(
          'userId'); // Retrieve the user ID stored in SharedPreferences
    });

    if (userId != null) {
      loadEmplois();
      getUserDetails(userId!);
    } else {
      Navigator.pushReplacementNamed(
          context, '/login'); // Redirect if no user is logged in
    }
  }

  void logout() async {
    // Clear stored data (e.g., from SharedPreferences)
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('userId'); // Remove the stored user ID
    Navigator.pushReplacementNamed(context, '/login');
  }

  void getUserDetails(String id) async {
    try {
      Enseignant fetchedUser = await EnseignantService().getEnseignantById(id);
      setState(() {
        user = fetchedUser;
      });
    } catch (error) {
      print(
          'Erreur lors de la récupération des informations de l\'utilisateur: $error');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Erreur lors de la récupération des données de l\'utilisateur.')));
    }
  }

  void loadEmplois() async {
    try {
      // Récupération des données sous forme de liste d'emplois
      List<Emploi> emplois = await EmploiService().getAllEmplois();

      // Mise à jour de l'état avec les données récupérées
      setState(() {
        emploisData = emplois;
        filterEmploisByUser(); // Filtrer les emplois pour l'utilisateur connecté
        groupEmploisByEnseignantAndDay(); // Regrouper les emplois par enseignant et jour
      });
    } catch (error) {
      // Gestion des erreurs et mise à jour de l'état avec un message d'erreur
      setState(() {
        errorMessage = 'Erreur lors du chargement des emplois';
      });
      print('Erreur lors du chargement des emplois: $error');
    }
  }

/*
void loadEmplois() async {
  try {
    // Récupération des données sous forme de liste dynamique
    List<dynamic> emploisJson = await EmploiService().getAllEmplois();

    // Vérifiez la structure des données (impression pour déboguer)
    print('Données récupérées : $emploisJson');

    // Vérification si les données sont bien une liste
    if (emploisJson is List) {
      // Conversion des éléments de la liste en objets Emploi
      List<Emploi> emplois = emploisJson.map((emploiJson) {
        // Si l'élément est déjà un Map<String, dynamic>
        if (emploiJson is Map<String, dynamic>) {
          return Emploi.fromJson(emploiJson);  // Conversion en objet Emploi
        } else {
          // Si ce n'est pas un Map, nous levons une exception
          throw Exception('Données de type incorrect dans la réponse API');
        }
      }).toList();

      setState(() {
        emploisData = emplois;
        filterEmploisByUser();  // Filtrer les emplois pour l'utilisateur connecté
        groupEmploisByEnseignantAndDay();  // Regrouper les emplois par enseignant et jour
      });
    } else {
      // Si ce n'est pas une liste, lever une exception
      throw Exception('Les données reçues ne sont pas une liste');
    }
  } catch (error) {
    setState(() {
      errorMessage = 'Erreur lors du chargement des emplois';
    });
    print('Erreur lors du chargement des emplois: $error');
  }
}
*/

  void filterEmploisByUser() {
    setState(() {
      emploisData = emploisData
          .where((emploi) =>
              emploi.cours != null && emploi.cours!.enseignant.idUser == userId)
          .toList();
    });

    print('Emplois filtrés pour l\'enseignant connecté: $emploisData');
  }

  void groupEmploisByEnseignantAndDay() {
    setState(() {
      emploisByEnseignantAndDay = {};

      for (var emploi in emploisData) {
        // Utilisation de la vérification nulle pour éviter l'accès à un champ null
        String enseignantName =
            '${emploi.cours?.enseignant.nom ?? 'Nom inconnu'} ${emploi.cours?.enseignant.prenom ?? 'Prénom inconnu'}';
        String? jour = emploi.jour;

        // Vérification que 'jour' n'est pas nul et utilisation d'une valeur par défaut si nécessaire
        if (jour == null) {
          jour = 'Jour inconnu'; // Valeur par défaut si 'jour' est nul
        }

        if (emploisByEnseignantAndDay[enseignantName] == null) {
          emploisByEnseignantAndDay[enseignantName] = {};
        }

        if (emploisByEnseignantAndDay[enseignantName]![jour] == null) {
          emploisByEnseignantAndDay[enseignantName]![jour] = [];
        }

        emploisByEnseignantAndDay[enseignantName]![jour]!.add(emploi);
      }

      // Tri des emplois par heure de début pour chaque jour
      emploisByEnseignantAndDay.forEach((enseignantName, jours) {
        jours.forEach((jour, emploisList) {
          emploisList.sort((a, b) {
            var heureDebutA =
                a.heureDebut.toString().split(':').map(int.parse).toList();
            var heureDebutB =
                b.heureDebut.toString().split(':').map(int.parse).toList();
            return (heureDebutA[0] - heureDebutB[0]) != 0
                ? (heureDebutA[0] - heureDebutB[0])
                : (heureDebutA[1] - heureDebutB[1]);
          });
        });
      });

      print(
          'Emplois groupés et triés par enseignant et jour: $emploisByEnseignantAndDay');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emploi du Temps'),
        actions: [
          IconButton(icon: Icon(Icons.logout), onPressed: logout),
        ],
      ),
      body: errorMessage != null
          ? Center(child: Text(errorMessage!))
          : ListView(
              children: joursDeSemaine.map((jour) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(jour,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    ...emploisByEnseignantAndDay.entries
                        .where((entry) => entry.value.containsKey(jour))
                        .map((entry) {
                      return Column(
                        children: entry.value[jour]!.map((emploi) {
                          return ListTile(
                            title: Text(
                                '${emploi.cours?.idCours ?? 'Nom indisponible'}'),
                            subtitle: Text(
                                '${emploi.heureDebut} - ${emploi.heureFin}'),
                          );
                        }).toList(),
                      );
                    }).toList(),
                  ],
                );
              }).toList(),
            ),
    );
  }
}


/*
class EmploiService {
  final String baseUrl = 'http://localhost:8084/api';

  Future<List<Emploi>> getEmploisEnseignant(String enseignantId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/emplois/enseignant/$enseignantId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Emploi.fromJson(json)).toList();
      } else {
        print('body ${response.body}');
        throw Exception('Erreur ${response.statusCode}');
      }
    } catch (e) {
      
      throw Exception('Erreur de chargement: $e');
    }
  }
}

class EmploiScreen extends StatefulWidget {
  const EmploiScreen({Key? key}) : super(key: key);

  @override
  _EmploiScreenState createState() => _EmploiScreenState();
}

class _EmploiScreenState extends State<EmploiScreen> {
  final _emploiService = EmploiService();
  List<Emploi> _emplois = [];
  bool _isLoading = true;
  String? _error;
  String? enseignantId;

  @override
  void initState() {
    super.initState();
    _loadEnseignantId();
  }

Future<void> _loadEnseignantId() async {
  setState(() {
    _isLoading = true;
    _error = null;
  });

  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    enseignantId = prefs.getString('enseignantId');

    // Si `enseignantId` est null, essayez de le récupérer depuis `userData`
    if (enseignantId == null) {
      final userDataString = prefs.getString('userData');
      if (userDataString != null) {
        final userData = json.decode(userDataString);
        if (userData['role'] == 'enseignant') {
          enseignantId = userData['id'];
          await prefs.setString('enseignantId', enseignantId!);
        }
      }
    }

    if (enseignantId == null) {
      throw Exception('Aucun enseignant connecté.');
    }

    await _loadEmplois();
  } catch (e) {
    setState(() {
      _error = e.toString();
      _isLoading = false;
    });
  }
}
 void _saveUserData(String id, String role) async {
  final prefs = await SharedPreferences.getInstance();
  final userData = json.encode({
    'id': id,
    'role': role,
  });
 
  await prefs.setString('userData', userData);
  // Sauvegarder directement l'enseignantId si rôle est "enseignant"
  if (role == "enseignant") {
    await prefs.setString('enseignantId', id);
  }
  print('Saved userId to prefs: $id');
}

Future<void> _loadEmplois() async {
    if (enseignantId == null) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      print('Fetching emplois for enseignantId: $enseignantId'); // Log l'enseignantId
      final emplois = await _emploiService.getEmploisEnseignant(enseignantId!);
      print('${emplois}');
      setState(() {
        _emplois = emplois;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching emplois: $e'); // Log l'erreur
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
}
  Widget _buildEmploiCard(Emploi emploi) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      elevation: 2.0,
      child: ExpansionTile(
        title: Text(
          '${emploi.jour ?? "Jour non défini"} (${emploi.heureDebut ?? ""} - ${emploi.heureFin ?? ""})',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(emploi.typeEmploi ?? "Type non défini"),
        children: [
          if (emploi.cours != null)
            ListTile(
              title: const Text('Cours'),
              subtitle: Text(emploi.cours?.matiere?.nom ?? 'Non défini'),
              leading: const Icon(Icons.book),
            ),
          if (emploi.salle != null)
            ListTile(
              title: const Text('Salle'),
              subtitle: Text(emploi.salle?.nom ?? 'Non définie'),
              leading: const Icon(Icons.room),
            ),
          if (emploi.enseignants.isNotEmpty)
            ListTile(
              title: const Text('Enseignants'),
              subtitle: Text(
                emploi.enseignants.map((e) => e.nom).join(', '),
              ),
              leading: const Icon(Icons.person),
            ),
          if (emploi.groupeClasse != null)
            ListTile(
              title: const Text('Groupe'),
              subtitle: Text(emploi.groupeClasse?.nom ?? 'Non défini'),
              leading: const Icon(Icons.group),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emploi du temps'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadEmplois,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Erreur: $_error'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadEnseignantId,
                        child: const Text('Réessayer'),
                      ),
                    ],
                  ),
                )
              : _emplois.isEmpty
                  ? const Center(
                      child: Text('Aucun emploi du temps trouvé'),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadEnseignantId,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8.0),
                        itemCount: _emplois.length,
                        itemBuilder: (context, index) => _buildEmploiCard(_emplois[index]),
                      ),
                    ),
    );
  }
}
*/