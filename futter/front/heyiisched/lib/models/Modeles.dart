import 'package:heyiisched/models/Matiere_salle.dart';

class GrpClass {
  String idGrp;
  String nom;
  List<Etudiant?> etudiants; // Changed to allow null students
  Specialite? specialite; // Made nullable
  Filiere filiere;
  Emploi? emploi;
  Admin? admin;
  List<Cours>? cours; // Made nullable

  GrpClass({
    required this.idGrp,
    required this.nom,
    required this.etudiants,
    this.specialite, // Made optional
    required this.filiere,
    this.emploi,
    this.admin,
    this.cours, // Made optional
  });

  factory GrpClass.fromJson(Map<String, dynamic> json) {
    return GrpClass(
      idGrp: json['idGrp'] ?? '',
      nom: json['nom'] ?? '',
      etudiants: (json['etudiants'] as List<dynamic>?)?.map((etudiantJson) {
            if (etudiantJson == null) return null;
            try {
              return Etudiant.fromJson(etudiantJson as Map<String, dynamic>);
            } catch (e) {
              print('Error parsing student: $e');
              return null;
            }
          }).toList() ??
          [],
      specialite: json['specialite'] == null
          ? null
          : Specialite.fromJson(json['specialite'] as Map<String, dynamic>),
      filiere: json['filiere'] == null
          ? Filiere(nom: '', idFiliere: '', enseignants: [])
          : Filiere.fromJson(json['filiere'] as Map<String, dynamic>),
      emploi: json['emploi'] == null
          ? null
          : Emploi.fromJson(json['emploi'] as Map<String, dynamic>),
      admin: json['admin'] == null
          ? null
          : Admin.fromJson(json['admin'] as Map<String, dynamic>),
      cours: (json['cours'] as List<dynamic>?)
          ?.map((coursJson) {
            if (coursJson == null) return null;
            try {
              return Cours.fromJson(coursJson as Map<String, dynamic>);
            } catch (e) {
              print('Error parsing course: $e');
              return null;
            }
          })
          .where((cours) => cours != null)
          .cast<Cours>()
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idGrp': idGrp,
      'nom': nom,
      'etudiants': etudiants
          .map((etudiant) => etudiant?.toJson())
          .where((json) => json != null)
          .toList(),
      'specialite': specialite?.toJson(),
      'filiere': filiere.toJson(),
      'emploi': emploi?.toJson(),
      'admin': admin?.toJson(),
      'cours': cours?.map((cours) => cours.toJson()).toList(),
    };
  }
}

class Reclamation {
  String? idReclamation;
  String text;
  String sujet;
  String date;
  bool isLu;
  String statut;
  Enseignant enseignant;
  Admin? admin;

  // Constructeur
  Reclamation({
    this.idReclamation,
    required this.text,
    required this.sujet,
    required this.date,
    required this.isLu,
    required this.statut,
    required this.enseignant,
    this.admin,
  });

  // Factory pour créer une instance de Reclamation depuis un JSON
  factory Reclamation.fromJson(Map<String, dynamic> json) {
    return Reclamation(
      idReclamation: json['_id'] ?? '',
      text: json['text'],
      sujet: json['sujet'],
      date: json['date'],
      isLu: json['isLu'],
      statut: json['statut'] ?? 'EN_ATTENTE',
      enseignant: Enseignant.fromJson(json['enseignant']),
      admin: Admin.fromJson(json['admin']),
    );
  }

  // Méthode pour convertir une instance de Reclamation en JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': idReclamation,
      'text': text,
      'sujet': sujet,
      'date': date,
      'isLu': isLu,
      'statut': statut,
      'enseignant': enseignant.toJson(),
      'admin': admin?.toJson(),
    };
  }
}

enum StatutReclamation {
  ACCEPTEE,
  REFUSEE,
  EN_ATTENTE,
}

class Salle {
  String id;
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
    required this.id,
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
    if (json == null) {
      throw Exception("Invalid JSON data for Salle");
    }
    return Salle(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      nom: json['nom'] ?? '',
      capacite: json['capacite'] != null ? json['capacite'] as int : 0,
      isDispo: json['isDispo'] ?? false,
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
      'id': id, // Ensure 'id' is always present
      'type': type,
      'nom': nom,
      'capacite': capacite,
      'isDispo': isDispo,
      'matieres': matieres.map((e) => e.toJson()).toList(),
      'datees': datees.map((e) => e.toJson()).toList(),
      'admin': admin?.toJson(), // Optional, check if null
      'emploi': emploi?.toJson(), // Optional, check if null
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
      nom: json['nom'] ?? 'Nom par défaut', // Valeur par défaut si null
      description: json['description'] ??
          'Description par défaut', // Valeur par défaut si null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'description': description,
    };
  }
}

// lib/models/user.dart
class User {
  final String idUser; // String or ObjectId for MongoDB ID
  String nom;
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
      idUser: json['_id'] ?? '', // MongoDB ObjectId mapping
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
      '_id': idUser, // MongoDB ObjectId key
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

/*class Voeux {
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


*/
class Voeux {
  String idVoeu;
  Datee? datee;
  Matiere? matiere;
  Enseignant? enseignant;
  Salle? salle;
  Admin? admin;
  String typeVoeu;
  DateTime dateSoumission;
  int priorite;
  String etat;
  String? commentaire;

  Voeux({
    required this.idVoeu,
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
      idVoeu: json['idVoeu'] ?? '', // Vérification si null
      datee: json['datee'] != null ? Datee.fromJson(json['datee']) : null,
      matiere:
          json['matiere'] != null ? Matiere.fromJson(json['matiere']) : null,
      enseignant: json['enseignant'] != null
          ? Enseignant.fromJson(json['enseignant'])
          : null,
      salle: json['salle'] != null ? Salle.fromJson(json['salle']) : null,
      admin: json['admin'] != null ? Admin.fromJson(json['admin']) : null,
      typeVoeu: json['typeVoeu'] ?? '', // Vérification si null
      dateSoumission:
          DateTime.parse(json['dateSoumission'] ?? DateTime.now().toString()),
      priorite: json['priorite'] ?? 0, // Valeur par défaut si null
      etat: json['etat'] ?? 'Soumis', // Valeur par défaut
      commentaire: json['commentaire'] is String
          ? json['commentaire']
          : json['commentaire']?.toString(),
    );
  }

  // Méthode toJson
  Map<String, dynamic> toJson() {
    return {
      'idVoeu': idVoeu,
      'datee': datee?.toJson(),
      'matiere': matiere?.toJson(),
      'enseignant': enseignant?.toJson(),
      'salle': salle?.toJson(),
      'admin': admin?.toJson(),
      'typeVoeu': typeVoeu,
      'dateSoumission': dateSoumission.toIso8601String(),
      'priorite': priorite,
      'etat': etat,
      'commentaire': commentaire,
    };
  }
}

extension VoeuxExtension on Voeux {
  Voeux copyWith({
    String? idVoeu,
    Datee? datee,
    Matiere? matiere,
    Enseignant? enseignant,
    Salle? salle,
    Admin? admin,
    String? typeVoeu,
    DateTime? dateSoumission,
    int? priorite,
    String? etat,
    String? commentaire,
  }) {
    return Voeux(
      idVoeu: idVoeu ?? this.idVoeu,
      datee: datee ?? this.datee,
      matiere: matiere ?? this.matiere,
      enseignant: enseignant ?? this.enseignant,
      salle: salle ?? this.salle,
      admin: admin ?? this.admin,
      typeVoeu: typeVoeu ?? this.typeVoeu,
      dateSoumission: dateSoumission ?? this.dateSoumission,
      priorite: priorite ?? this.priorite,
      etat: etat ?? this.etat,
      commentaire: commentaire ?? this.commentaire,
    );
  }
}

// lib/models/admin.dart
class Admin {
  String nom;
  String? prenom;
  String? email;
  String? motDePasse;
  String? login;
  String? telephone;
  String? cin;
  String? dateNaissance;
  String? role;

  Admin({
    required this.nom,
    this.prenom,
    this.email,
    this.motDePasse,
    this.login,
    this.telephone,
    this.cin,
    this.dateNaissance,
    this.role,
  });

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      nom: json['nom'],
      prenom: json['prenom'],
      email: json['email'],
      motDePasse: json['motDePasse'],
      login: json['login'],
      telephone: json['telephone'],
      cin: json['cin'],
      dateNaissance: json['dateNaissance'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'motDePasse': motDePasse,
      'login': login,
      'telephone': telephone,
      'cin': cin,
      'dateNaissance': dateNaissance,
      'role': role,
    };
  }
}

// lib/models/cours.dart
/*class Cours {
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

  get type => null;

  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'code': code,
      'duree': duree,
    };
  }
}*/
class Cours {
  final String idCours;
  final String nom;
  final String type;
  final int semestre;
  final int niveau;
  final Matiere? matiere;
  Enseignant? enseignant;

  Cours({
    required this.idCours,
    required this.nom,
    required this.type,
    required this.semestre,
    required this.niveau,
    this.matiere,
    this.enseignant,
  });

  factory Cours.fromJson(Map<String, dynamic> json) {
    return Cours(
      idCours: json['_id'] ?? '',
      nom: json['nom'] ?? '',
      type: json['type'] ?? '',
      semestre: json['semestre'] ?? 0,
      niveau: json['niveau'] ?? 0,
      matiere: Matiere.fromJson(json['matiere'] ?? {}),
      enseignant: Enseignant.fromJson(json['enseignant'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': idCours,
      'nom': nom,
      'type': type,
      'semestre': semestre,
      'niveau': niveau,
      'matiere': matiere?.toJson(),
      'enseignant': enseignant?.toJson(),
    };
  }
}

// lib/models/datee.dart
class Datee {
  final String jour;
  final String mois;
  final int annee;

  Datee({
    required this.jour,
    required this.mois,
    required this.annee,
  });

  factory Datee.fromJson(Map<String, dynamic> json) {
    return Datee(
      jour: json['jour'],
      mois: json['mois'],
      annee: json['annee'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'jour': jour,
      'mois': mois,
      'annee': annee,
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
  final List<Salle> salles;
  final List<Cours>? cours;
  final Matiere matiere;

  Emploi({
    required this.typeEmploi,
    required this.jour,
    required this.heureDebut,
    required this.heureFin,
    required this.enseignant,
    required this.groupeClasse,
    required this.salles,
    this.cours,
    required this.matiere,
  });
  factory Emploi.fromJson(Map<String, dynamic> json) {
    return Emploi(
      typeEmploi: json['typeEmploi'] ?? '', // Valeur par défaut vide si null
      jour: json['jour'] ?? '', // Valeur par défaut vide si null
      heureDebut: json['heureDebut'] ?? '', // Valeur par défaut vide si null
      heureFin: json['heureFin'] ?? '', // Valeur par défaut vide si null
      enseignant: json['enseignant'] != null
          ? List<Enseignant>.from(
              json['enseignant'].map((x) => Enseignant.fromJson(x)))
          : [], // Liste vide si enseignant est null
      groupeClasse: json['groupeClasse'] != null
          ? List<GrpClass>.from(
              json['groupeClasse'].map((x) => GrpClass.fromJson(x)))
          : [], // Liste vide si groupeClasse est null
      /*salle: json['salle'] != null 
      ? List<Salle>.from(json['salle'].map((x) => Salle.fromJson(x)))
      : [],  */ // Liste vide si salle est null
      salles:
          (json['salles'] as List?)?.map((x) => Salle.fromJson(x)).toList() ??
              [],
      cours: json['cours'] != null
          ? (json['cours'] as List)
              .map((e) => e != null ? Cours.fromJson(e) : null)
              .whereType<Cours>()
              .toList()
          : [],
      // Liste vide si cours est null
      matiere: Matiere.fromJson(
          json['matiere'] ?? {}), // Valeur par défaut vide si null
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
      'salles': List<dynamic>.from(salles.map((x) => x.toJson())),
      'cours': List<dynamic>.from(cours!.map((x) => x.toJson())),
      'matiere': matiere.toJson(),
    };
  }
}

/*
  factory Emploi.fromJson(Map<String, dynamic> json) {
    return Emploi(
      typeEmploi: json['typeEmploi'],
      jour: json['jour'],
      heureDebut: json['heureDebut'],
      heureFin: json['heureFin'],
      enseignant: List<Enseignant>.from(json['enseignant'].map((x) => Enseignant.fromJson(x))),
      groupeClasse: List<GrpClass>.from(json['groupeClasse'].map((x) => GrpClass.fromJson(x))),
      salle: List<Salle>.from(json['salle'].map((x) => Salle.fromJson(x))),
      cours: (json['cours'] as List).map((e) => Cours.fromJson(e)).toList(),
      matiere: Matiere.fromJson(json['matiere']),
    );
  }
*/
class Enseignant {
  String id;
  final String? nom;
  final String prenom;
  final String email;
  final int nbHeure;
  final Grade? grade; // Make grade nullable
  final List<Matiere> matieres;
  final List<Cours> cours;
  final List<Filiere> filieres;
  final List<Specialite> specialites;
  final List<Reclamation> reclamations;
  final Emploi? emploi; // Make emploi nullable
  final List<Voeux> voeux;

  Enseignant({
    required this.id,
    this.nom,
    required this.prenom,
    required this.email,
    required this.nbHeure,
    this.grade, // Nullable
    required this.matieres,
    required this.cours,
    required this.filieres,
    required this.specialites,
    required this.reclamations,
    this.emploi, // Nullable
    required this.voeux,
  });

  factory Enseignant.fromJson(Map<String, dynamic> json) {
    return Enseignant(
      id: json['idUser'] ?? '', // Ensure the ID is always present
      nom: json['nom'] ?? 'Nom inconnu', // Default if null
      prenom: json['prenom'] ?? 'Prénom inconnu', // Default if null
      email: json['email'] ?? 'Email inconnu', // Default if null
      nbHeure: json['nbHeure'] ?? 0,
      grade: json['grade'] != null
          ? Grade.values
              .firstWhere((e) => e.toString() == 'Grade.' + json['grade'])
          : null,
      matieres: (json['matieres'] as List?)
              ?.map((item) => Matiere.fromJson(item))
              .toList() ??
          [],
      cours: (json['cours'] as List?)
              ?.map((item) => Cours.fromJson(item))
              .toList() ??
          [],
      filieres: (json['filieres'] as List?)
              ?.map((item) => Filiere.fromJson(item))
              .toList() ??
          [],
      specialites: (json['specialites'] as List?)
              ?.map((item) => Specialite.fromJson(item))
              .toList() ??
          [],
      reclamations: (json['reclamations'] as List?)
              ?.map((item) => Reclamation.fromJson(item))
              .toList() ??
          [],
      emploi: json['emploi'] != null ? Emploi.fromJson(json['emploi']) : null,
      voeux: (json['voeux'] as List?)
              ?.map((item) => Voeux.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idUser': id,
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'nbHeure': nbHeure,
      'grade': grade?.toString().split('.').last ?? '', // Handle nullable grade
      'matieres': matieres.map((item) => item.toJson()).toList(),
      'cours': cours.map((item) => item.toJson()).toList(),
      'filieres': filieres.map((item) => item.toJson()).toList(),
      'specialites': specialites.map((item) => item.toJson()).toList(),
      'reclamations': reclamations.map((item) => item.toJson()).toList(),
      'emploi': emploi?.toJson(),
      'voeux': voeux.map((item) => item.toJson()).toList(),
    };
  }
}

/*factory Enseignant.fromJson(Map<String, dynamic> json) {
    return Enseignant(
      id: json['idUser'] ?? '',  // Ensure the ID is always present
      nom: json['nom'] ?? 'Nom inconnu',  // Default if null
      prenom: json['prenom'] ?? 'Prénom inconnu',  // Default if null
      email: json['email'] ?? 'Email inconnu',  // Default if null
      nbHeure: json['nbHeure'] ?? 0,
      grade: json['grade'] != null ? Grade.values.firstWhere((e) => e.toString() == 'Grade.' + json['grade']) : null, // Handle null
      matieres: (json['matieres'] as List).map((item) => Matiere.fromJson(item)).toList(),
      cours: (json['cours'] as List).map((item) => Cours.fromJson(item)).toList(),
      filieres: (json['filieres'] as List).map((item) => Filiere.fromJson(item)).toList(),
      specialites: (json['specialites'] as List).map((item) => Specialite.fromJson(item)).toList(),
      reclamations: (json['reclamations'] as List).map((item) => Reclamation.fromJson(item)).toList(),
      emploi: json['emploi'] != null ? Emploi.fromJson(json['emploi']) : null,  // Handle null emploi
      voeux: (json['voeux'] as List).map((item) => Voeux.fromJson(item)).toList(),
    );
  }*/
class Etudiant extends User {
  final String id;
  final Filiere filiere;
  final int niveau;
  final GrpClass grpClass;

  Etudiant({
    required String idUser, // From User
    required String nom, // From User
    required String prenom, // From User
    required String dateNaissance, // From User
    required String email, // From User
    required String telephone, // From User
    required int cin, // From User
    required String login, // From User
    required String motDePasse, // From User
    required this.id,
    required this.filiere,
    required this.niveau,
    required this.grpClass,
  }) : super(
          idUser: idUser,
          nom: nom,
          prenom: prenom,
          dateNaissance: dateNaissance,
          email: email,
          telephone: telephone,
          cin: cin,
          login: login,
          motDePasse: motDePasse,
        ); // Call the parent constructor

  factory Etudiant.fromJson(Map<String, dynamic> json) {
    return Etudiant(
      idUser: json['idUser'] ?? '',
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      dateNaissance: json['dateNaissance'] ?? '',
      email: json['email'] ?? '',
      telephone: json['telephone'] ?? '',
      cin: json['cin'] ?? 0, // Valeur par défaut si null
      login: json['login'] ?? '',
      motDePasse: json['motDePasse'] ?? '',
      id: json['id'] ?? '',
      filiere: json['filiere'] != null
          ? Filiere.fromJson(json['filiere'])
          : Filiere(
              nom: '', idFiliere: '', enseignants: []), // Valeur par défaut
      niveau: json['niveau'] ?? 0, // Valeur par défaut si null
      grpClass: json['grpClass'] != null
          ? GrpClass.fromJson(json['grpClass'])
          : GrpClass(
              idGrp: '',
              nom: '',
              etudiants: [],
              specialite: Specialite(nom: '', description: ''),
              filiere: Filiere(nom: '', idFiliere: '', enseignants: []),
              cours: [],
            ),
    );
  }

  Map<String, dynamic> toJson() {
    final userJson = super.toJson(); // Get JSON from the User class
    return {
      ...userJson,
      'id': id,
      'filiere': filiere.toJson(),
      'niveau': niveau,
      'grpClass': grpClass.toJson(),
    };
  }
}

class Filiere {
  final String idFiliere; // Modifié de int à String
  final String nom;
  final List<dynamic>
      enseignants; // Gardez cette structure dynamique si elle varie
  final Admin? admin;

  Filiere({
    required this.idFiliere,
    required this.nom,
    required this.enseignants,
    this.admin,
  });

  factory Filiere.fromJson(Map<String, dynamic> json) {
    return Filiere(
      idFiliere: json['idFiliere'],
      nom: json['nom'],
      enseignants: json['enseignants'] ?? [],
      admin: json['admin'],
    );
  }

  // Ajout de la méthode toJson
  Map<String, dynamic> toJson() {
    return {
      'idFiliere': idFiliere,
      'nom': nom,
      'enseignants': enseignants,
      'admin': admin,
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



// lib/models/matiere.dart

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
/*class Reclamation {
  final String text;
  final String date;
  final bool isLu;
  final StatutReclamation statut;
   Enseignant? enseignant;
  //final Admin admin;

  Reclamation({
    required this.text,
    required this.date,
    required this.isLu,
    required this.statut,
     this.enseignant,
    //required this.admin,
  });

  factory Reclamation.fromJson(Map<String, dynamic> json) {
    return Reclamation(
      text: json['text'],
      date: json['date'],
      isLu: json['isLu'],
      statut: StatutReclamation.values.firstWhere((e) => e.toString() == 'StatutReclamation.' + json['statut']),
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
      'enseignant': enseignant?.toJson(),
      //'admin': admin.toJson(),
    };
  }
}*/
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
