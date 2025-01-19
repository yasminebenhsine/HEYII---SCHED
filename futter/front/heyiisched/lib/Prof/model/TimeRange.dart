class TimeRange {
  final DateTime debutHeure;
  final DateTime finHeure;

  TimeRange({
    required this.debutHeure,
    required this.finHeure,
  });

  // You can also add methods like toJson() to convert to JSON format
  Map<String, dynamic> toJson() {
    return {
      'debutHeure': debutHeure.toIso8601String(),
      'finHeure': finHeure.toIso8601String(),
    };
  }
}