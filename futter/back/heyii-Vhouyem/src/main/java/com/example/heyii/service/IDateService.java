package com.example.heyii.service;

import com.example.heyii.Entity.Datee;
import com.example.heyii.Entity.Salle;
import com.example.heyii.Entity.Voeux;

import java.util.List;

public interface IDateService {
    // Obtenir toutes les dates
    List<Datee> getAllDates();

    // Obtenir une date par ID
    Datee getDateById(String id);

    // Ajouter une nouvelle date
    Datee addDate(Datee datee);

    // Mettre à jour une date existante
    Datee updateDate(String id, Datee updatedDatee);

    // Supprimer une date par ID
    boolean deleteDate(String id);
}
