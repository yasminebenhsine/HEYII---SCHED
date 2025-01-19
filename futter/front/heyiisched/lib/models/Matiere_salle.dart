import 'package:heyiisched/models/Modeles.dart';

class Matiere {
  final String id;
  final String nom;
  final String type;
   int ?semestre;
   int ?niveau;
  final List<Salle> salles;
  final List<Specialite> specialites;
  final List<Cours> cours;
  final List<Enseignant> enseignants;
  final List<Voeux> voeux;
  final Admin? admin; // Made nullable since it can be null

  Matiere({
    required this.id,
    required this.nom,
    required this.type,
     this.semestre=1,
    required this.niveau,
    required this.salles,
    required this.specialites,
    required this.cours,
    required this.enseignants,
    required this.voeux,
    this.admin, // Made optional
  });

  factory Matiere.fromJson(Map<String, dynamic> json) {
    return Matiere(
      id: json['idMatiere'] ?? '', // Use empty string if null
      nom: json['nom'] ?? '',
      type: json['type'] ?? '',
      semestre: json['semestre'] ?? 0,
      niveau: json['niveau'] ?? 0,
      salles: (json['salles'] as List<dynamic>?)
              ?.map((e) => Salle.fromJson(e))
              .toList() ??
          [],
      specialites: (json['specialites'] as List<dynamic>?)
              ?.map((e) => Specialite.fromJson(e))
              .toList() ??
          [],
      cours: (json['cours'] as List<dynamic>?)
              ?.map((e) => Cours.fromJson(e))
              .toList() ??
          [],
      enseignants: (json['enseignants'] as List<dynamic>?)
              ?.map((e) => Enseignant.fromJson(e))
              .toList() ??
          [],
      voeux: (json['voeux'] as List<dynamic>?)
              ?.map((e) => Voeux.fromJson(e))
              .toList() ??
          [],
      admin: json['admin'] != null ? Admin.fromJson(json['admin']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idMatiere': id,
      'nom': nom,
      'type': type,
      'semestre': semestre,
      'niveau': niveau,
      'salles': salles.map((e) => e.toJson()).toList(),
      'specialites': specialites.map((e) => e.toJson()).toList(),
      'cours': cours.map((e) => e.toJson()).toList(),
      'enseignants': enseignants.map((e) => e.toJson()).toList(),
      'voeux': voeux.map((e) => e.toJson()).toList(),
      'admin': admin?.toJson(), // Use null-safe operator
    };
  }

  // Add a copy with method for easy updating
  Matiere copyWith({
    String? id,
    String? nom,
    String? type,
    int? semestre,
    int? niveau,
    List<Salle>? salles,
    List<Specialite>? specialites,
    List<Cours>? cours,
    List<Enseignant>? enseignants,
    List<Voeux>? voeux,
    Admin? admin,
  }) {
    return Matiere(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      type: type ?? this.type,
      semestre: semestre ?? this.semestre,
      niveau: niveau ?? this.niveau,
      salles: salles ?? this.salles,
      specialites: specialites ?? this.specialites,
      cours: cours ?? this.cours,
      enseignants: enseignants ?? this.enseignants,
      voeux: voeux ?? this.voeux,
      admin: admin ?? this.admin,
    );
  }
}