package com.example.heyii.Entity;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.io.Serializable;
import java.util.List;

@Document(collection = "salles")
@Getter
@Setter
@ToString
public class Salle implements Serializable {
    @Id
    private String idSalle; // Utiliser String ou ObjectId pour l'ID dans MongoDB

    private String type;
    private String nom;
    private Long capacite;

    private boolean isDispo = true;

    @DBRef
    private List<Matiere> matieres;

    @DBRef
    private List<Datee> datees;

    @DBRef
    private Admin admin;

    @DBRef
    private Emploi emploi;

    @DBRef
    private List<Voeux> voeux;

    @DBRef
    private List<Cours> cours;

    public Salle() {}

    public Salle(String type, String nom, Long capacite, boolean isDispo, List<Matiere> matieres, List<Datee> dates, Admin admin) {
        this.type = type;
        this.nom = nom;
        this.capacite = capacite;
        this.isDispo = isDispo;
        this.matieres = matieres;
        this.datees = dates;
        this.admin = admin;
    }

    public Salle(String idSalle) {
        this.idSalle=idSalle;
    }
}
