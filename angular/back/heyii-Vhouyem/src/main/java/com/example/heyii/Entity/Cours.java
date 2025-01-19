package com.example.heyii.Entity;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;

import java.io.Serializable;

@Getter
@Setter
@ToString
@Document(collection = "cours")
public class Cours implements Serializable {

    @Id
    private String idCours;

    private Matiere matiere;

    @DBRef  // Référence MongoDB pour la relation
    private Enseignant enseignant;

    @DBRef  // Référence MongoDB pour la relation
    private GrpClass grpClass;

    @DBRef  // Référence MongoDB pour la relation
    private Emploi emploi;

    // Constructeur par défaut
    public Cours() {
    }

    // Constructeur avec paramètres
    public Cours(Matiere matiere, Enseignant enseignant, GrpClass groupeClasse, Emploi emploiDuTemps) {
        this.matiere = matiere;
        this.enseignant = enseignant;
        this.grpClass = groupeClasse;
        this.emploi = emploiDuTemps;
    }
}