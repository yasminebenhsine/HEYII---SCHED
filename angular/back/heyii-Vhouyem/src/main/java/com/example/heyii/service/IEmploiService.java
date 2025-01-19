package com.example.heyii.service;

import com.example.heyii.Entity.Cours;
import com.example.heyii.Entity.Emploi;
import com.example.heyii.Entity.Salle;

import java.util.List;
import java.util.Optional;

public interface IEmploiService {
    List<Emploi> getAllEmplois();
    Optional<Emploi> getEmploiById(String id);
    Emploi saveEmploi(Emploi emploi);
    Emploi updateEmploi(String id, Emploi emploi);
    void deleteEmploi(String id);

    List<Salle> getAllSalles();

    List<Cours> getAllCours();
}
