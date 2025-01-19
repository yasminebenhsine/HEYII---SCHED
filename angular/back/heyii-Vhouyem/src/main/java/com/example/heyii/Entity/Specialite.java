package com.example.heyii.Entity;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonValue;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.io.Serializable;
import java.util.List;

@Document(collection = "specialite")
@Getter
@Setter
@ToString
public class Specialite implements Serializable {
    @Id
    private String idSpecialite; // Utilisez String ou ObjectId pour l'ID dans MongoDB

    private String nom;

    @DBRef
    private List<Matiere> matieres;

    @DBRef
    private Admin admin;

    public Specialite() {}
    public Specialite(String nom) {
        this.nom = nom;
    }


    public Specialite(String nom, List<Matiere> matieres, Admin admin) {
        this.nom = nom;
        this.matieres = matieres;
        this.admin = admin;
    }
}