import 'dart:convert';

import 'package:heyiisched/Prof/model/model_emploi.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = 'http://localhost:8084';

  Future<UserRole?> login(String login, String password) async {
    try {
      print('Sending login request with: $login');

      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'login': login,
          'password': password,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final prefs = await SharedPreferences.getInstance();

        await prefs.setString('userData', json.encode(data));

        if (data['id'] != null) {
          await prefs.setString('userId', data['id'].toString());
          print('Saved userId to prefs: ${data['id']}');
        }

        if (data['role'] == 'admin') {
          await prefs.setString('userRole', 'admin');
          return UserRole.admin;
        } else if (data['role'] == 'enseignant') {
          await prefs.setString('userRole', 'enseignant');
          return UserRole.enseignant;
        } else {
          await prefs.setString('userRole', 'etudiant');
          return UserRole.etudiant;
        }
      } else {
        throw Exception('Login failed: ${response.body}');
      }
    } catch (e) {
      print('Error during login: $e');
      return null;
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString('userData');
      return userDataString != null ? json.decode(userDataString) : null;
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }

  Future<String?> getUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('userId');
    } catch (e) {
      print('Error getting userId: $e');
      return null;
    }
  }

  Future<String?> getUserRole() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('userRole');
    } catch (e) {
      print('Error getting userRole: $e');
      return null;
    }
  }

  Future<Etudiant?> getCurrentStudent() async {
    try {
      final userId = await getUserId();
      if (userId == null) {
        print('No user ID found');
        return null;
      }

      final response = await http.get(
        Uri.parse('$baseUrl/etudiant/retrieve-all-etudiants'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> students = json.decode(response.body);

        // Find the student with matching ID
        final studentData = students.firstWhere(
          (student) => student['idUser'] == userId,
          orElse: () => null,
        );

        if (studentData != null) {
          print('Found student data: $studentData');
          try {
            // Convert studentData to Map<String, dynamic> safely
            final Map<String, dynamic> cleanedData =
                Map<String, dynamic>.from(studentData);

            // Handle potentially null grpClass data
            if (cleanedData['grpClass'] != null) {
              final grpClassData =
                  Map<String, dynamic>.from(cleanedData['grpClass']);

              // Clean up the nested objects
              if (grpClassData['etudiants'] == null) {
                grpClassData['etudiants'] = [];
              }
              if (grpClassData['cours'] == null) {
                grpClassData['cours'] = [];
              }

              cleanedData['grpClass'] = grpClassData;
            }

            return Etudiant.fromJson(cleanedData);
          } catch (e) {
            print('Error parsing student data: $e');
            return null;
          }
        } else {
          print('Student not found in the response');
          return null;
        }
      } else {
        print('Failed to fetch student details: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error getting current student: $e');
      return null;
    }
  }

  Future<bool> isCurrentUserStudent() async {
    try {
      final role = await getUserRole();
      return role == 'etudiant';
    } catch (e) {
      print('Error checking if user is student: $e');
      return false;
    }
  }

  Future<String?> getCurrentStudentGrpClassId() async {
    try {
      final student = await getCurrentStudent();
      if (student != null && student.grpClass != null) {
        return student.grpClass.idGrp;
      }
      return null;
    } catch (e) {
      print('Error getting student group class ID: $e');
      return null;
    }
  }

  Future<Enseignant?> getCurrentProf() async {
    try {
      final userId = await getUserId();
      if (userId == null) {
        print('No user ID found');
        return null;
      }

      final response = await http.get(
        Uri.parse('$baseUrl/enseignant/retrieve-all-enseignants'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> professors = json.decode(response.body);

        // Find the professor with matching ID
        final profData = professors.firstWhere(
          (prof) => prof['idUser'] == userId,
          orElse: () => null,
        );

        if (profData != null) {
          print('Found professor data: $profData');
          return Enseignant.fromJson(profData as Map<String, dynamic>);
        } else {
          print('Professor not found in the response');
          return null;
        }
      } else {
        print('Failed to fetch professor details: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error getting current professor: $e');
      return null;
    }
  }

  Future<bool> isCurrentUserProf() async {
    try {
      final role = await getUserRole();
      return role == 'enseignant';
    } catch (e) {
      print('Error checking if user is professor: $e');
      return false;
    }
  }

  Future<List<Cours>?> getCurrentProfCourses() async {
    try {
      final prof = await getCurrentProf();
      if (prof != null) {
        return prof.cours;
      }
      return null;
    } catch (e) {
      print('Error getting professor courses: $e');
      return null;
    }
  }

  Future<List<Matiere>?> getCurrentProfMatieres() async {
    try {
      final prof = await getCurrentProf();
      if (prof != null) {
        return prof.matieres;
      }
      return null;
    } catch (e) {
      print('Error getting professor subjects: $e');
      return null;
    }
  }

  Future<List<Filiere>?> getCurrentProfFilieres() async {
    try {
      final prof = await getCurrentProf();
      if (prof != null) {
        return prof.filieres;
      }
      return null;
    } catch (e) {
      print('Error getting professor departments: $e');
      return null;
    }
  }

  Future<Emploi?> getCurrentProfEmploi() async {
    try {
      final prof = await getCurrentProf();
      if (prof != null) {
        return prof.emploi;
      }
      return null;
    } catch (e) {
      print('Error getting professor schedule: $e');
      return null;
    }
  }

  Future<Grade?> getCurrentProfGrade() async {
    try {
      final prof = await getCurrentProf();
      if (prof != null) {
        return prof.grade;
      }
      return null;
    } catch (e) {
      print('Error getting professor grade: $e');
      return null;
    }
  }

  Future<int?> getCurrentProfNbHeure() async {
    try {
      final prof = await getCurrentProf();
      if (prof != null) {
        return prof.nbHeure;
      }
      return null;
    } catch (e) {
      print('Error getting professor teaching hours: $e');
      return null;
    }
  }
}

enum UserRole { admin, enseignant, etudiant }
/*import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = 'http://localhost:8084/api/auth';

  Future<UserRole?> login(String login, String password) async {
    try {
      print('Sending login request with: $login');

      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'login': login,
          'password': password,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final prefs = await SharedPreferences.getInstance();

        // Store the complete response data
        await prefs.setString('userData', json.encode(data));

        // Explicitly store the user ID
        if (data['id'] != null) {
          await prefs.setString('userId', data['id'].toString());
          print('Saved userId to prefs: ${data['id']}');
        }

        // Store the role and return the appropriate UserRole
        if (data['role'] == 'admin') {
          await prefs.setString('userRole', 'admin');
          print('Saved role: admin');
          return UserRole.admin;
        } else if (data['role'] == 'enseignant') {
          await prefs.setString('userRole', 'enseignant');
          print('Saved role: enseignant');
          return UserRole.enseignant;
        } else {
          await prefs.setString('userRole', 'etudiant');
          print('Saved role: etudiant');
          return UserRole.etudiant;
        }
      } else {
        print('Login failed with status: ${response.statusCode}');
        throw Exception('Login failed: ${response.body}');
      }
    } catch (e) {
      print('Error during login: $e');
      return null;
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      print('Successfully logged out and cleared preferences');
    } catch (e) {
      print('Error during logout: $e');
      throw Exception('Logout failed: $e');
    }
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString('userData');
      if (userDataString != null) {
        return json.decode(userDataString);
      }
      return null;
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }

  Future<String?> getUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('userId');
    } catch (e) {
      print('Error getting userId: $e');
      return null;
    }
  }

  Future<String?> getUserRole() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('userRole');
    } catch (e) {
      print('Error getting userRole: $e');
      return null;
    }
  }
}

// Add this enum at the top of your file
enum UserRole { admin, enseignant, etudiant }*/