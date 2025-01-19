import 'dart:convert';
import 'package:heyiisched/models/emploi.dart';
import 'package:http/http.dart' as http;

class TimetableService {
  Future<List<Emploi>> fetchTimetable() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://localhost:8084/api/emplois'), // Update the URL if needed
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print("API Response Status: ${response.statusCode}");
      print("API Response Body: ${response.body}"); // Log the response body

      if (response.statusCode == 200) {
        // Check if the response body is valid JSON
        try {
          List<dynamic> jsonData = json.decode(response.body);
          return jsonData.map((data) => Emploi.fromJson(data)).toList();
        } catch (e) {
          print("JSON Parsing Error: $e");
          throw Exception("Failed to parse JSON");
        }
      } else {
        print("Failed to load timetable with status: ${response.statusCode}");
        throw Exception('Failed to load timetable: ${response.statusCode}');
      }
    } catch (e) {
      print("Network Error: $e");
      throw Exception('Network error: $e');
    }
  }
}
