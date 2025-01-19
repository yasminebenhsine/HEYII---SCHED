package com.example.heyii.service;

import com.example.heyii.Entity.Cours;
import com.example.heyii.Entity.Enseignant;
import com.example.heyii.Entity.Grade;

import java.util.List;

public interface IEnseignantService {
    List<Enseignant> findAll();
    Enseignant findById(String id);
    Enseignant addEnseignant(Enseignant enseignant);
    Enseignant updateEnseignant(String id, Enseignant updatedEnseignant);
    void deleteEnseignant(String id);
    List<Enseignant> findByGrade(Grade grade);
    List<Cours> findCoursByEnseignant(String enseignantId);
}