package com.example.heyii.Entity;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;
import lombok.*;

import java.io.Serializable;
import java.util.List;

@Document(collection = "filieres")
@Getter
@Setter
@ToString
public class Filiere implements Serializable {

    @Id
    private String idFiliere;  // ID de type String (ObjectId généré par MongoDB)

    private String nom;

    @DBRef
    private List<Enseignant> enseignants;

    @DBRef
    private Admin admin;

    public Filiere() {}

    public Filiere(String nom, List<Enseignant> enseignants, Admin admin) {
        this.nom = nom;
        this.enseignants = enseignants;
        this.admin = admin;
    }
}
