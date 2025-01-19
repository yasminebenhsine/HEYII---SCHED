package com.example.heyii.service;

import com.example.heyii.Entity.Etudiant;
import com.example.heyii.Entity.Matiere;

import java.util.List;

public interface IEtudiantService {
    List<Etudiant> findAll();

    Etudiant addEtudiant(Etudiant etudiant);

    Etudiant updateEtudiant(String id, Etudiant updatedEtudiant);

    void deleteEtudiant(String id);

}