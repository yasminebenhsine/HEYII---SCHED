package com.example.heyii.service;
import com.example.heyii.Entity.*;

import java.util.List;

public interface ICoursService {
    List<Cours> findAll();
    Cours findById(String id);
    Cours addCours(Cours cours);
    Cours updateCours(String id, Cours updatedCours);
    void deleteCours(String id);

    List<Cours> findByMatiere(Matiere matiere);
    List<Cours> findByEnseignant(Enseignant enseignant);
    List<Cours> findByGrpClass(GrpClass grpClass);
    List<Cours> findByEmploi(Emploi emploi);
}

