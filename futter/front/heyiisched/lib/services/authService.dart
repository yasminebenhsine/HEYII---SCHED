import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = 'http://localhost/:8084/api/auth';

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

        // Store the user data
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userData', json.encode(data));

        // Determine and return the role
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

  static Future<void> saveEnseignantId(String idEnseignant) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('idEnseignant', idEnseignant);
  }

  static Future<String?> getEnseignantId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('idEnseignant');
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
enum UserRole { admin, enseignant, etudiant }
