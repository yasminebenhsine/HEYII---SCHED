package com.example.heyii.Entity;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.io.Serializable;
import java.time.LocalDateTime;

@Document(collection = "voeux")
@Getter
@Setter
@ToString
public class Voeux implements Serializable {
    @Id
    private String idVoeu;  // Utilisation de String ou ObjectId pour l'ID dans MongoDB

    private Datee datee;
    private Matiere matiere;
    private Enseignant enseignant;
    private Salle salle;
    private Admin admin;

    private String typeVoeu; //(Demande de cours, Disponibilités, Changement de salle, Ajout de matière, Changement d'horaire)
    private LocalDateTime dateSoumission;
    private int priorite;
    private String etat = "Soumis";  // (soumis, validé, rejeté)
    private String commentaire;

    public Voeux() {
    }

    public Voeux(Datee datee, Matiere matiere, Enseignant enseignant, Admin admin, String typeVoeu,
                 LocalDateTime dateSoumission, int priorite, String etat, String commentaire, Salle salle) {
        this.datee = datee;
        this.matiere = matiere;
        this.enseignant = enseignant;
        this.admin = admin;
        this.typeVoeu = typeVoeu;
        this.dateSoumission = dateSoumission;
        this.priorite = priorite;
        this.etat = etat;
        this.commentaire = commentaire;
        this.salle = salle;
    }

    // Méthode de pré-insertion pour définir la date de soumission
    public void onCreate() {
        this.dateSoumission = LocalDateTime.now();
    }
}
