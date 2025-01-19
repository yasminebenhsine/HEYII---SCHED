class Admin {
  final String idAdmin;
  final String nom;

  Admin({
    required this.idAdmin,
    required this.nom,
  });

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      idAdmin: json['idAdmin'] ?? '',
      nom: json['nom'] ?? '',
    );
  }
}

class Specialite {
  final String idSpecialite;
  final String nom;
  final List<String> matieres;
  final Admin? admin; // Made optional since it might not always be present

  Specialite({
    required this.idSpecialite,
    required this.nom,
    required this.matieres,
    this.admin,
  });

  // Modified factory method to handle both simple string and complex object responses
  factory Specialite.fromJson(dynamic json) {
    if (json is String) {
      // Handle simple string response
      return Specialite(
        idSpecialite: '', // Generate a unique ID if needed
        nom: json,
        matieres: [],
        admin: null,
      );
    } else if (json is Map<String, dynamic>) {
      // Handle complex object response
      return Specialite(
        idSpecialite: json['idSpecialite']?.toString() ??
            '', // Convert to String if needed
        nom: json['nom'] ?? '',
        matieres: json['matieres'] != null
            ? List<String>.from(
                json['matieres'].map((matiere) => matiere['nom'] ?? ''))
            : [],
        admin: json['admin'] != null ? Admin.fromJson(json['admin']) : null,
      );
    }
    throw FormatException('Invalid JSON format for Specialite');
  }
}

class Matiere {
  final String idMatiere;
  final String nom;
  final String type;
  final int semestre;
  final int niveau;

  Matiere({
    required this.idMatiere,
    required this.nom,
    required this.type,
    required this.semestre,
    required this.niveau,
  });

  // Méthode pour convertir le JSON en objet Matiere
  factory Matiere.fromJson(Map<String, dynamic> json) {
    return Matiere(
      idMatiere: json['idMatiere'] ?? '',
      nom: json['nom'] ?? 'Nom inconnu',
      type: json['type'] ?? 'Type inconnu',
      semestre: json['semestre'] ?? 0,
      niveau: json['niveau'] ?? 0,
    );
  }

  // Méthode pour convertir un objet Matiere en JSON
  Map<String, dynamic> toJson() {
    return {
      'idMatiere': idMatiere,
      'nom': nom,
      'type': type,
      'semestre': semestre,
      'niveau': niveau,
    };
  }
}

/*
class Admin {
  final String idAdmin;
  final String nom;

  Admin({required this.idAdmin, required this.nom});

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      idAdmin: json['_id'],  // ID de l'administrateur
      nom: json['nom'],  // Nom de l'administrateur
    );
  }
}*/
