package com.example.heyii.service;

import com.example.heyii.Entity.Matiere;

import java.util.List;

public interface IMatiereService {
    List<Matiere> findAll();

    Matiere findByIdMatiere(String id);

    Matiere addMatiere(Matiere matiere);

    void deleteMatiere(String id);

    Matiere updateMatiere(String id, Matiere updatedMatiere);

    boolean existsByIdMatiere(String id);

    List<Matiere> findByNiveau(Long niveau);

    List<Matiere> findBySemestre(Long semestre);

    List<Matiere> findByType(String type);

    Matiere findByNom(String nom);
}
