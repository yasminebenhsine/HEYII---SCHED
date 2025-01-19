package com.example.heyii.Entity;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.io.Serializable;
import java.util.List;

@Document(collection = "grpClasses")
@Getter
@Setter
@ToString
public class GrpClass implements Serializable {

    @Id
    private String idGrp;

    private String nom;

    @DBRef
    private List<Etudiant> etudiants;

    @DBRef
    private Specialite specialite;

    @DBRef
    private Filiere filiere;

    @DBRef
    private Emploi emploi;

    @DBRef
    private Admin admin;

    @DBRef
    private List<Cours> cours;

    public GrpClass() {}
    public GrpClass(String nom ,Specialite specialite, Filiere filiere) {
        this.nom = nom;
        this.specialite = specialite;
        this.filiere = filiere;
    }

    public GrpClass(String nom, List<Etudiant> etudiants, Specialite specialite, Filiere filiere, Emploi emploi) {
        this.nom = nom;
        this.etudiants = etudiants;
        this.specialite = specialite;
        this.filiere = filiere;
        this.emploi = emploi;
    }

    public GrpClass(String idGrp) {
        this.idGrp = idGrp;
    }
}
