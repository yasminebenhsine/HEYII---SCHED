import 'dart:convert';
import 'package:heyiisched/Prof/model/model_emploi.dart';
import 'package:heyiisched/services/AuthService_y.dart';
import 'package:http/http.dart' as http;

class EmploiService {
  final String baseUrl = 'http://localhost:8084/api/emplois';
  final AuthService authService;

  EmploiService({required this.authService});
  Future<List<Emploi>> getEmploiByStudentId() async {
    try {
      final student = await authService.getCurrentStudent();

      if (student == null) {
        print('Student data is null');
        throw Exception('Unable to retrieve student data');
      }

      if (student.grpClass == null) {
        print('Student group class is null');
        throw Exception('Student is not assigned to a group');
      }

      final grpClassId = student.grpClass?.idGrp;
      if (grpClassId == null || grpClassId.isEmpty) {
        print('Invalid group ID');
        throw Exception('Invalid group assignment');
      }

      print(
          'Successfully found student group: ${student.grpClass?.nom} (ID: $grpClassId)');

      final response = await _fetchEmplois();
      final emploisJson = _parseResponse(response);

      if (emploisJson.isEmpty) {
        print('No emplois found for group $grpClassId');
        return [];
      }

      final emplois = _processEmplois(emploisJson, grpClassId);
      print(
          'Successfully processed ${emplois.length} emplois for group $grpClassId');

      return emplois;
    } catch (e, stackTrace) {
      print('Error in getEmploiByStudentId: $e');
      print('Stack trace: $stackTrace');
      throw Exception('Unable to load schedule: $e');
    }
  }

  Future<http.Response> _fetchEmplois() async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to load emplois: ${response.statusCode}');
      }

      return response;
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  List<dynamic> _parseResponse(http.Response response) {
    try {
      final String decodedBody = utf8.decode(response.bodyBytes);
      final List<dynamic> emploisJson = json.decode(decodedBody);
      print('Received ${emploisJson.length} emplois from server');
      return emploisJson;
    } catch (e) {
      throw Exception('Failed to parse server response: $e');
    }
  }

  List<Emploi> _processEmplois(List<dynamic> emploisJson, String grpClassId) {
    final List<Emploi> validEmplois = [];

    for (var json in emploisJson) {
      try {
        // Deep copy the JSON to avoid modifying the original
        final processedJson = Map<String, dynamic>.from(json);

        // Ensure all required fields exist
        _ensureRequiredFields(processedJson);

        // Create the Emploi object with processed JSON
        final emploi = Emploi.fromJson(processedJson);

        // Check if this emploi belongs to the student's group
        if (_isEmploiForGroup(emploi, grpClassId)) {
          validEmplois.add(emploi);
        }
      } catch (e, stackTrace) {
        print('Error processing individual emploi: $e');
        print('Stack trace: $stackTrace');
        print('Problematic JSON: ${json.toString()}');
        continue;
      }
    }

    return validEmplois;
  }

  void _ensureRequiredFields(Map<String, dynamic> json) {
    try {
      // Handle top-level fields with null safety
      json['idEmploi'] = json['idEmploi']?.toString() ?? '';
      json['typeEmploi'] = json['typeEmploi']?.toString() ?? '';
      json['jour'] = json['jour']?.toString() ?? '';
      json['heureDebut'] = json['heureDebut']?.toString() ?? '';
      json['heureFin'] = json['heureFin']?.toString() ?? '';

      // Initialize arrays with null safety
      json['enseignants'] = json['enseignants'] ?? [];
      json['salles'] = json['salles'] ?? [];
      json['grpClasses'] = json['grpClasses'] ?? [];
      json['cours'] = json['cours'] ?? [];

      // Process cours array with additional null checking
      if (json['cours'] is List) {
        json['cours'] = (json['cours'] as List).map((cours) {
          if (cours == null) return {};
          if (cours is Map<String, dynamic>) {
            return {
              ...cours,
              'matiere': cours['matiere'] ?? {},
              'enseignant': cours['enseignant'] ?? {},
              'grpClass': cours['grpClass'] ?? {}
            };
          }
          return {};
        }).toList();
      }
    } catch (e) {
      print('Error in _ensureRequiredFields: $e');
      // Provide default values if processing fails
      json.addAll({
        'idEmploi': '',
        'typeEmploi': '',
        'jour': '',
        'heureDebut': '',
        'heureFin': '',
        'enseignants': [],
        'salles': [],
        'grpClasses': [],
        'cours': []
      });
    }
  }

  bool _isEmploiForGroup(Emploi emploi, String grpClassId) {
    try {
      // Check in groupeClasse list with null safety
      bool inGroupeClasse = emploi.groupeClasse.any((group) =>
          group != null && group.idGrp != null && group.idGrp == grpClassId);

      // Check in cours list with null safety
      bool inCours = emploi.cours.any((cours) =>
          cours != null &&
          cours.grpClass != null &&
          cours.grpClass?.idGrp != null &&
          cours.grpClass?.idGrp == grpClassId);

      return inGroupeClasse || inCours;
    } catch (e) {
      print('Error in _isEmploiForGroup: $e');
      return false;
    }
  }
}
