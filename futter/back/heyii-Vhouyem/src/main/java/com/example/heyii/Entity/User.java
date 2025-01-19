package com.example.heyii.Entity;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.io.Serializable;

@Document(collection = "user")
@Getter
@Setter
@ToString
public class User implements Serializable {


    @Id
    private String idUser; // Utilisation de String ou ObjectId pour l'ID dans MongoDB

    private String nom;
    private String prenom;

    public String getIdUser() {
        return idUser;
    }

    private String dateNaissance;
    private String email;
    private Long cin;
    private String telephone;
    private String login;
    private String motDePasse;

    public User() {
    }

    public User(String nom, String prenom, String email, String motDePasse, String login, String telephone, Long cin, String dateNaissance) {
        this.nom = nom;
        this.prenom = prenom;
        this.email = email;
        this.motDePasse = motDePasse;
        this.login = login;
        this.telephone = telephone;
        this.cin = cin;
        this.dateNaissance = dateNaissance;
    }
}
