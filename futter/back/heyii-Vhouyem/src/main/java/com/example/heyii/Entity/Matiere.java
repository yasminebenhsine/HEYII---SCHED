package com.example.heyii.Entity;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.io.Serializable;
import java.util.List;

@Document(collection = "matieres")
@Getter
@Setter
@ToString
public class Matiere implements Serializable {

    @Id
    private String idMatiere; // Utiliser String ou ObjectId pour l'ID dans MongoDB

    private String nom;
    private String type;
    private Long semestre;
    private Long niveau;

    @DBRef
    private List<Salle> salles;

    @DBRef
    private List<Specialite> specialites;

    @DBRef
    private List<Cours> cours;

    @DBRef
    private List<Enseignant> enseignants;

    @DBRef
    private List<Voeux> voeux;

    @DBRef
    private Admin admin;

    public Matiere() {
    }

    public Matiere(String idMatiere) {
        this.idMatiere = idMatiere;
    }

    public Matiere(String nom, String type, Long semestre, Long niveau, List<Salle> salles,
                   List<Specialite> specialites, Admin admin) {
        this.nom = nom;
        this.type = type;
        this.semestre = semestre;
        this.niveau = niveau;
        this.salles = salles;
        this.specialites = specialites;
        this.admin = admin;
    }
}
