package com.example.heyii.Entity;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;

import java.io.Serializable;
import java.time.LocalTime;
import java.util.List;

@Getter
@Setter
@ToString
@Document(collection = "emploi")
public class Emploi implements Serializable {

    @Id
    private String idEmploi;

    private String typeEmploi; // enseignant, étudiant, salle
    private String jour;
    private LocalTime heureDebut;
    private LocalTime heureFin;

    @DBRef  // Référence MongoDB pour la relation
    private List<Enseignant> enseignants;

    @DBRef  // Référence MongoDB pour la relation
    private List<Salle> salles;

    @DBRef  // Référence MongoDB pour la relation
    private List<GrpClass> grpClasses;

    @DBRef  // Référence MongoDB pour la relation
    private Admin admin;

    @DBRef  // Référence MongoDB pour la relation
    private List<Cours> cours;

    // Constructeur par défaut
    public Emploi() {}

    // Constructeur avec paramètres
    public Emploi(String idEmploi) {
        this.idEmploi = idEmploi;
    }

    // Constructeur avec paramètres
    public Emploi(String typeEmploi, String jour, LocalTime heureDebut, LocalTime heureFin,
                  List<Enseignant> enseignants, List<GrpClass> grpClasses, List<Salle> salles) {
        this.typeEmploi = typeEmploi;
        this.jour = jour;
        this.heureDebut = heureDebut;
        this.heureFin = heureFin;
        this.enseignants = enseignants;
        this.grpClasses = grpClasses;
        this.salles = salles;
    }
}
