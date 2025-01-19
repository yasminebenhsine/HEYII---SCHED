import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:heyiisched/models/Modeles.dart';
import 'package:http/http.dart' as http;

class UserService {
  final String apiUrl =
      'http://localhost:8084/user/addUser'; // Replace with your actual API endpoint

  // Add User to the backend
  Future<void> addUser(User user) async {
    try {
      // Sending POST request to the backend API
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(user.toJson()),
      );

      // Check for successful response (HTTP status code 201)
      if (response.statusCode == 201) {
        // Successfully added the user
        print('User added successfully');
      } else {
        // Handle other response codes (errors)
        throw Exception('Failed to add user: ${response.body}');
      }
    } catch (e) {
      // Catching any errors and printing them
      print('Error while adding user: $e');
      throw Exception('Failed to add user: $e');
    }
  }
}
