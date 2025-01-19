import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:heyiisched/models/Modeles.dart';

class reclamationService {
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
}
