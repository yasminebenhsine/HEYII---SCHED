package com.example.heyii.Entity;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.io.Serializable;

@Document(collection = "reclamations")
@Getter
@Setter
@ToString
public class Reclamation implements Serializable {
    @Id
    private String idReclamation; // Use String or ObjectId for ID in MongoDB

    private String text;
    private String date;
    private String sujet;

    private boolean isLu = false;

    // Store enum as a String (MongoDB will store it as a String by default)
    private String statut = "EN_ATTENTE";

    @DBRef
    private Enseignant enseignant;

    @DBRef
    private Admin admin;

    public Reclamation() {}

    public Reclamation(String text,String sujet, String date, boolean isLu, String statut, Enseignant enseignant) {
        this.text = text;
        this.date = date;
        this.isLu = isLu;
        this.statut = statut;
        this.enseignant = enseignant;
        this.sujet=sujet;
    }

}
/*package com.example.heyii.Entity;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.io.Serializable;

@Document(collection = "reclamations")
@Getter
@Setter
@ToString
public class Reclamation implements Serializable {
    @Id
    private String idReclamation; // Use String or ObjectId for ID in MongoDB

    private String text;
    private String date;
    private String sujet;

    private boolean isLu = false;

    // Store enum as a String (MongoDB will store it as a String by default)
    private String statut = "EN_ATTENTE";

    @DBRef
    private Enseignant enseignant;

    @DBRef
    private Admin admin;

    public Reclamation() {}

    public Reclamation(String text,String sujet, String date, boolean isLu, String statut, Enseignant enseignant) {
        this.text = text;
        this.date = date;
        this.isLu = isLu;
        this.statut = statut;
        this.enseignant = enseignant;
        this.sujet=sujet;
    }

}*/