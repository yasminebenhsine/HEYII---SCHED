import 'package:flutter/material.dart';
import 'package:heyiisched/Prof/model/DatModel.dart';
import 'package:heyiisched/Prof/model/TimeRange.dart';
import 'package:heyiisched/Prof/my_widget/app_bar_clipper.dart';
import 'package:heyiisched/Prof/widget_prof.dart';
import 'package:heyiisched/models/Modeles.dart';
import 'package:heyiisched/services/EnseignantService.dart';
import 'package:heyiisched/services/reclamationService.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AddReclamationPage extends StatefulWidget {
  @override
  _AddReclamationPageState createState() => _AddReclamationPageState();
}

class _AddReclamationPageState extends State<AddReclamationPage> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _sujetController = TextEditingController();
  bool isLu = false;
  String statut = "EN_ATTENTE"; // Statut par défaut
  bool _isLoading = false;

  Future<void> _submitReclamation() async {
    // Vérification des champs
    if (_sujetController.text.isEmpty || _textController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Veuillez remplir tous les champs."),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Récupérer les détails de l'utilisateur depuis SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString('userData') ?? '{}';
      final Map<String, dynamic> userData = json.decode(userDataString);

      // Récupérer l'ID utilisateur
      final String userId = userData['id'] ?? '';
      if (userId.isEmpty) {
        throw Exception("Les données utilisateur sont manquantes.");
      }
      print('userId ${userId}');

      // Construire les données de la réclamation
      final reclamation = {
        "text": _textController.text,
        "sujet": _sujetController.text,
        "date": DateTime.now().toIso8601String(),
        "isLu": isLu,
        "statut": statut,
        "enseignant": {
          'id': userId, // Utilisez directement userId ici
        },
      };

      print("Données envoyées à l'API : ${json.encode(reclamation)}");

      // Envoyer la réclamation au serveur
      final response = await http.post(
        Uri.parse(
            'http://localhost:8084/api/reclamations/addReclamation/$userId'), // Inclure l'ID dans l'URL
        headers: {"Content-Type": "application/json"},
        body: json.encode(reclamation),
      );
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      // Vérifier la réponse du serveur
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Réclamation soumise avec succès.')),
        );
        Navigator.pop(context); // Fermer la page après soumission
      } else {
        print(
            'Erreur lors de la soumission : ${response.statusCode} - ${response.body}');
        throw Exception(
            "Erreur lors de la soumission : ${response.statusCode} - ${response.body}");
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : $error')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer une réclamation'),
        backgroundColor: Color(0XFFBE9CC7),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  TextField(
                    controller: _sujetController,
                    decoration: const InputDecoration(
                      labelText: 'Sujet de la réclamation',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      labelText: 'Texte de la réclamation',
                    ),
                    maxLines: 5,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitReclamation,
                    child: const Text('Soumettre la réclamation'),
                  ),
                ],
              ),
      ),
    );
  }
}



/*
class AddReclamationPage extends StatefulWidget {
  @override
  _AddReclamationPageState createState() => _AddReclamationPageState();
}

class _AddReclamationPageState extends State<AddReclamationPage> {
  final TextEditingController textController = TextEditingController();
  bool isSubmitting = false;

Future<void> submitReclamation() async {
  setState(() {
    isSubmitting = true;
  });

  final reclamationData = {
    'text': textController.text,
    'date': DateTime.now().toIso8601String(), // Current date for the reclamation
  };

  try {
    final response = await http.post(
      Uri.parse('http://localhost:8084/api/reclamations'),
      headers: {
        'Content-Type': 'application/json', // Supprimez 'charset=utf-8'
      },
      body: json.encode(reclamationData),
    );

    // Afficher le code d'état de la réponse
    print("Response Status: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Réclamation envoyée avec succès')),
      );
      textController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'envoi de la réclamation: ${response.statusCode}')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erreur réseau: $e')),
    );
  } finally {
    setState(() {
      isSubmitting = false;
    });
  }
}

Future<Reclamation> createReclamation(Reclamation reclamation) async {
    final response = await http.post(
      Uri.parse('http://localhost:8084/api/reclamations'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(reclamation.toJson()),
    );

    if (response.statusCode == 201) {
      return Reclamation.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create reclamation');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Soumettre une Réclamation'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: textController,
              decoration: InputDecoration(
                labelText: 'Détail de la réclamation',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isSubmitting ? null : submitReclamation,
              child: isSubmitting
                  ? CircularProgressIndicator()
                  : Text('Soumettre'),
            ),
          ],
        ),
      ),
    );
  }
}
*/
/*
*********
class AddReclamationPage extends StatefulWidget {
  @override
  _AddReclamationPageState createState() => _AddReclamationPageState();
}

class _AddReclamationPageState extends State<AddReclamationPage> {
  final TextEditingController reclamationController = TextEditingController();
  Map<String, TimeRange> selectedDays = {}; // Mapping of days to time ranges
  final List<String> days = [
    'Lundi',
    'Mardi',
    'Mercredi',
    'Jeudi',
    'Vendredi',
    'Samedi'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 248, 243, 246),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with back arrow, logo, and greeting
            Stack(
              children: [
                ClipPath(
                  clipper: AppBarClipper(),
                  child: Container(
                    height: 240,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF9F8DC3),
                          Color(0xFFBE9CC7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 20,
                  left: 20,
                  right: 20,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyHomePage(),
                            ),
                          );
                        },
                      ),
                      SizedBox(width: 10),
                      Image.asset(
                        'assets/images/logo.png',
                        width: 180,
                        height: 180,
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          'Bonjour Madame/Monsieur',
                          style: TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 30,
                  right: 20,
                  child: GestureDetector(
                    onTap: () {
                      showMenu(
                        context: context,
                        position: RelativeRect.fromLTRB(200, 100, 20, 100),
                        items: [
                          PopupMenuItem(
                            child: Text("Logout"),
                            value: "logout",
                          ),
                        ],
                      ).then((value) {
                        if (value == "logout") {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Logged out checked!'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      });
                    },
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/images/user.JPG'),
                    ),
                  ),
                ),
              ],
            ),

            // Center only the body content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.center,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 600),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title of the page
                      Text(
                        'Add Your Reclamation',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF211A44)),
                      ),
                      SizedBox(height: 20),

                      // Reclamation Text Field
                      _buildReclamationField(),
                      SizedBox(height: 20),

                      // Day Selection with Time Range
                      _buildDaySelection(),
                      SizedBox(height: 20),

                      // Submit Button
                      _buildSubmitButton(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Reclamation Text Field
  Widget _buildReclamationField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Enter Reclamation:'),
        TextField(
          controller: reclamationController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Enter your reclamation here',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  // Day Selection with Time Range
  Widget _buildDaySelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select Days and Time Ranges:'),
        ...days.map((day) {
          return _buildDayTimeRangeSelection(day);
        }).toList(),
      ],
    );
  }

  // Day and Time Range Picker
  Widget _buildDayTimeRangeSelection(String day) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(day, style: TextStyle(fontSize: 18)),
            Spacer(),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () async {
                final TimeOfDay? startTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (startTime != null) {
                  final TimeOfDay? endTime = await showTimePicker(
                    context: context,
                    initialTime: startTime.replacing(hour: startTime.hour + 1),
                  );
                  if (endTime != null) {
                    final debutHeure =
                        DateTime(2024, 1, 1, startTime.hour, startTime.minute);
                    final finHeure =
                        DateTime(2024, 1, 1, endTime.hour, endTime.minute);
                    setState(() {
                      selectedDays[day] =
                          TimeRange(debutHeure: debutHeure, finHeure: finHeure);
                    });
                  }
                }
              },
            ),
            if (selectedDays.containsKey(day))
              IconButton(
                icon: Icon(Icons.remove_circle_outline),
                onPressed: () {
                  setState(() {
                    selectedDays.remove(day);
                  });
                },
              ),
          ],
        ),
        if (selectedDays.containsKey(day))
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              '${selectedDays[day]?.debutHeure.hour}:${selectedDays[day]?.debutHeure.minute} - ${selectedDays[day]?.finHeure.hour}:${selectedDays[day]?.finHeure.minute}',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
      ],
    );
  }

  // Submit Button
  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: () {
        String reclamationText = reclamationController.text;
        List<DatModel> datModels = selectedDays.entries.map((entry) {
          return DatModel(
            idDate: selectedDays.length,
            jour: _getJourFromString(entry.key),
            debutHeure: entry.value.debutHeure,
            finHeure: entry.value.finHeure,
          );
        }).toList();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Reclamation submitted successfully!'),
          ),
        );
        print('Reclamation Text: $reclamationText');
        print('Selected Days and Times: $datModels');
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF5C5792),
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
      ),
      child: Text(
        'Submit Reclamation',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  // Helper method to convert string to Jour enum
  Jour _getJourFromString(String jourStr) {
    switch (jourStr) {
      case 'Lundi':
        return Jour.Lundi;
      case 'Mardi':
        return Jour.Mardi;
      case 'Mercredi':
        return Jour.Mercredi;
      case 'Jeudi':
        return Jour.Jeudi;
      case 'Vendredi':
        return Jour.Vendredi;
      case 'Samedi':
        return Jour.Samedi;
      default:
        return Jour.Lundi;
    }
  }
}
*/





/*import 'package:flutter/material.dart';
import 'package:front_heyii_sched_mobile/Enseignant/HomePage.dart';
import 'package:front_heyii_sched_mobile/Enseignant/my_widget/shared_widgets.dart';
import 'package:front_heyii_sched_mobile/Enseignant/model/TimeRange.dart';
import 'package:front_heyii_sched_mobile/Enseignant/model/DatModel.dart';

class AddReclamationPage extends StatefulWidget {
  @override
  _AddReclamationPageState createState() => _AddReclamationPageState();
}

class _AddReclamationPageState extends State<AddReclamationPage> {
  final TextEditingController reclamationController = TextEditingController();
  Map<String, TimeRange> selectedDays = {}; // Mapping of days to time ranges
  final List<String> days = [
    'Lundi',
    'Mardi',
    'Mercredi',
    'Jeudi',
    'Vendredi',
    'Samedi'
  ];

  // Submit callback for Reclamation
  void submitReclamation(
      String reclamationText, Map<String, TimeRange> selectedDays) {
    List<DatModel> datModels = selectedDays.entries.map((entry) {
      return DatModel(
        idDate: selectedDays.length,
        jour: SharedWidgets.getJourFromString(entry.key),
        debutHeure: entry.value.debutHeure,
        finHeure: entry.value.finHeure,
      );
    }).toList();

    // Process the reclamation (this part should be adapted to your needs)
    print('Reclamation Text: $reclamationText');
    print('Selected Days and Times: $datModels');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE3BAD5),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with back arrow, logo, and greeting
            Stack(
              children: [
                ClipPath(
                  clipper: AppBarClipper(),
                  child: Container(
                    height: 240,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF9F8DC3),
                          Color(0xFFBE9CC7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 20,
                  left: 20,
                  right: 20,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(width: 10),
                      Image.asset(
                        'img/logo.png',
                        width: 180,
                        height: 180,
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          'Bonjour Madame/Monsieur',
                          style: TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Center only the body content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.center,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 600),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title of the page
                      Text(
                        'Add Your Reclamation',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF211A44)),
                      ),
                      SizedBox(height: 20),

                      // Reclamation Text Field
                      SharedWidgets.buildTextField(
                        reclamationController,
                        'Enter your Reclamation',
                        3,
                      ),

                      SizedBox(height: 20),

                      // Day Selection and Time Range Picker
                      SharedWidgets.buildDaySelection(
                          days, selectedDays, context),

                      SizedBox(height: 30),

                      // Submit Button
                      SharedWidgets.buildSubmitButton(
                        reclamationController,
                        selectedDays,
                        context,
                        submitReclamation,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/