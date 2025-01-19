import 'dart:convert';

import 'package:heyiisched/models/grpclasseModelDash.dart';
import 'package:http/http.dart' as http;

class GrpClassService {
  final String baseUrl = 'http://localhost:8084';

  Future<List<GrpClass>> getAllGrpClasses() async {
    print('Fetching all GrpClasses...');
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Grpclasses/retrieve-all-GrpClasses'),
        headers: {'Content-Type': 'application/json'},
      );

      print('GrpClasses Response Status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        print('Successfully fetched ${jsonData.length} GrpClasses');

        final grpClasses = jsonData
            .map((json) {
              try {
                return GrpClass.fromJson(json as Map<String, dynamic>);
              } catch (e) {
                print('Error parsing individual GrpClass: $e');
                print('Problematic JSON: $json');
                return null;
              }
            })
            .where((grpClass) => grpClass != null)
            .toList();

        return grpClasses.cast<GrpClass>();
      } else {
        throw Exception('Failed to load GrpClasses: ${response.body}');
      }
    } catch (e) {
      print('Error fetching GrpClasses: $e');
      throw Exception('Failed to fetch GrpClasses: $e');
    }
  }

  Future<List<Emploi>> getEmploiForGrpClass(String grpClassId) async {
    print('Fetching Emploi for GrpClass ID: $grpClassId');
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/emplois'),
        headers: {'Content-Type': 'application/json'},
      );

      print('Emplois Response Status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonData =
            json.decode(response.body) as List<dynamic>;

        // Filter and map the emplois that contain courses for the specified group
        List<Emploi> emplois = jsonData
            .map((emploiJson) {
              Emploi emploi = Emploi.fromJson(emploiJson);

              // Filter courses for the specific group
              if (emploi.cours != null) {
                emploi.cours!.removeWhere(
                    (cours) => cours?.grpClass?.idGrp != grpClassId);
              }

              return emploi;
            })
            .where((emploi) => emploi.cours?.isNotEmpty == true)
            .toList();

        return emplois;
      }

      throw Exception('Failed to load emplois: ${response.statusCode}');
    } catch (e) {
      print('Error fetching Emploi: $e');
      throw Exception('Failed to fetch Emploi: $e');
    }
  }

  Future<List<Etudiant>> getEtudiantsForGrpClass(String grpClassId) async {
    print('Fetching students for GrpClass ID: $grpClassId');
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Grpclasses/grpClass/$grpClassId/etudiants'),
        headers: {'Content-Type': 'application/json'},
      );

      print('Students Response Status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        if (response.body == 'null') return [];

        final List<dynamic> jsonData =
            json.decode(response.body) as List<dynamic>;
        return jsonData.map((json) => Etudiant.fromJson(json)).toList();
      }
      throw Exception('Failed to load students: ${response.statusCode}');
    } catch (e) {
      print('Error fetching students: $e');
      throw Exception('Failed to fetch students: $e');
    }
  }

  Future<List<GrpClass>> fetchGrpClasses() async {
    final response = await http.get(
        Uri.parse('http://localhost:8084/Grpclasses/retrieve-all-GrpClasses'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      print('Message du serveur: ${response.body}');

      return data.map((item) => GrpClass.fromJson(item)).toList();
    } else {
      print('Message du serveur: ${response.body}');
      print("errr");
      throw Exception('Échec de chargement des GrpClasses');
    }
  }

  Future<List<GrpClass>> getGrpClassesByEnseignant(String idEnseignant) async {
    final response = await http.get(
        Uri.parse('http://localhost:8084/Grpclasses/enseignant/$idEnseignant'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => GrpClass.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load GrpClasses');
    }
  }

  Future<GrpClass> updateGrpClass(String id, GrpClass grpClass) async {
    if (id.isEmpty) {
      throw Exception('ID is empty');
    }

    final response = await http.put(
      Uri.parse('http://localhost:8084/Grpclasses/update/$id'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(grpClass.toJson()),
    );

    if (response.statusCode == 200) {
      return GrpClass.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      print('\n GrpClass not found. ID: $id');
      print(' Error: ${response.body}');
      throw Exception('GrpClass not found. ID: $id');
    } else {
      throw Exception('Failed to update GrpClass. Error: ${response.body}');
    }
  }

  Future<GrpClass> addGrpClass(GrpClass grpClass) async {
    final response = await http.post(
      Uri.parse('http://localhost:8084/Grpclasses/add'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(grpClass.toJson()),
    );

    if (response.statusCode == 201) {
      print('update ${response.body}');
      return GrpClass.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add GrpClass. Error: ${response.body}');
    }
  }

/*
Future<void> deleteGrpClass(String id) async {
  final url = 'http://localhost:8084/Grpclasses/delete/$id';
  final response = await http.delete(Uri.parse(url));

  if (response.statusCode != 204) {
    throw Exception('Failed to delete GrpClass. Error: ${response.body}');
  }
}*/
  Future<List<Etudiant>> fetchStudentsByGrpClass(String idGrp) async {
    final response = await http.get(Uri.parse(
        'http://localhost:8084/Grpclasses/grpClass/$idGrp/etudiants'));

    if (response.statusCode == 200) {
      // Si la réponse est OK, parsez le JSON
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Etudiant.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load students');
    }
  }

  Future<void> deleteGrpClass(String id) async {
    final url = 'http://localhost:8084/Grpclasses/delete/$id';
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete GrpClass. Error: ${response.body}');
    }
  }
  /*Future<List<Etudiant>> fetchStudentsByGrpClass(String idGrp) async {
    final response = await http.get(Uri.parse('http://localhost:8084/Grpclasses/grpClass/$idGrp/etudiants'));

    if (response.statusCode == 200) {
      // Si la réponse est OK, parsez le JSON
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Etudiant.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load students');
    }
  }*/
}
/*
class GrpClassService{

Future<List<GrpClass>> fetchGrpClasses() async {
  final response = await http.get(Uri.parse('http://localhost:8084/Grpclasses/retrieve-all-GrpClasses'));

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
     print('Message du serveur: ${response.body}');
     
    return data.map((item) => GrpClass.fromJson(item)).toList();
  } else {
     print('Message du serveur: ${response.body}');
      print("errr");
    throw Exception('Échec de chargement des GrpClasses');
  }
  
}

Future<List<GrpClass>> getGrpClassesByEnseignant(String idEnseignant) async {
    final response = await http.get(Uri.parse('http://localhost:8084/Grpclasses/enseignant/$idEnseignant'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => GrpClass.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load GrpClasses');
    }
  }
   Future<GrpClass> addGrpClass(GrpClass grpClass) async {
    final response = await http.post(
      Uri.parse('http://localhost:8084/Grpclasses/add'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(grpClass.toJson()),
    );

    if (response.statusCode == 201) {
      print('update ${response.body}');
      return GrpClass.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add GrpClass. Error: ${response.body}');
    }
  }
Future<GrpClass> updateGrpClass(String id, GrpClass grpClass) async {
  if (id.isEmpty) {
    throw Exception('ID is empty');
  }

  final response = await http.put(
    Uri.parse('http://localhost:8084/Grpclasses/update/$id'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode(grpClass.toJson()),
  );

  if (response.statusCode == 200) {
    return GrpClass.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 404) {
    print('\n GrpClass not found. ID: $id');
    print(' Error: ${response.body}');
    throw Exception('GrpClass not found. ID: $id');
    
  } else {
    throw Exception('Failed to update GrpClass. Error: ${response.body}');
  }
}


Future<void> deleteGrpClass(String id) async {
  final url = 'http://localhost:8084/Grpclasses/delete/$id';
  final response = await http.delete(Uri.parse(url));

  if (response.statusCode != 204) {
    throw Exception('Failed to delete GrpClass. Error: ${response.body}');
  }
}
 Future<List<Etudiant>> fetchStudentsByGrpClass(String idGrp) async {
    final response = await http.get(Uri.parse('http://localhost:8084/Grpclasses/grpClass/$idGrp/etudiants'));

    if (response.statusCode == 200) {
      // Si la réponse est OK, parsez le JSON
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Etudiant.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load students');
    }
  }
}*/