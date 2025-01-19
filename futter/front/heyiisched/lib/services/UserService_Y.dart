import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:heyiisched/Prof/model/model_emploi.dart';

import 'package:http/http.dart' as http;

class UserService {
  final String baseUrl = 'http://localhost:8084';

  Future<dynamic> fetchUserDetails(String userId, String role) async {
    if (userId.isEmpty || role.isEmpty) {
      throw Exception('Invalid userId or role');
    }

    debugPrint('Fetching user details - ID: $userId, Role: $role');
    String url = _getListUrlBasedOnRole(role);
    debugPrint('Fetching from URL: $url');

    try {
      final response = await http.get(Uri.parse(url));
      debugPrint('Fetch response status: ${response.statusCode}');
      debugPrint('Fetch response body: ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> usersData = json.decode(response.body);

        if (usersData.isEmpty) {
          throw Exception('No users found');
        }

        var matchingUser = usersData.firstWhere(
          (user) => user['idUser'].toString() == userId.toString(),
          orElse: () => throw Exception('User not found'),
        );

        debugPrint('Found matching user: ${json.encode(matchingUser)}');

        // Return the appropriate user type based on role
        switch (role.toLowerCase()) {
          case 'admin':
            return Admin.fromJson(matchingUser);
          case 'enseignant':
            return Enseignant.fromJson(matchingUser);
          case 'etudiant':
            return Etudiant.fromJson(matchingUser);
          default:
            throw Exception('Invalid role: $role');
        }
      } else {
        throw Exception('Server returned ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error in fetchUserDetails: $e');
      throw Exception('Failed to fetch user details: $e');
    }
  }

  Future<dynamic> updateUser(String id, dynamic user, String role) async {
    try {
      print('Updating user with ID: $id, Role: $role');
      String url = _getUpdateUrlBasedOnRole(role, id);
      debugPrint('Update URL: $url');

      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(user.toJson()),
      );
      print('------------------body  ${response.body}');
      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          throw Exception('No response body received');
        }

        var updatedData = json.decode(response.body);
        switch (role.toLowerCase()) {
          case 'admin':
            return Admin.fromJson(updatedData);
          case 'enseignant':
            return Enseignant.fromJson(updatedData);
          case 'etudiant':
            return Etudiant.fromJson(updatedData);
          default:
            throw Exception('Invalid role: $role');
        }
      } else {
        print('Error response: ${response.body}');
        throw Exception('Server returned ${response.statusCode}');
      }
    } catch (e) {
      final userJson = json.encode(user.toJson());
      debugPrint('User JSON: $userJson');

      throw Exception('Failed to update user: $e');
    }
  }

  Future<List<User>> fetchAllUsers(String role) async {
    String url = _getListUrlBasedOnRole(role);
    debugPrint('Fetching all users from URL: $url');

    try {
      final response = await http.get(Uri.parse(url));
      debugPrint('Fetch all response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        List<dynamic> usersData = json.decode(response.body);
        return usersData.map((data) => User.fromJson(data)).toList();
      } else {
        throw Exception('Server returned ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error in fetchAllUsers: $e');
      throw Exception('Failed to fetch users: $e');
    }
  }

  String _getListUrlBasedOnRole(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return "$baseUrl/api/admins";
      case 'enseignant':
        return "$baseUrl/enseignant/retrieve-all-enseignants";
      case 'etudiant':
        return "$baseUrl/etudiant/retrieve-all-etudiants";
      default:
        throw Exception("Invalid role: $role");
    }
  }

  String _getUpdateUrlBasedOnRole(String role, String userId) {
    switch (role.toLowerCase()) {
      case 'admin':
        return "$baseUrl/api/admins/$userId";
      case 'enseignant':
        return "$baseUrl/enseignant/update/$userId";
      case 'etudiant':
        return "$baseUrl/etudiant/update/$userId";
      default:
        throw Exception("Invalid role: $role");
    }
  }
  /*
  Future<dynamic> updateUser(String id, dynamic user, String role) async {
    try {
      debugPrint('Updating user with ID: $id, Role: $role');
      String url = _getUpdateUrlBasedOnRole(role, id);
      debugPrint('Update URL: $url');

      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(user.toJson()),
      );

      debugPrint('Update response status: ${response.statusCode}');
      debugPrint('Update response body: ${response.body}');

      if (response.statusCode == 200) {
        var updatedData = json.decode(response.body);
        switch (role.toLowerCase()) {
          case 'admin':
            return Admin.fromJson(updatedData);
          case 'enseignant':
            return Enseignant.fromJson(updatedData);
          case 'etudiant':
            return Etudiant.fromJson(updatedData);
          default:
            throw Exception('Invalid role: $role');
        }
      } else {
        throw Exception('Server returned ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error in updateUser: $e');
      throw Exception('Failed to update user: $e');
    }
  }
*/
}
