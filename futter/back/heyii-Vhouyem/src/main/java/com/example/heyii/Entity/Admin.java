package com.example.heyii.Entity;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.List;

@Document(collection = "admins")
@Getter
@Setter
@ToString
public class Admin extends User {

    private String role;

    @DBRef  // Référence MongoDB pour la relation
    private List<Reclamation> reclamations;

    @DBRef  // Référence MongoDB pour la relation
    private List<Voeux> voeux;

    @DBRef  // Référence MongoDB pour la relation
    private List<Salle> salles;

    @DBRef  // Référence MongoDB pour la relation
    private List<Matiere> matieres;

    @DBRef  // Référence MongoDB pour la relation
    private List<Specialite> specialites;

    @DBRef  // Référence MongoDB pour la relation
    private List<Filiere> filieres;

    @DBRef  // Référence MongoDB pour la relation
    private List<Etudiant> etudiants;

    @DBRef  // Référence MongoDB pour la relation
    private List<Emploi> emplois;

    @DBRef  // Référence MongoDB pour la relation
    private List<GrpClass> grpClasses;

    @DBRef  // Référence MongoDB pour la relation
    private List<Enseignant> enseignants;

    // Constructeur par défaut
    public Admin() {
    }

    // Constructeur avec paramètres
    public Admin(String nom, String prenom, String email, String motDePasse, String login, String telephone, Long cin, String dateNes, String role) {
        super(nom, prenom, email, motDePasse, login, telephone, cin, dateNes);
        this.role = role;
    }
}
