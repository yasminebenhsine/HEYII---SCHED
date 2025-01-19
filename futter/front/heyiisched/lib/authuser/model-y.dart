// lib/models/grp_class.dart
class GrpClass {
  final String nom;
  final String niveau;

  GrpClass({
    required this.nom,
    required this.niveau,
  });

  factory GrpClass.fromJson(Map<String, dynamic> json) {
    return GrpClass(
      nom: json['nom'] ?? 'Default Group',
      niveau: json['niveau'],
    );
  }
  static GrpClass defaultInstance() {
    return GrpClass(nom: 'Default Group', niveau: '0');
  }

  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'niveau': niveau,
    };
  }
}

// lib/models/matiere.dart
class Matiere {
  final String nom;
  final String code;
  final int credits;

  Matiere({
    required this.nom,
    required this.code,
    required this.credits,
  });

  factory Matiere.fromJson(Map<String, dynamic> json) {
    return Matiere(
      nom: json['nom'],
      code: json['code'],
      credits: json['credits'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'code': code,
      'credits': credits,
    };
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
  String idSalle; // Changed from id to idSalle
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
    required this.idSalle, // Changed from id to idSalle
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
      idSalle: json['idSalle'] ?? '', // Changed from 'id' to 'idSalle'
      type: json['type'] ?? '',
      nom: json['nom'] ?? '',
      capacite: json['capacite'] ?? 0,
      isDispo: json['dispo'] ?? true, // Changed from 'isDispo' to 'dispo'
      matieres: (json['matieres'] as List?)
              ?.map((e) => Matiere.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      datees: (json['datees'] as List?)
              ?.map((e) => Datee.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      admin: json['admin'] != null
          ? Admin.fromJson(json['admin'] as Map<String, dynamic>)
          : null,
      emploi: json['emploi'] != null
          ? Emploi.fromJson(json['emploi'] as Map<String, dynamic>)
          : null,
      voeux: (json['voeux'] as List?)
              ?.map((e) => Voeux.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      cours: (json['cours'] as List?)
              ?.map((e) => Cours.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idSalle': idSalle, // Changed from 'id' to 'idSalle'
      'type': type,
      'nom': nom,
      'capacite': capacite,
      'dispo': isDispo, // Changed from 'isDispo' to 'dispo'
      'matieres': matieres.map((e) => e.toJson()).toList(),
      'datees': datees.map((e) => e.toJson()).toList(),
      'admin': admin?.toJson(),
      'emploi': emploi?.toJson(),
      'voeux': voeux.map((e) => e.toJson()).toList(),
      'cours': cours.map((e) => e.toJson()).toList(),
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
  late final String nom;
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
      idUser: json['idUser'],
      nom: json['nom'],
      prenom: json['prenom'],
      dateNaissance: json['dateNaissance'],
      email: json['email'],
      cin: json['cin'],
      telephone: json['telephone'],
      login: json['login'],
      motDePasse: json['motDePasse'],
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
  final String role;
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
    required this.role,
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
      idUser: json['idUser'],
      nom: json['nom'],
      prenom: json['prenom'],
      dateNaissance: json['dateNaissance'],
      email: json['email'],
      cin: json['cin'],
      telephone: json['telephone'],
      login: json['login'],
      motDePasse: json['motDePasse'],
      role: json['role'],
      reclamations: (json['reclamations'] as List?)
              ?.map((e) => Reclamation.fromJson(e))
              .toList() ??
          [],
      voeux: (json['voeux'] as List?)?.map((e) => Voeux.fromJson(e)).toList() ??
          [],
      salles:
          (json['salles'] as List?)?.map((e) => Salle.fromJson(e)).toList() ??
              [],
      matieres: (json['matieres'] as List?)
              ?.map((e) => Matiere.fromJson(e))
              .toList() ??
          [],
      specialites: (json['specialites'] as List?)
              ?.map((e) => Specialite.fromJson(e))
              .toList() ??
          [],
      filieres: (json['filieres'] as List?)
              ?.map((e) => Filiere.fromJson(e))
              .toList() ??
          [],
      etudiants: (json['etudiants'] as List?)
              ?.map((e) => Etudiant.fromJson(e))
              .toList() ??
          [],
      emplois:
          (json['emplois'] as List?)?.map((e) => Emploi.fromJson(e)).toList() ??
              [],
      grpClasses: (json['grpClasses'] as List?)
              ?.map((e) => GrpClass.fromJson(e))
              .toList() ??
          [],
      enseignants: (json['enseignants'] as List?)
              ?.map((e) => Enseignant.fromJson(e))
              .toList() ??
          [],
    );
  }
}

// lib/models/cours.dart
class Cours {
  final String nom;
  final String code;
  final int duree;

  Cours({
    required this.nom,
    required this.code,
    required this.duree,
  });

  factory Cours.fromJson(Map<String, dynamic> json) {
    return Cours(
      nom: json['nom'],
      code: json['code'],
      duree: json['duree'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'code': code,
      'duree': duree,
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
  final Grade? grade; // Make grade nullable
  final List<Matiere>? matieres; // Make other lists nullable too
  final Admin? admin;
  final List<Cours>? cours;
  final List<Filiere>? filieres;
  final List<Specialite>? specialites;
  final List<Reclamation>? reclamations;
  final Emploi? emploi; // Make emploi nullable
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
    this.grade, // Make it optional
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
      idUser: json['idUser'],
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      dateNaissance: json['dateNaissance'] ?? '',
      email: json['email'] ?? '',
      cin: json['cin'],
      telephone: json['telephone'] ?? '',
      login: json['login'] ?? '',
      motDePasse: json['motDePasse'] ?? '',
      nbHeure: json['nbHeure'] ?? 0,
      // Handle null grade
      grade: json['grade'] != null
          ? Grade.values.firstWhere(
              (e) => e.toString() == 'Grade.${json['grade']}',
              orElse: () => Grade.A) // Provide a default grade
          : null,
      // Handle null or empty lists
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
    return Etudiant(
      idUser: json['idUser'] ?? '', // Provide a default value if null
      nom: json['nom'] ?? 'Unknown', // Default to 'Unknown' if null
      prenom: json['prenom'] ?? 'Unknown', // Default to 'Unknown' if null
      dateNaissance: json['dateNaissance'] ?? '2000-01-01', // Default date
      email: json['email'] ?? '', // Default to an empty string
      cin: json['cin'] ?? '00000000', // Default to a placeholder CIN
      telephone: json['telephone'] ?? '00000000', // Default phone number
      login: json['login'] ?? 'default_login', // Default login value
      motDePasse: json['motDePasse'] ?? '', // Default password
      niveau: json['niveau'] ?? 0, // Default to 0 if null
      grpClass: json['grpClass'] != null
          ? GrpClass.fromJson(json['grpClass'])
          : GrpClass.defaultInstance(), // Handle null gracefully
      admin: json['admin'] != null ? Admin.fromJson(json['admin']) : null,
    );
  }
}

class Filiere {
  final int idFiliere; // Add id as a class property
  final String nom;
  final List<Enseignant> enseignants;

  Filiere({
    required this.idFiliere, // Add id as a required parameter
    required this.nom,
    required this.enseignants,
  });

  // Serialize to JSON
  Map<String, dynamic> toJson() {
    return {
      'idFiliere': idFiliere, // Include id in the JSON output
      'nom': nom,
      'enseignants': enseignants.map((e) => e.toJson()).toList(),
    };
  }

  // Deserialize from JSON
  factory Filiere.fromJson(Map<String, dynamic> json) {
    return Filiere(
      idFiliere: json['idFiliere'], // Include id in deserialization
      nom: json['nom'],
      enseignants: (json['enseignants'] as List)
          .map((e) => Enseignant.fromJson(e))
          .toList(),
    );
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