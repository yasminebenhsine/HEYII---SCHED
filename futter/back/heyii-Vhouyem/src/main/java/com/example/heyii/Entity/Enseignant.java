package com.example.heyii.Entity;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.List;

@Getter
@Setter
@ToString
@Document(collection = "enseignants")
public class Enseignant extends User {

    private Long nbHeure;

    private Grade grade;  // MongoDB gère les enums sans problème, donc pas besoin de @Enumerated

    @DBRef  // Référence MongoDB pour la relation Many-to-Many
    private List<Matiere> matieres;

    @DBRef  // Référence MongoDB pour la relation Many-to-One
    private Admin admin;

    @DBRef  // Référence MongoDB pour la relation One-to-Many
    private List<Cours> cours;

    @DBRef  // Référence MongoDB pour la relation Many-to-Many
    private List<Filiere> filieres;

    @DBRef  // Référence MongoDB pour la relation Many-to-Many
    private List<Specialite> specialites;

    @DBRef  // Référence MongoDB pour la relation One-to-Many
    private List<Reclamation> reclamations;

    @DBRef  // Référence MongoDB pour la relation Many-to-One
    private Emploi emploi;

    @DBRef  // Référence MongoDB pour la relation One-to-Many
    private List<Voeux> voeux;

    public Enseignant() {
    }

    /*public Enseignant(String id) {

        this.setIdUser(id);
    }*/

    public Enseignant(String nom, String prenom, String email, String motDePasse, String login, String telephone, Long cin, String dateNaissance, Long nbHeure, Grade grade, List<Filiere> filieres, List<Reclamation> reclamations) {
        super(nom, prenom, email, motDePasse, login, telephone, cin, dateNaissance);
        this.nbHeure = nbHeure;
        this.grade = grade;
        this.filieres = filieres;
        this.reclamations = reclamations;
    }
    public String getIdEnseignant() {
        return getIdUser(); // Appel de la méthode getId() héritée de la classe User
    }

    public Enseignant(String id) {
        // Assurez-vous que l'ID est bien initialisé
        if (id != null && !id.isEmpty()) {
            this.setIdUser(id);  // Assurez-vous que cette méthode fonctionne comme prévu
        } else {
            throw new IllegalArgumentException("ID de l'enseignant est manquant");
        }
    }


}