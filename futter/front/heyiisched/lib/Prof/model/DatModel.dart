enum Jour { Lundi, Mardi, Mercredi, Jeudi, Vendredi, Samedi, Dimanche }

class DatModel {
  final int idDate;
  final Jour jour;
  final DateTime debutHeure;
  final DateTime finHeure;

  DatModel({
    required this.idDate,
    required this.jour,
    required this.debutHeure,
    required this.finHeure,
  });

  // Convert DatModel to JSON-compatible map
  Map<String, dynamic> toJson() {
    return {
      'idDate': idDate,
      'jour': jour.toString().split('.').last, // Convert enum to string
      'debutHeure': debutHeure.toIso8601String(),
      'finHeure': finHeure.toIso8601String(),
    };
  }

  // Convert to human-readable format
  String toIso8601String() {
    return '${debutHeure.toIso8601String()} to ${finHeure.toIso8601String()}';
  }
}