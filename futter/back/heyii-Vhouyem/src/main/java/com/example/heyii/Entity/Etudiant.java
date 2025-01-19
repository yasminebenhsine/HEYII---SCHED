package com.example.heyii.Entity;

import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.util.List;

@Document(collection = "etudiants")
@Getter
@Setter
@ToString
public class Etudiant extends User {

    private Long niveau;

    // Utilisation de DBRef pour référencer un autre document dans MongoDB
    @DBRef
    private GrpClass grpClass;

    @DBRef
    private Admin admin;

    public Etudiant() {
    }

    public Etudiant(String nom, String prenom, String email, String motDePasse, String login, String telephone, Long cin, String dateNaissance, Long niveau, GrpClass grpClass) {
        super(nom, prenom, email, motDePasse, login, telephone, cin, dateNaissance);
        this.niveau = niveau;
        this.grpClass = grpClass;
    }
}