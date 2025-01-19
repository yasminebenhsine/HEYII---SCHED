class GrpClass {
  final String idGrp;
  final String nom;
  final List<Etudiant?> etudiants;
  final String specialite;
  final Filiere? filiere;
  final Emploi? emploi;
  final Admin? admin;
  final List<Cours?> cours;

  GrpClass({
    required this.idGrp,
    required this.nom,
    this.etudiants = const [],
    this.specialite = '',
    this.filiere,
    this.emploi,
    this.admin,
    this.cours = const [],
  });

  factory GrpClass.fromJson(Map<String, dynamic> json) {
    List<Etudiant?> parseEtudiants(dynamic etudiantsJson) {
      if (etudiantsJson == null || !(etudiantsJson is List)) return [];
      return etudiantsJson
          .map((e) => e != null && e is Map<String, dynamic>
              ? Etudiant.fromJson(e)
              : null)
          .toList();
    }

    List<Cours?> parseCours(dynamic coursJson) {
      if (coursJson == null || !(coursJson is List)) return [];
      return coursJson
          .map((e) =>
              e != null && e is Map<String, dynamic> ? Cours.fromJson(e) : null)
          .toList();
    }

    return GrpClass(
      idGrp: json['idGrp']?.toString() ?? '',
      nom: json['nom']?.toString() ?? '',
      etudiants: parseEtudiants(json['etudiants']),
      specialite: json['specialite']?.toString() ?? '',
      filiere:
          json['filiere'] != null && json['filiere'] is Map<String, dynamic>
              ? Filiere.fromJson(json['filiere'] as Map<String, dynamic>)
              : null,
      emploi: json['emploi'] != null && json['emploi'] is Map<String, dynamic>
          ? Emploi.fromJson(json['emploi'] as Map<String, dynamic>)
          : null,
      admin: json['admin'] != null && json['admin'] is Map<String, dynamic>
          ? Admin.fromJson(json['admin'] as Map<String, dynamic>)
          : null,
      cours: parseCours(json['cours']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idGrp': idGrp,
      'nom': nom,
      'etudiants': etudiants.map((e) => e?.toJson()).toList(),
      'specialite': specialite,
      'filiere': filiere?.toJson(),
      'emploi': emploi?.toJson(),
      'admin': admin?.toJson(),
      'cours': cours.map((e) => e?.toJson()).toList(),
    };
  }

  static GrpClass defaultInstance() {
    return GrpClass(idGrp: '', nom: 'Default Group');
  }
}

// lib/models/matiere.dart
class Matiere {
  final String idMatiere;
  final String nom;
  final int semestre;
  final int niveau;

  Matiere({
    required this.idMatiere,
    required this.nom,
    required this.semestre,
    required this.niveau,
  });

  factory Matiere.fromJson(Map<String, dynamic> json) {
    return Matiere(
      idMatiere: json['idMatiere'] as String,
      nom: json['nom'] as String,
      semestre: json['semestre'] as int,
      niveau: json['niveau'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idMatiere': idMatiere,
      'nom': nom,
      'semestre': semestre,
      'niveau': niveau,
    };
  }

  static Matiere defaultInstance() {
    return Matiere(
        idMatiere: '', nom: 'Default Matiere', semestre: 0, niveau: 0);
  }
}

/*
class Matiere {
  final String id;
  final String nom;
  final String type;
  final int semestre;
  final int niveau;
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
    required this.semestre,
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
}*/
// lib/models/reclamation.dart
class Reclamation {
  final String text;
  final String date;
  final bool isLu;
  final StatutReclamation statut;
  final Enseignant enseignant;
  //final Admin admin;

  Reclamation({
    required this.text,
    required this.date,
    required this.isLu,
    required this.statut,
    required this.enseignant,
    //required this.admin,
  });

  factory Reclamation.fromJson(Map<String, dynamic> json) {
    return Reclamation(
      text: json['text'],
      date: json['date'],
      isLu: json['isLu'],
      statut: StatutReclamation.values.firstWhere(
          (e) => e.toString() == 'StatutReclamation.' + json['statut']),
      enseignant: Enseignant.fromJson(json['enseignant']),
      //admin: Admin.fromJson(json['admin']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'date': date,
      'isLu': isLu,
      'statut': statut.toString().split('.').last,
      'enseignant': enseignant.toJson(),
      //'admin': admin.toJson(),
    };
  }
}

enum StatutReclamation {
  ACCEPTEE,
  REFUSEE,
  EN_ATTENTE,
}
/*
class Salle {
  final String idSalle; // Remplacez ObjectId par String, car MongoDB utilise souvent des chaînes pour les IDs
  final String type;
  final String nom;
  final int capacite; // Remplacer Long par int
  final bool isDispo; // Type booléen pour la disponibilité
  final List<Matiere> matieres;
  final List<Datee> datees;
  //final Admin admin;
  final Emploi emploi;
  final List<Voeux> voeux;
  final List<Cours> cours;

  Salle({
    required this.idSalle,
    required this.type,
    required this.nom,
    required this.capacite,
    this.isDispo = true, // Valeur par défaut pour isDispo
    required this.matieres,
    required this.datees,
    //required this.admin,
    required this.emploi,
    required this.voeux,
    required this.cours,
  });

  factory Salle.fromJson(Map<String, dynamic> json) {
    return Salle(
      idSalle: json['idSalle'] ?? '',
      type: json['type'],
      nom: json['nom'],
      capacite: json['capacite'],
      isDispo: json['isDispo'] ?? true,
      matieres: (json['matieres'] as List).map((item) => Matiere.fromJson(item)).toList(),
      datees: (json['datees'] as List).map((item) => Datee.fromJson(item)).toList(),
     // admin: Admin.fromJson(json['admin']),
      emploi: Emploi.fromJson(json['emploi']),
      voeux: (json['voeux'] as List).map((item) => Voeux.fromJson(item)).toList(),
      cours: (json['cours'] as List).map((item) => Cours.fromJson(item)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idSalle': idSalle,
      'type': type,
      'nom': nom,
      'capacite': capacite,
      'isDispo': isDispo,
      'matieres': matieres.map((item) => item.toJson()).toList(),
      'datees': datees.map((item) => item.toJson()).toList(),
     // 'admin': admin.toJson(),
      'emploi': emploi.toJson(),
      'voeux': voeux.map((item) => item.toJson()).toList(),
      'cours': cours.map((item) => item.toJson()).toList(),
    };
  }
}
*/

// In your Modeles.dart, update the Salle class:
class Salle {
  final String idSalle;
  final String type;
  final String nom;
  final int capacite;
  final bool isDispo;
  final List<Matiere> matieres;
  final List<Datee> datees;
  final Admin? admin;
  final Emploi? emploi;
  final List<Voeux> voeux;
  final List<Cours> cours;

  Salle({
    required this.idSalle,
    required this.type,
    required this.nom,
    required this.capacite,
    required this.isDispo,
    required this.matieres,
    required this.datees,
    this.admin,
    this.emploi,
    required this.voeux,
    required this.cours,
  });

  factory Salle.fromJson(Map<String, dynamic> json) {
    return Salle(
      idSalle: json['idSalle']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      nom: json['nom']?.toString() ?? '',
      capacite: int.tryParse(json['capacite']?.toString() ?? '0') ?? 0,
      isDispo: json['isDispo'] as bool? ?? false,
      matieres: (json['matieres'] as List<dynamic>? ?? [])
          .map((item) => Matiere.fromJson(item as Map<String, dynamic>))
          .toList(),
      datees: (json['datees'] as List<dynamic>? ?? [])
          .map((item) => Datee.fromJson(item as Map<String, dynamic>))
          .toList(),
      admin: json['admin'] != null
          ? Admin.fromJson(json['admin'] as Map<String, dynamic>)
          : null,
      emploi: json['emploi'] != null
          ? Emploi.fromJson(json['emploi'] as Map<String, dynamic>)
          : null,
      voeux: (json['voeux'] as List<dynamic>? ?? [])
          .map((item) => Voeux.fromJson(item as Map<String, dynamic>))
          .toList(),
      cours: (json['cours'] as List<dynamic>? ?? [])
          .map((item) => Cours.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idSalle': idSalle,
      'type': type,
      'nom': nom,
      'capacite': capacite,
      'isDispo': isDispo,
      'matieres': matieres.map((item) => item.toJson()).toList(),
      'datees': datees.map((item) => item.toJson()).toList(),
      'admin': admin?.toJson(),
      'emploi': emploi?.toJson(),
      'voeux': voeux.map((item) => item.toJson()).toList(),
      'cours': cours.map((item) => item.toJson()).toList(),
    };
  }
}

// lib/models/specialite.dart
class Specialite {
  final String nom;
  final String description;

  Specialite({
    required this.nom,
    required this.description,
  });

  factory Specialite.fromJson(Map<String, dynamic> json) {
    return Specialite(
      nom: json['nom'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'description': description,
    };
  }
}

class User {
  final String idUser;
  final String nom;
  final String prenom;
  final String dateNaissance;
  final String email;
  final int cin;
  final String telephone;
  final String login;
  final String motDePasse;

  User({
    required this.idUser,
    required this.nom,
    required this.prenom,
    required this.dateNaissance,
    required this.email,
    required this.cin,
    required this.telephone,
    required this.login,
    required this.motDePasse,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      idUser: json['idUser']?.toString() ?? '',
      nom: json['nom']?.toString() ?? '',
      prenom: json['prenom']?.toString() ?? '',
      dateNaissance: json['dateNaissance']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      cin: int.tryParse(json['cin']?.toString() ?? '0') ?? 0,
      telephone: json['telephone']?.toString() ?? '',
      login: json['login']?.toString() ?? '',
      motDePasse: json['motDePasse']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idUser': idUser,
      'nom': nom,
      'prenom': prenom,
      'dateNaissance': dateNaissance,
      'email': email,
      'cin': cin,
      'telephone': telephone,
      'login': login,
      'motDePasse': motDePasse,
    };
  }
}

class Voeux {
  String? idVoeu;
  String? datee;
  String? matiere;
  String? enseignant;
  String? salle;
  String? admin;
  String typeVoeu;
  String dateSoumission;
  int priorite;
  String etat;
  String? commentaire;

  // Constructeur
  Voeux({
    this.idVoeu,
    this.datee,
    this.matiere,
    this.enseignant,
    this.salle,
    this.admin,
    required this.typeVoeu,
    required this.dateSoumission,
    required this.priorite,
    required this.etat,
    this.commentaire,
  });

  // Méthode fromJson
  factory Voeux.fromJson(Map<String, dynamic> json) {
    return Voeux(
      idVoeu: json['idVoeu'],
      datee: json['datee'],
      matiere: json['matiere'],
      enseignant: json['enseignant'],
      salle: json['salle'],
      admin: json['admin'],
      typeVoeu: json['typeVoeu'],
      dateSoumission: json['dateSoumission'],
      priorite: json['priorite'],
      etat: json['etat'],
      commentaire: json['commentaire'],
    );
  }

  // Méthode toJson
  Map<String, dynamic> toJson() => {
        "idVoeu": idVoeu,
        "datee": datee,
        "matiere": matiere,
        "enseignant": enseignant,
        "salle": salle,
        "admin": admin,
        "typeVoeu": typeVoeu,
        "dateSoumission": dateSoumission,
        "priorite": priorite,
        "etat": etat,
        "commentaire": commentaire,
      };
}

// lib/models/admin.dart
class Admin extends User {
  final String? role; // Made nullable since it can be null in response
  final List<Reclamation> reclamations;
  final List<Voeux> voeux;
  final List<Salle> salles;
  final List<Matiere> matieres;
  final List<Specialite> specialites;
  final List<Filiere> filieres;
  final List<Etudiant> etudiants;
  final List<Emploi> emplois;
  final List<GrpClass> grpClasses;
  final List<Enseignant> enseignants;

  Admin({
    required super.idUser,
    required super.nom,
    required super.prenom,
    required super.dateNaissance,
    required super.email,
    required super.cin,
    required super.telephone,
    required super.login,
    required super.motDePasse,
    this.role, // Made optional since it can be null
    this.reclamations = const [],
    this.voeux = const [],
    this.salles = const [],
    this.matieres = const [],
    this.specialites = const [],
    this.filieres = const [],
    this.etudiants = const [],
    this.emplois = const [],
    this.grpClasses = const [],
    this.enseignants = const [],
  });

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      idUser: json['idUser'] ?? '',
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      dateNaissance: json['dateNaissance'] ?? '',
      email: json['email'] ?? '',
      cin: json['cin'] ?? 0,
      telephone: json['telephone'] ?? '',
      login: json['login'] ?? '',
      motDePasse: json['motDePasse'] ?? '',
      role:
          json['role'], // No need to provide default value since it's nullable
      reclamations: _parseList(json['reclamations'], Reclamation.fromJson),
      voeux: _parseList(json['voeux'], Voeux.fromJson),
      salles: _parseList(json['salles'], Salle.fromJson),
      matieres: _parseList(json['matieres'], Matiere.fromJson),
      specialites: _parseList(json['specialites'], Specialite.fromJson),
      filieres: _parseList(json['filieres'], Filiere.fromJson),
      etudiants: _parseList(json['etudiants'], Etudiant.fromJson),
      emplois: _parseList(json['emplois'], Emploi.fromJson),
      grpClasses: _parseList(json['grpClasses'], GrpClass.fromJson),
      enseignants: _parseList(json['enseignants'], Enseignant.fromJson),
    );
  }

  // Helper method to safely parse lists
  static List<T> _parseList<T>(
      dynamic json, T Function(Map<String, dynamic>) fromJson) {
    if (json == null) return [];
    if (json is! List) return [];
    return json.whereType<Map<String, dynamic>>().map(fromJson).toList();
  }

  // Add toJson method for sending data back to server
  Map<String, dynamic> toJson() {
    return {
      'idUser': idUser,
      'nom': nom,
      'prenom': prenom,
      'dateNaissance': dateNaissance,
      'email': email,
      'cin': cin,
      'telephone': telephone,
      'login': login,
      'motDePasse': motDePasse,
      'role': role,
      // Only include these if you need to send them back to the server
      /* 
      'reclamations': reclamations.map((e) => e.toJson()).toList(),
      'voeux': voeux.map((e) => e.toJson()).toList(),
      'salles': salles.map((e) => e.toJson()).toList(),
      'matieres': matieres.map((e) => e.toJson()).toList(),
      'specialites': specialites.map((e) => e.toJson()).toList(),
      'filieres': filieres.map((e) => e.toJson()).toList(),
      'etudiants': etudiants.map((e) => e.toJson()).toList(),
      'emplois': emplois.map((e) => e.toJson()).toList(),
      'grpClasses': grpClasses.map((e) => e.toJson()).toList(),
      'enseignants': enseignants.map((e) => e.toJson()).toList(),
      */
    };
  }
  
}

// lib/models/cours.dart
class Cours {
  final String idCours;
  final Matiere matiere;
  final Enseignant enseignant;
  final GrpClass grpClass;
  final Emploi? emploi;

  Cours({
    required this.idCours,
    required this.matiere,
    required this.enseignant,
    required this.grpClass,
    this.emploi,
  });

  factory Cours.fromJson(Map<String, dynamic> json) {
    return Cours(
      idCours: json['idCours']?.toString() ?? '',
      matiere: json['matiere'] != null
          ? Matiere.fromJson(json['matiere'])
          : Matiere.defaultInstance(),
      enseignant: json['enseignant'] != null
          ? Enseignant.fromJson(json['enseignant'])
          : Enseignant.defaultInstance(),
      grpClass: json['grpClass'] != null
          ? GrpClass.fromJson(json['grpClass'])
          : GrpClass.defaultInstance(),
      emploi: json['emploi'] != null ? Emploi.fromJson(json['emploi']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idCours': idCours,
      'matiere': matiere.toJson(),
      'enseignant': enseignant.toJson(),
      'grpClass': grpClass.toJson(),
      'emploi': emploi?.toJson(),
    };
  }
}

// lib/models/datee.dart
class Datee {
  String? idDate; // Matches the MongoDB ID type
  String? jour;
  String? heure;
  List<Voeux>? voeux; // Reference to the list of Voeux
  List<Salle>? salles; // Reference to the list of Salles

  Datee({
    this.idDate,
    this.jour,
    this.heure,
    this.voeux,
    this.salles,
  });

  // Factory constructor to create an instance from a JSON object
  factory Datee.fromJson(Map<String, dynamic> json) {
    return Datee(
      idDate: json['idDate'] as String?,
      jour: json['jour'] as String?,
      heure: json['heure'] as String?,
      voeux: (json['voeux'] as List<dynamic>?)
          ?.map((item) => Voeux.fromJson(item as Map<String, dynamic>))
          .toList(),
      salles: (json['salles'] as List<dynamic>?)
          ?.map((item) => Salle.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  // Method to convert the instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'idDate': idDate,
      'jour': jour,
      'heure': heure,
      'voeux': voeux?.map((item) => item.toJson()).toList(),
      'salles': salles?.map((item) => item.toJson()).toList(),
    };
  }
}

// lib/models/emploi.dart
class Emploi {
  final String typeEmploi;
  final String jour;
  final String heureDebut;
  final String heureFin;
  final List<Enseignant> enseignant;
  final List<GrpClass> groupeClasse;
  final List<Salle> salle;
  final Matiere matiere;

  Emploi({
    required this.typeEmploi,
    required this.jour,
    required this.heureDebut,
    required this.heureFin,
    required this.enseignant,
    required this.groupeClasse,
    required this.salle,
    required this.matiere,
  });

  factory Emploi.fromJson(Map<String, dynamic> json) {
    return Emploi(
      typeEmploi: json['typeEmploi'],
      jour: json['jour'],
      heureDebut: json['heureDebut'],
      heureFin: json['heureFin'],
      enseignant: List<Enseignant>.from(
          json['enseignant'].map((x) => Enseignant.fromJson(x))),
      groupeClasse: List<GrpClass>.from(
          json['groupeClasse'].map((x) => GrpClass.fromJson(x))),
      salle: List<Salle>.from(json['salle'].map((x) => Salle.fromJson(x))),
      matiere: Matiere.fromJson(json['matiere']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'typeEmploi': typeEmploi,
      'jour': jour,
      'heureDebut': heureDebut,
      'heureFin': heureFin,
      'enseignant': List<dynamic>.from(enseignant.map((x) => x.toJson())),
      'groupeClasse': List<dynamic>.from(groupeClasse.map((x) => x.toJson())),
      'salle': List<dynamic>.from(salle.map((x) => x.toJson())),
      'matiere': matiere.toJson(),
    };
  }
}

class Enseignant extends User {
  final int nbHeure;
  final Grade? grade;
  final List<Matiere>? matieres;
  final Admin? admin;
  final List<Cours>? cours;
  final List<Filiere>? filieres;
  final List<Specialite>? specialites;
  final List<Reclamation>? reclamations;
  final Emploi? emploi;
  final List<Voeux>? voeux;

  Enseignant({
    required super.idUser,
    required super.nom,
    required super.prenom,
    required super.dateNaissance,
    required super.email,
    required super.cin,
    required super.telephone,
    required super.login,
    required super.motDePasse,
    required this.nbHeure,
    this.grade,
    this.matieres,
    this.admin,
    this.cours,
    this.filieres,
    this.specialites,
    this.reclamations,
    this.emploi,
    this.voeux,
  });

  factory Enseignant.fromJson(Map<String, dynamic> json) {
    return Enseignant(
      idUser: json['idUser'] ?? '',
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      dateNaissance: json['dateNaissance'] ?? '',
      email: json['email'] ?? '',
      cin: json['cin'],
      telephone: json['telephone'] ?? '',
      login: json['login'] ?? '',
      motDePasse: json['motDePasse'] ?? '',
      nbHeure: json['nbHeure'] ?? 0,
      grade: json['grade'] != null
          ? Grade.values.firstWhere(
              (e) => e.toString() == 'Grade.${json['grade']}',
              orElse: () => Grade.A)
          : null,
      matieres: json['matieres'] != null
          ? (json['matieres'] as List).map((e) => Matiere.fromJson(e)).toList()
          : [],
      admin: json['admin'] != null ? Admin.fromJson(json['admin']) : null,
      cours: json['cours'] != null
          ? (json['cours'] as List).map((e) => Cours.fromJson(e)).toList()
          : [],
      filieres: json['filieres'] != null
          ? (json['filieres'] as List).map((e) => Filiere.fromJson(e)).toList()
          : [],
      specialites: json['specialites'] != null
          ? (json['specialites'] as List)
              .map((e) => Specialite.fromJson(e))
              .toList()
          : [],
      reclamations: json['reclamations'] != null
          ? (json['reclamations'] as List)
              .map((e) => Reclamation.fromJson(e))
              .toList()
          : [],
      emploi: json['emploi'] != null ? Emploi.fromJson(json['emploi']) : null,
      voeux: json['voeux'] != null
          ? (json['voeux'] as List).map((e) => Voeux.fromJson(e)).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idUser': idUser,
      'nom': nom,
      'prenom': prenom,
      'dateNaissance': dateNaissance,
      'email': email,
      'cin': cin,
      'telephone': telephone,
      'login': login,
      'motDePasse': motDePasse,
      'nbHeure': nbHeure,
      'grade': grade?.toString().split('.').last,
      'matieres': matieres?.map((e) => e.toJson()).toList(),
      'admin': admin?.toJson(),
      'cours': cours?.map((e) => e.toJson()).toList(),
      'filieres': filieres?.map((e) => e.toJson()).toList(),
      'specialites': specialites?.map((e) => e.toJson()).toList(),
      'reclamations': reclamations?.map((e) => e.toJson()).toList(),
      'emploi': emploi?.toJson(),
      'voeux': voeux?.map((e) => e.toJson()).toList(),
    };
  }

  static Enseignant defaultInstance() {
    return Enseignant(
        idUser: '',
        nom: 'Default Enseignant',
        prenom: '',
        dateNaissance: '',
        cin: 0,
        email: '',
        telephone: '',
        login: '',
        motDePasse: '',
        nbHeure: 0);
  }
}

class Etudiant extends User {
  final int niveau;
  final GrpClass grpClass;
  final Admin? admin;

  Etudiant({
    required super.idUser,
    required super.nom,
    required super.prenom,
    required super.dateNaissance,
    required super.email,
    required super.cin,
    required super.telephone,
    required super.login,
    required super.motDePasse,
    required this.niveau,
    required this.grpClass,
    this.admin,
  });

  factory Etudiant.fromJson(Map<String, dynamic> json) {
    // Handle null or invalid grpClass data
    Map<String, dynamic> grpClassData = {};
    if (json['grpClass'] != null && json['grpClass'] is Map<String, dynamic>) {
      grpClassData = json['grpClass'] as Map<String, dynamic>;
    }

    return Etudiant(
      idUser: json['idUser']?.toString() ?? '',
      nom: json['nom']?.toString() ?? '',
      prenom: json['prenom']?.toString() ?? '',
      dateNaissance: json['dateNaissance']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      cin: int.tryParse(json['cin']?.toString() ?? '0') ?? 0,
      telephone: json['telephone']?.toString() ?? '',
      login: json['login']?.toString() ?? '',
      motDePasse: json['motDePasse']?.toString() ?? '',
      niveau: int.tryParse(json['niveau']?.toString() ?? '0') ?? 0,
      grpClass: GrpClass.fromJson(grpClassData),
      admin: json['admin'] != null && json['admin'] is Map<String, dynamic>
          ? Admin.fromJson(json['admin'] as Map<String, dynamic>)
          : null,
    );
  }


  Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = super.toJson();
  data.addAll({
    'niveau': niveau,
    'grpClass': grpClass.toJson(),
    if (admin != null) 'admin': admin!.toJson(),
  });
  return data;
}
}

class Filiere {
  final String idFiliere; // Add id as a class property
  final String nom;
  final List<Enseignant> enseignants;
  final Admin? admin;

  Filiere({
    required this.idFiliere, // Add id as a required parameter
    required this.nom,
    this.enseignants = const [],
    required this.admin,
  });

  // Serialize to JSON
  factory Filiere.fromJson(Map<String, dynamic> json) {
    return Filiere(
      idFiliere: json['idFiliere']?.toString() ?? '', // Convert to String
      nom: json['nom']?.toString() ?? '',
      enseignants: (json['enseignants'] as List<dynamic>?)
              ?.map((e) => Enseignant.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      admin: json['admin'] != null
          ? Admin.fromJson(json['admin'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idFiliere': idFiliere,
      'nom': nom,
      'enseignants': enseignants.map((e) => e.toJson()).toList(),
      'admin': admin?.toJson(),
    };
  }
}

// lib/models/grade.dart
enum Grade {
  A,
  B,
  C,
}

extension GradeExtension on Grade {
  String get description {
    switch (this) {
      case Grade.A:
        return 'Excellent';
      case Grade.B:
        return 'Good';
      case Grade.C:
        return 'Average';
      default:
        return '';
    }
  }
}

class GradeModel {
  final Grade grade;
  final String description;

  GradeModel({
    required this.grade,
    required this.description,
  });

  factory GradeModel.fromJson(Map<String, dynamic> json) {
    return GradeModel(
      grade: Grade.values
          .firstWhere((e) => e.toString() == 'Grade.' + json['grade']),
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'grade': grade.toString().split('.').last, // Extraire la valeur de l'énum
      'description': description,
    };
  }
}

class AuthResponse {
  final String role;
  final String id;

  AuthResponse({
    required this.role,
    required this.id,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      role: json['role'] ?? '',
      id: json['id'] ?? '',
    );
  }
}