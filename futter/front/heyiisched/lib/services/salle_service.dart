import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/Modeles.dart';

class SalleService {
  final String baseUrl = "http://localhost:8084/salle";

  Future<List<Salle>> fetchSalles() async {
    try {
      final response =
          await http.get(Uri.parse("$baseUrl/retrieve-all-salles"));

      if (response.statusCode == 200) {
        final List<dynamic> salleList = json.decode(response.body);
        print("Received salles data: $salleList");
        return salleList.map((json) => Salle.fromJson(json)).toList();
      } else {
        print("Failed to load Salles, status code: ${response.statusCode}");
        throw Exception("Failed to load Salles");
      }
    } catch (e) {
      print("Error fetching salles: $e");
      throw Exception("Network error: $e");
    }
  }

  Future<Salle> fetchSalleById(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/retrieve-salle/$id'));

      if (response.statusCode == 200) {
        return Salle.fromJson(jsonDecode(response.body));
      } else {
        print("Failed to load Salle, status code: ${response.statusCode}");
        throw Exception('Failed to load Salle');
      }
    } catch (e) {
      print("Error fetching salle by ID: $e");
      throw Exception("Network error: $e");
    }
  }

  Future<void> addSalle(Salle salle) async {
    final response = await http.post(
      Uri.parse('$baseUrl/add'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(salle.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add salle: ${response.statusCode}');
    }
  }

  /*Future<void> addSalle(Salle salle) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/add"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(salle.toJson()),
      );

      if (response.statusCode != 201) {
        throw Exception("Failed to add Salle: ${response.statusCode}");
      }
    } catch (e) {
      print("Error adding salle: $e");
      throw Exception("Network error: $e");
    }
  }*/

  Future<void> updateSalle(String id, Salle updatedSalle) async {
    try {
      final url =
          "$baseUrl/update/$id"; // Use the correct URL structure without appending the ID twice
      print("Attempting to update salle at URL: $url");
      print("Update payload: ${json.encode(updatedSalle.toJson())}");

      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updatedSalle.toJson()),
      );

      print("Response status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode != 200) {
        throw Exception("Failed to update Salle: ${response.statusCode}");
      }
    } catch (e) {
      print("Error updating salle: $e");
      throw Exception("Network error: $e");
    }
  }

  Future<void> deleteSalle(String id) async {
    final url = Uri.parse("$baseUrl/delete/$id");
    try {
      print("Attempting to delete salle with ID: $id");
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        print("Salle deleted successfully.");
      } else {
        throw Exception(
            "Failed to delete Salle. Status Code: ${response.statusCode}, Response: ${response.body}");
      }
    } catch (e) {
      print("Error deleting salle: $e");
      throw Exception("Network error or invalid endpoint: $e");
    }
  }
}
