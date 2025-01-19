package com.example.heyii.repository;

import com.example.heyii.Entity.Matiere;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface MatiereRepository extends MongoRepository<Matiere, String> {
    Matiere findAllByIdMatiere(String id);

    List<Matiere> findAll();
    Matiere findByIdMatiere(String id);
    List<Matiere> findByNiveau(Long niveau);
    List<Matiere> findBySemestre(Long semestre);
    List<Matiere> findByType(String type);
    Matiere findByNom(String nom);
    // Vérifier l'existence d'une matière par nom et type
    boolean existsByNomAndTypeAndNiveauAndSemestre(String nom, String type);

    // Vérifier l'existence d'une matière par nom, type et id (pour update)
    boolean existsByNomAndTypeAndIdMatiere(String nom, String type, String id);

    boolean existsByNomAndTypeAndNiveauAndSemestre(String nom, String type, int niveau, int semestre);
}
