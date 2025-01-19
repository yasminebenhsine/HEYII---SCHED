import 'package:flutter/material.dart';
import 'package:heyiisched/models/Modeles.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VoeuxListPage extends StatefulWidget {
  @override
  _VoeuxListPageState createState() => _VoeuxListPageState();
}

class _VoeuxListPageState extends State<VoeuxListPage> {
  late List<Voeux> _voeuxList = [];
  bool _isLoading = true;
  final List<String> etatOptions = ['Soumis', 'En cours', 'Valide', 'Rejete'];

  @override
  void initState() {
    super.initState();
    _loadVoeux();
  }

  Future<void> _loadVoeux() async {
    try {
      setState(() => _isLoading = true);
      final fetchedVoeux = await Voeuxprof().fetchVoeux();
      setState(() {
        _voeuxList = fetchedVoeux;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur de chargement: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String decodeEtat(String etat) {
    try {
      return utf8.decode(latin1.encode(etat));
    } catch (e) {
      return etat;
    }
  }

  String normalizeEtat(String etat) {
    String decodedEtat = decodeEtat(etat);

    switch (decodedEtat.toLowerCase()) {
      case 'validé':
      case 'valide':
      case 'validã©':
        return 'Valide';
      case 'rejeté':
      case 'rejete':
      case 'rejetã©':
        return 'Rejete';
      case 'en cours':
        return 'En cours';
      case 'soumis':
        return 'Soumis';
      default:
        print('Unhandled etat value: $decodedEtat');
        return 'Soumis';
    }
  }

  Color getEtatColor(String etat) {
    switch (etat) {
      case 'Valide':
        return const Color.fromARGB(255, 209, 113, 203);
      case 'Rejete':
        return const Color.fromARGB(255, 115, 3, 102);
      case 'En cours':
        return const Color.fromARGB(255, 41, 4, 136);
      default:
        return Colors.black;
    }
  }

  Future<void> updateEtat(String idVoeu, String newEtat) async {
    try {
      // Optimistically update the UI
      int voeuxIndex = _voeuxList.indexWhere((v) => v.idVoeu == idVoeu);
      if (voeuxIndex == -1) return;

      setState(() {
        _voeuxList[voeuxIndex] = _voeuxList[voeuxIndex].copyWith(etat: newEtat);
      });

      // Make the API call
      await Voeuxprof().updateEtat(idVoeu, newEtat);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('État mis à jour avec succès'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      // Revert the optimistic update on error
      await _loadVoeux();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Widget buildEtatDropdown(Voeux voeu) {
    String currentEtat = normalizeEtat(voeu.etat);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButton<String>(
        value: currentEtat,
        underline: Container(),
        items: etatOptions.map((String etat) {
          return DropdownMenuItem<String>(
            value: etat,
            child: Text(
              etat,
              style: TextStyle(
                color: getEtatColor(etat),
              ),
            ),
          );
        }).toList(),
        onChanged: (String? newValue) {
          if (newValue != null && newValue != currentEtat) {
            updateEtat(voeu.idVoeu, newValue);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(
          context,
          '/enseignants/retrieve-all-enseignants',
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Liste des vœux'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacementNamed(
                context,
                '/admin/dashboard',
              );
            },
          ),
          backgroundColor: Color.fromARGB(255, 129, 123, 194),
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _voeuxList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox, size: 60, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('Aucun vœu trouvé.'),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: EdgeInsets.all(16.0),
                    itemCount: _voeuxList.length,
                    separatorBuilder: (context, index) => Divider(),
                    itemBuilder: (context, index) {
                      final voeu = _voeuxList[index];
                      return Card(
                        elevation: 2,
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Type: ${voeu.typeVoeu}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  buildEtatDropdown(voeu),
                                ],
                              ),
                              SizedBox(height: 8),
                              Text(
                                  'Enseignant: ${voeu.enseignant?.nom ?? "Non assigné"} ${voeu.enseignant?.prenom ?? ""}'),
                              Text('Priorité: ${voeu.priorite}'),
                              if (voeu.commentaire != null &&
                                  voeu.commentaire!.isNotEmpty)
                                Padding(
                                  padding: EdgeInsets.only(top: 8),
                                  child: Text(
                                    'Commentaire: ${voeu.commentaire}',
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}

class Voeuxprof {
  static const String baseUrl = 'http://192.168.56.1:8084';

  Future<List<Voeux>> fetchVoeux() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/voeux'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        String decodedBody = utf8.decode(response.bodyBytes);
        List<dynamic> body = json.decode(decodedBody);
        return body.map((e) => Voeux.fromJson(e)).toList();
      } else {
        throw Exception(
            'Erreur lors de la récupération des vœux: ${response.body}');
      }
    } catch (e) {
      throw Exception('Erreur de connexion lors de la récupération: $e');
    }
  }

  Future<void> updateEtat(String idVoeu, String etat) async {
    final encodedEtat = Uri.encodeComponent(etat);
    final url = Uri.parse('$baseUrl/voeux/$idVoeu/etat?etat=$encodedEtat');

    try {
      final response = await http.put(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('La requête a expiré après 10 secondes');
        },
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Erreur lors de la mise à jour: ${response.statusCode}');
      }
    } catch (e) {
      print('Error details: $e');
      rethrow;
    }
  }
}
