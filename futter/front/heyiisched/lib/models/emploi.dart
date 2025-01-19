

class Emploi {
  final String idEmploi;
  final String typeEmploi;
  final String jour;
  final String heureDebut;
  final String heureFin;
  final List<dynamic> enseignants;
  final List<dynamic> salles;
  final List<dynamic> grpClasses;
  final dynamic admin;
  final dynamic cours;

  Emploi({
    required this.idEmploi,
    required this.typeEmploi,
    required this.jour,
    required this.heureDebut,
    required this.heureFin,
    required this.enseignants,
    required this.salles,
    required this.grpClasses,
    this.admin,
    this.cours,
  });

  factory Emploi.fromJson(Map<String, dynamic> json) {
    return Emploi(
      idEmploi: json['idEmploi'] ?? '',
      typeEmploi: json['typeEmploi'] ?? '',
      jour: json['jour'] ?? '',
      heureDebut: json['heureDebut'] ?? '',
      heureFin: json['heureFin'] ?? '',
      enseignants: json['enseignants'] ?? [],
      salles: json['salles'] ?? [],
      grpClasses: json['grpClasses'] ?? [],
      admin: json['admin'] ?? '',
      cours: json['cours'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idEmploi': idEmploi,
      'typeEmploi': typeEmploi,
      'jour': jour,
      'heureDebut': heureDebut,
      'heureFin': heureFin,
      'enseignants': enseignants,
      'salles': salles,
      'grpClasses': grpClasses,
      'admin': admin,
      'cours': cours,
    };
  }
}