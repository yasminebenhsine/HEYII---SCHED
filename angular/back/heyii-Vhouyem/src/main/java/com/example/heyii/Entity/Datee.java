package com.example.heyii.Entity;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.io.Serializable;
import java.util.List;

@Document(collection = "datee")
@Getter
@Setter
@ToString
public class Datee implements Serializable {
    @Id
    private String idDate; // Utilisez String ou ObjectId pour l'ID dans MongoDB

    private String jour;
    private String heure;

    @DBRef
    private List<Voeux> voeux;

    @DBRef
    private List<Salle> salles;

    public Datee() {}

    public Datee(String jour, String heure, List<Salle> salles, List<Voeux> voeux) {
        this.jour = jour;
        this.heure = heure;
        this.salles = salles;
        this.voeux = voeux;
    }
}
